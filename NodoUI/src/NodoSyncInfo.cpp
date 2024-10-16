#include "NodoSyncInfo.h"

NodoSyncInfo::NodoSyncInfo(NodoSystemStatusParser *systemStatusParser) {
    m_statusParser = systemStatusParser;
    connect(m_statusParser, SIGNAL(systemStatusReady()), this, SLOT(updateStatus()));
}

void NodoSyncInfo::updateStatus(void)
{
    m_height = m_statusParser->getIntValueFromKey("height");
    m_targetHeight = m_statusParser->getIntValueFromKey("target_height");
    m_synced = m_statusParser->getBoolValueFromKey("synchronized");

    // qDebug() << "m_height " << m_height << "m_targetHeight " << m_targetHeight << "synced " << m_synced;

    if(m_targetHeight > 0)
    {
        m_syncPercentage = (int)(((double)m_height/(double)m_targetHeight)*100);
    }
    else
    {
        m_syncPercentage = -1;
    }

    if(m_synced)
    {
        m_syncPercentage = 100;
    }

    if(100 == m_syncPercentage)
    {
        emit syncDone();
    }

    emit syncStatusReady();
}

int NodoSyncInfo::getSyncPercentage(void)
{
    if(!m_synced)
    {
        if(m_targetHeight == 0)
        {
            return -1;
        }
    }

    return m_syncPercentage;
}
