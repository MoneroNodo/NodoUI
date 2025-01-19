#include "NodoFeedsControl.h"
#include "NodoSystemControl.h"

const QString html_start = "<!DOCTYPE html> <html> <head> <style> body { background-color: rgba(255,255,255,0.0); font-family: 'Inter Display'; font-size: 46px;  color: ";
const QString html_part_1 = ";} a { color: ";
const QString html_part_2 = "; text-decoration: none; } </style> </head> <body>";
const QString html_end = "</body> </html>";

NodoFeedsControl::NodoFeedsControl(NodoNetworkManager *networkManager, NodoSystemControl *systemControl)
{
    m_textColor = "#F5F5F5";

    m_timer = new QTimer(this);
    m_networkManager = networkManager;
    m_systemControl = systemControl;
    m_feedParser = new NodoFeedParser();

    m_feeds_str = m_feedParser->readFeedKeys();

    int sourceCount = m_feedParser->getFeedCount();

    for(int i = 0; i < sourceCount; i++)
    {
        m_rss_source_t tmp;
        tmp.downloadStatus = (m_feeds_str[i].selectedItem == true) ? FEED_STATUS_DOWNLOADABLE : FEED_STATUS_DONT_DOWNLOAD;
        m_rss_sources.push_back(tmp);
    }

    connect(m_networkManager, SIGNAL(networkStatusChanged()), this, SLOT(checkConnectionStatus()));
    connect(m_timer, SIGNAL(timeout()), this, SLOT(downloadRSSContent()));
    connect(&m_downloadManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(downloadFinished(QNetworkReply*)));

    if(m_networkManager->isConnected())
    {
        m_timer->start(500);
    }
}

void NodoFeedsControl::checkConnectionStatus(void)
{
    if(m_networkManager->isConnected())
    {
        m_timer->start(2000);
    }
    else
    {
        m_timer->stop();
    }
}

void NodoFeedsControl::prepareDownload(int index)
{
    m_rss_sources[index].downloadStatus = FEED_STATUS_DOWNLOADING;
    QNetworkRequest request(m_feeds_str.at(index).uriItem);
    m_rss_sources[index].reply = m_downloadManager.get(request);
    connect(m_rss_sources[index].reply, SIGNAL(sslErrors(QList<QSslError>)), SLOT(sslErrors(QList<QSslError>)));
}

void NodoFeedsControl::downloadRSSContent(void)
{
    if (!m_systemControl->isFeedsEnabled())
        return;
    if (m_systemControl->istorProxyEnabled())
    {
        QNetworkProxy torProxy;
        torProxy.setType(QNetworkProxy::Socks5Proxy);
        torProxy.setHostName("127.0.0.1");
        torProxy.setPort(9050);
        m_downloadManager.setProxy(torProxy);
    }
    else
    {
        QNetworkProxy noProxy;
        noProxy.setType(QNetworkProxy::NoProxy);
        m_downloadManager.setProxy(noProxy);
    }
    for(int index = 0; index < m_feeds_str.size(); index++)
    {
        if((m_rss_sources[index].downloadStatus == FEED_STATUS_DOWNLOADED)
            || (m_rss_sources[index].downloadStatus == FEED_STATUS_DOWNLOAD_FAILED))
        {
            m_rss_sources[index].downloadStatus = FEED_STATUS_DOWNLOADABLE;
            m_rss_sources[index].m_feeds.clear();
        }

        if(m_rss_sources[index].downloadStatus == FEED_STATUS_DOWNLOADABLE)
        {
            prepareDownload(index);
        }
    }
    m_timer->start(DOWNLOAD_PERIOD_IN_SECS*1000);
}

bool NodoFeedsControl::getVisibleState(int index)
{
    return m_feeds_str[index].visibleItem;
}

void NodoFeedsControl::sslErrors(const QList<QSslError> &sslErrors)
{
#ifndef QT_NO_SSL
    foreach (const QSslError &error, sslErrors)
        qDebug() << "SSL error: " << qPrintable(error.errorString());
#else
    Q_UNUSED(sslErrors);
#endif
}

