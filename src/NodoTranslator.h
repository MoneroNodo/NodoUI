#ifndef TRANSLATOR_H
#define TRANSLATOR_H

#include <QDir>
#include <QObject>
#include <QQmlEngine>
#include <QTranslator>

class Translator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList languages READ languages NOTIFY languagesChanged)
    Q_PROPERTY(QString currentLanguage READ currentLanguage NOTIFY currentLanguageChanged)

public:
    explicit Translator(QQmlEngine *engine, QObject *parent = nullptr);

    QStringList languages() const;
    QString currentLanguage();
    void initTranslator();

    Q_INVOKABLE void selectLanguage(const QString & language);
    Q_INVOKABLE QString languageByCode(const QString & code);


signals:
    void languageChanged();
    void languagesChanged();
    void currentLanguageChanged();

private:
    const QString extension = ".qm";
    QQmlEngine *m_engine;
    QTranslator *m_translator;
    QStringList m_languages;
    QString m_currentLanguage;
    QDir m_dir;
};

#endif // TRANSLATOR_H
