#ifndef TRANSLATOR_H
#define TRANSLATOR_H

#include <QDir>
#include <QObject>
#include <QQmlEngine>
#include <QTranslator>

#include "NodoConfigParser.h"

class Translator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList languages READ languages NOTIFY languagesChanged)
    // Q_PROPERTY(QString currentLanguage READ currentLanguage /*NOTIFY currentLanguageChanged*/)

public:
    explicit Translator(NodoConfigParser *configParser = Q_NULLPTR, QQmlEngine *engine = Q_NULLPTR);

    QStringList languages() const;

    void initTranslator();
    Q_INVOKABLE void setLanguageIndex(int index);
    Q_INVOKABLE int getLanguageIndex(void);


signals:
    // void languageChanged();
    void languagesChanged();
    // void currentLanguageChanged();

private:
    const QString extension = ".qm";
    QTranslator *m_translator;
    QQmlEngine *m_engine;
    QStringList m_languages;
    QStringList m_language_codes;
    QString m_currentLanguage;
    QDir m_dir;
    NodoConfigParser *m_configParser;

    QString languageByCode(const QString &code);
    QString currentLanguage();
    void setLanguageByCode(const QString &code);
};

#endif // TRANSLATOR_H