void NodoFeedsControl::downloadFinished(QNetworkReply *reply)
{
    QUrl url = reply->url();

    if (reply->error()) {
        qDebug() << "Download of " << url.toEncoded().constData() << " failed: " << qPrintable(reply->errorString());
        reply->deleteLater();
        return;
    }
    int index = m_feedParser->getIndexFromUri(url);

    if(-1 == index)
    {
        qDebug() << "something went wrong. the URL: " << url;
        reply->deleteLater();
        return;
    }
    pugi::xml_document doc;
    doc.load_string(reply->readAll());

    int counter = 0;
    for (pugi::xpath_node xn : doc.select_nodes(".//*[self::entry or self::item]")) {
        feed_fields_t parser;
        if (counter++ >= m_feeds_str.at(index).numOfFeedsToShowItem)
        {
            break;
        }

        parser.timeStamp = QString::fromStdString(xn.node().child(m_feeds_str.at(index).pub_date_tag.toStdString().c_str()).text().get());

        if (parser.timeStamp != nullptr) {
            QDateTime qdt = QDateTime::fromString(parser.timeStamp);

            if (qdt.isValid() &&
                qdt.toUTC().daysTo(QDateTime::currentDateTimeUtc()) > 30) // filter articles older than ~1 month
                continue;
        }

        parser.channelName = m_feeds_str.at(index).nameItem;
        parser.author = QString::fromStdString(xn.node().child("auth").text().get());
        parser.title = QString::fromStdString(xn.node().child("title").text().get());
        QString desc = QString::fromStdString(xn.node().child(m_feeds_str.at(index).description_tag.toStdString().c_str()).text().get());
        desc.replace(QRegularExpression("\\&amp;#x(\\d{4});"), "\\u\\1");
        parser.description.append(html_start)
            .append(m_textColor)
            .append(html_part_1)
            .append(m_textColor)
            .append(html_part_2)
            .append(desc)
            .append(html_end);

        //search for image
        for (pugi::xml_node n : xn.node().children())
        {
            std::string name = n.name();
            if(name == m_feeds_str.at(index).image_tag.toStdString().c_str())
            {
                parser.imgPath = QString::fromStdString(n.attribute(m_feeds_str.at(index).image_attr_tag.toStdString().c_str()).value());
            }
        }

        m_rss_sources[index].m_feeds.push_back(parser);
    }

    m_rss_sources[index].downloadStatus = FEED_STATUS_DOWNLOADED;
    m_rss_sources[index].reply->deleteLater();
    reply->deleteLater();
}

void NodoFeedsControl::setRSSSelectionState(int index, bool state)
{
    if(m_feeds_str[index].selectedItem == state)
    {
        return;
    }

    m_feedParser->writeFeedKeys(KEY_SELECTED, index, state);
    m_feeds_str.clear();
    m_feeds_str = m_feedParser->readFeedKeys();

    if(true == state)
    {
        prepareDownload(index);
    }
    else
    {
        m_rss_sources[index].downloadStatus = FEED_STATUS_DONT_DOWNLOAD;
    }
}

QString NodoFeedsControl::getRSSName(const int sourceIndex)
{
    return m_feeds_str[sourceIndex].nameItem;
}

int NodoFeedsControl::getDisplayedItemCount(const int sourceIndex)
{
    return m_rss_sources[sourceIndex].m_feeds.count();
}

QString NodoFeedsControl::getItemTitle(const int sourceIndex, const int feedIndex)
{
    return m_rss_sources[sourceIndex].m_feeds[feedIndex].title;
}

QString NodoFeedsControl::getItemDescription(const int sourceIndex, const int feedIndex)
{
    return m_rss_sources[sourceIndex].m_feeds[feedIndex].description;
}

QString NodoFeedsControl::getItemChannel(const int sourceIndex, const int feedIndex)
{
    return m_rss_sources[sourceIndex].m_feeds[feedIndex].channelName;
}

QString NodoFeedsControl::getItemTag(const int sourceIndex, const int feedIndex)
{
    return m_rss_sources[sourceIndex].m_feeds[feedIndex].subtagName;
}

QString NodoFeedsControl::getItemAuth(const int sourceIndex, const int feedIndex)
{
    return m_rss_sources[sourceIndex].m_feeds[feedIndex].author;
}

QString NodoFeedsControl::getItemTimestamp(const int sourceIndex, const int feedIndex)
{
    return m_rss_sources[sourceIndex].m_feeds[feedIndex].timeStamp;
}

QString NodoFeedsControl::getItemImage(const int sourceIndex, const int feedIndex)
{
    return m_rss_sources[sourceIndex].m_feeds[feedIndex].imgPath;
}

int NodoFeedsControl::getNumOfRSSSource(void)
{
    return MAX_FEED_SOURCE_COUNT;
}

void NodoFeedsControl::setTextColor(QString textColor)
{
    m_textColor = textColor;
}

bool NodoFeedsControl::isRSSSourceSelected(const int sourceIndex)
{
    return m_feeds_str[sourceIndex].selectedItem;
}
