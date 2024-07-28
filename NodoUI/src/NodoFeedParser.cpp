#include "NodoFeedParser.h"

NodoFeedParser::NodoFeedParser(QObject *parent)
{
    QString val;
    QFile file;
    file.setFileName(m_json_file_name);
    if(file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        val = file.readAll();
        file.close();

        m_document = QJsonDocument::fromJson(val.toUtf8());
        m_rootObj = m_document.object();
        m_feedsObj = m_rootObj[feedObjName].toObject();
    }
    else
    {
        qDebug() << "couldn't open config file " + m_json_file_name;
    }
}

bool NodoFeedParser::isFeedValid(int index)
{
    if(!m_allFeedParams.at(index).uriItem.isEmpty() &&
        m_allFeedParams.at(index).visibleItem &&
        (m_allFeedParams.at(index).numOfFeedsToShowItem > 0) &&
        m_allFeedParams.at(index).selectedItem)
    {
        return true;
    }
    return false;
}

QVector<feed_tags_t> NodoFeedParser::readFeedKeys(void)
{
    m_allFeedParams.clear();

    if(m_feedsObj.isEmpty())
    {
        qDebug() << "couldn't find feed keys";
        m_feedCount = MAX_FEED_SOURCE_COUNT;

        for(int i = 0; i < m_feedCount; i++)
        {
            feed_tags_t tmp_feeds;
            tmp_feeds.nameItem = "";
            tmp_feeds.uriItem = "";
            tmp_feeds.selectedItem = false;
            tmp_feeds.visibleItem = false;
            tmp_feeds.numOfFeedsToShowItem = 0;
            tmp_feeds.description_tag = "";
            tmp_feeds.image_tag = "";
            tmp_feeds.image_attr_tag = "";
            tmp_feeds.pub_date_tag = "";

            m_allFeedParams.push_back(tmp_feeds);
        }
        return m_allFeedParams;
    }

    m_feedCount = m_feedsObj.size();
    if(m_feedCount > MAX_FEED_SOURCE_COUNT)
    {
        m_feedCount = MAX_FEED_SOURCE_COUNT;
    }

    for(int i = 0; i < m_feedCount; i++)
    {
        feed_tags_t tmp_feeds;
        QJsonObject feeds_obj = m_feedsObj[m_feedNames + QString::number(i, 10)].toObject();
        QJsonValue jsonValue = feeds_obj.value(m_feedKeyList[KEY_NAME]);
        tmp_feeds.nameItem = jsonValue.toString();

        jsonValue = feeds_obj.value(m_feedKeyList[KEY_URI]);
        tmp_feeds.uriItem = jsonValue.toString();

        jsonValue = feeds_obj.value(m_feedKeyList[KEY_SELECTED]);
        tmp_feeds.selectedItem = jsonValue.toBool();

        jsonValue = feeds_obj.value(m_feedKeyList[KEY_VISIBLE]);
        tmp_feeds.visibleItem = jsonValue.toBool();

        jsonValue = feeds_obj.value(m_feedKeyList[KEY_NUM_OF_FEEDS_TO_SHOW]);
        tmp_feeds.numOfFeedsToShowItem = jsonValue.toInt();

        jsonValue = feeds_obj.value(m_feedKeyList[KEY_DESCRIPTION_TAG]);
        tmp_feeds.description_tag = jsonValue.toString();

        jsonValue = feeds_obj.value(m_feedKeyList[KEY_IMAGE_TAG]);
        tmp_feeds.image_tag = jsonValue.toString();

        jsonValue = feeds_obj.value(m_feedKeyList[KEY_IMAGE_ATTR]);
        tmp_feeds.image_attr_tag = jsonValue.toString();

        jsonValue = feeds_obj.value(m_feedKeyList[KEY_PUB_DATE_TAG]);
        tmp_feeds.pub_date_tag = jsonValue.toString();

        m_allFeedParams.push_back(tmp_feeds);
    }
    return m_allFeedParams;
}

void NodoFeedParser::writeFeedKeys(feed_keys_t key, int index, bool state)
{
    if(m_feedsObj.isEmpty())
    {
        return;
    }

    QJsonObject feeds = m_feedsObj[m_feedNames + QString::number(index, 10)].toObject();
    feeds.insert(m_feedKeyList[key], state);
    m_feedsObj.insert(m_feedNames + QString::number(index, 10), feeds);
    writeJson();
}

int NodoFeedParser::getFeedCount(void)
{
    return m_feedCount;
}

void NodoFeedParser::writeJson(void)
{
    QFile file;

    m_rootObj.insert(feedObjName, m_feedsObj);
    m_document.setObject(m_rootObj);
    file.setFileName(m_json_file_name);
    file.open(QFile::WriteOnly | QFile::Text | QFile::Truncate);
    file.write(m_document.toJson());
    file.close();
}

int NodoFeedParser::getIndexFromUri(const QUrl &url)
{
    for(int i = 0; i < m_allFeedParams.size(); i++)
    {
        if(isFeedValid(i))
        {
            if(m_allFeedParams.at(i).uriItem == url.toString())
            {
                return i;
            }
        }
    }

    return  -1;
}
