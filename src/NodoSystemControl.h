#ifndef NODO_SYSTEM_CONTROL_H
#define NODO_SYSTEM_CONTROL_H
#include <QObject>
#include "NodoConfigParser.h"

class NodoSystemControl : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool appTheme READ getAppTheme WRITE setAppTheme NOTIFY appThemeChanged)

public:
    NodoSystemControl(NodoConfigParser *configParser = Q_NULLPTR);

    bool getAppTheme(void);
    void setAppTheme(bool appTheme);


    Q_INVOKABLE void setVisibleState(int index, bool state);
    Q_INVOKABLE bool getVisibleState(int index);

    Q_INVOKABLE void setSelectedState(int index, bool state);
    Q_INVOKABLE bool getSelectedState(int index);

    Q_INVOKABLE QString getFeederNameState(int index);

    Q_INVOKABLE void setScreenSaverType(int state);
    Q_INVOKABLE int getScreenSaverType(void);

    Q_INVOKABLE void setScreenSaverTimeout(int timeout);
    Q_INVOKABLE int getScreenSaverTimeout(void);

    Q_INVOKABLE void setScreenSaverItemChangeTimeout(int timeout);
    Q_INVOKABLE int getScreenSaverItemChangeTimeout(void);

signals:
    void appThemeChanged(bool);

private:
    bool m_appTheme;
    QVector< feeds_t > m_feeds_str;
    display_settings_t m_displaySettings;
    NodoConfigParser *m_configParser;
};


#endif // NODO_SYSTEM_CONTROL_H
