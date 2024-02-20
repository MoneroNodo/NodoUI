#include "NodoFeedParser.h"
#include "pugixml.hpp"

//const QString html_start = "<!DOCTYPE html> <html> <head> <link href='https://fonts.googleapis.com/css?family=Urbanist' rel='stylesheet'> <style> body { background-color: rgba(255,255,255,0.0); font-family: 'Urbanist'; font-size: 20px;  color: red;} a { color: red; text-decoration: none; } </style> </head> <body>";
//const QString html_end = "</body> </html>";


const QString html_start = "<!DOCTYPE html> <html> <head> <link href='https://fonts.googleapis.com/css?family=Urbanist' rel='stylesheet'> <style> body { background-color: rgba(255,255,255,0.0); font-family: 'Urbanist'; font-size: 20px;  color: ";

//red

const QString html_part_1 = ";} a { color: ";

//red

const QString html_part_2 = "; text-decoration: none; } </style> </head> <body>";
const QString html_end = "</body> </html>";


NodoFeedParser::NodoFeedParser(NodoEmbeddedUIConfigParser *embeddedUIConfigParser) : QObject(embeddedUIConfigParser)
{
    m_RSSPostCount = 0;
    m_RSSCount = 0;
    m_receivedRSSCount = 0;
    m_textColor = "yellow";

    m_embeddedUIConfigParser = embeddedUIConfigParser;
    connect(&m_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(downloadFinished(QNetworkReply*)));
    connect(this, SIGNAL(feedReceived()), this, SLOT(updateFeedList()));
}

bool NodoFeedParser::isFeedValid(int index)
{
    if(!m_feeds_str.at(index).uriItem.isEmpty() &&
        m_feeds_str.at(index).visibleItem &&
        (m_feeds_str.at(index).numOfFeedsToShowItem > 0) &&
        m_feeds_str.at(index).selectedItem)
    {
        return true;
    }
    return false;
}

void NodoFeedParser::request(void)
{
    m_RSSPostCount = 0;
    m_RSSCount = 0;
    m_receivedRSSCount = 0;
    m_all_posts.clear();

    m_feeds_str.clear();
    m_feeds_str = m_embeddedUIConfigParser->readFeedKeys();

    for(int i = 0; i < MAX_FEED_COUNT; i++)
    {
        m_feeds[i].clear();
    }

    for(int i = 0; i < m_feeds_str.size(); i++)
    {
        if(isFeedValid(i))
        {
            m_RSSCount++;
            doDownload(QUrl(m_feeds_str.at(i).uriItem));
        }
    }
}


// Constructs a QList of QNetworkReply
void NodoFeedParser::doDownload(const QUrl &url)
{
    QNetworkRequest request(url);
    QNetworkReply *reply = m_manager.get(request);

#ifndef QT_NO_SSL
    connect(reply, SIGNAL(sslErrors(QList<QSslError>)), SLOT(sslErrors(QList<QSslError>)));
#endif

    // List of reply
    m_currentDownloads.append(reply);
}

int NodoFeedParser::getIndexFromUri(const QUrl &url)
{
    for(int i = 0; i < m_feeds_str.size(); i++)
    {
        if(isFeedValid(i))
        {
            if(m_feeds_str.at(i).uriItem == url.toString())
            {
                return i;
            }
        }
    }

    return  -1;
}

void NodoFeedParser::downloadFinished(QNetworkReply *reply)
{
    QUrl url = reply->url();

    if (reply->error()) {
        qDebug() << "Download of " << url.toEncoded().constData() << " failed: " << qPrintable(reply->errorString());
    }
    else {
		
        pugi::xml_document doc;
        int index = getIndexFromUri(url);
        doc.load(reply->readAll());
		
        post_t parser;
        int counter = 0;
        for (pugi::xpath_node xn : doc.select_nodes(".//*[self::entry or self::item]")) {
            if (counter++ >= m_feeds_str.at(index).numOfFeedsToShowItem)
            {
                break;
            }

            parser.channelName = m_feeds_str.at(index).nameItem;
            parser.author = QString::fromStdString(xn.node().child("auth").text().get());
            parser.timeStamp = QString::fromStdString(xn.node().child(m_feeds_str.at(index).pub_date_tag.toStdString().c_str()).text().get());
            parser.title = QString::fromStdString(xn.node().child("title").text().get());
            //parser.description.append(html_start).append(QString::fromStdString(xn.node().child(m_feeds_str.at(index).description_tag.toStdString().c_str()).text().get())).append(html_end);
            parser.description.append(html_start)
                              .append(m_textColor)
                              .append(html_part_1)
                              .append(m_textColor)
                              .append(html_part_2)
                              .append(QString::fromStdString(xn.node().child(m_feeds_str.at(index).description_tag.toStdString().c_str()).text().get())).append(html_end);

            //search for image
            for (pugi::xml_node n : xn.node().children())
            {
                std::string name = n.name();
                if(name == m_feeds_str.at(index).image_tag.toStdString().c_str())
                {
                    parser.imgPath = QString::fromStdString(n.attribute(m_feeds_str.at(index).image_attr_tag.toStdString().c_str()).value());
                }
            }

            m_RSSPostCount++;
			m_feeds[index].push_back(parser);
        }

        emit feedReceived();
    }

    m_currentDownloads.removeAll(reply);
    reply->deleteLater();
	
}

void NodoFeedParser::updateFeedList(void)
{
    m_receivedRSSCount++;
    if(m_receivedRSSCount != m_RSSCount)
    {
        return;
    }

    for(int i = 0; i < m_feeds_str.size(); i++)
    {
        if(isFeedValid(i))
        {
            for(int j = 0; j < m_feeds_str.at(i).numOfFeedsToShowItem; j++)
            {
                m_all_posts.append(m_feeds[i].at(j));
            }
        }
    }
    emit postListReady();
}

void NodoFeedParser::sslErrors(const QList<QSslError> &sslErrors)
{
#ifndef QT_NO_SSL
    foreach (const QSslError &error, sslErrors)
        qDebug() << "SSL error: " << qPrintable(error.errorString());
#else
    Q_UNUSED(sslErrors);
#endif
}

int NodoFeedParser::getItemCount(void)
{
    return m_RSSPostCount;
}

QString NodoFeedParser::getItemTitle(const int index)
{
    return m_all_posts[index].title;
}

QString NodoFeedParser::getItemDescription(const int index)
{
    return m_all_posts[index].description;
}

QString NodoFeedParser::getItemChannel(const int index)
{
    return m_all_posts[index].channelName;
}

QString NodoFeedParser::getItemTag(const int index)
{
    return m_all_posts[index].subtagName;
}

QString NodoFeedParser::getItemAuth(const int index)
{
    return m_all_posts[index].author;
}

QString NodoFeedParser::getItemTimestamp(const int index)
{
    return m_all_posts[index].timeStamp;
}

QString NodoFeedParser::getItemImage(const int index)
{
    return m_all_posts[index].imgPath;
}

void NodoFeedParser::updateRequested(void)
{
    QTimer::singleShot(100, this, SLOT(request()));
}

void NodoFeedParser::setTextColor(QString textColor)
{
    m_textColor = textColor;
}
