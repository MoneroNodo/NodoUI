#include "NodoTranslator.h"
#include <QGuiApplication>
#include <QDirIterator>
#include <QSettings>

/*
 * Original source code can be found here:
 * https://github.com/eyllanesc/stackoverflow/tree/master/questions/53724753
*/

Translator::Translator(NodoConfigParser *configParser, QQmlEngine *engine) : QObject(configParser)
{
    m_configParser = configParser;
    m_engine = engine;
    initTranslator();
}

void Translator::initTranslator()
{
    m_translator = new QTranslator(this);
    m_dir = QDir(QGuiApplication::applicationDirPath(), "*"+extension, QDir::Name|QDir::IgnoreCase, QDir::Files);
    m_dir.cd("i18n");
    m_languages.clear();
    m_language_codes.clear();

    for(int i = 0; i < m_dir.entryList().size(); i++)
    {
        QString entry = m_dir.entryList().at(i);
        entry.remove(0, QGuiApplication::applicationName().length()+1);
        entry.chop(extension.length());
        m_language_codes.append(entry);
        m_languages.append(languageByCode(entry));
    }

    m_currentLanguage = m_configParser->getLanguageCode();
    setLanguageByCode(m_currentLanguage);
}

QStringList Translator::languages() const
{
    return m_languages;
}

QString Translator::currentLanguage()
{
    if(m_currentLanguage.isEmpty()){
        QSettings settings;
        QString lang =settings.value("Language/current", QLocale::system().bcp47Name()).toString();
        m_currentLanguage = lang;
    }
    return m_currentLanguage;
}

QString Translator::languageByCode(const QString &code)
{
    QLocale lo(code);
    QString l_eng = lo.languageToString(lo.language());
    QString l_native = lo.nativeLanguageName();
    l_eng[0] = l_eng.at(0).toUpper();
    l_native[0] = l_native.at(0).toUpper();

    return  l_eng + " - " + l_native;
}

int Translator::getLanguageIndex(void)
{
    QString language = currentLanguage();
    if(m_language_codes.indexOf(language) < 0)
    {
        return m_language_codes.indexOf("en_US");
    }

    return m_language_codes.indexOf(language);
}

void Translator::setLanguageIndex(int index)
{
    QString language = m_language_codes.at(index);
    if(m_currentLanguage != language)
    {
        m_currentLanguage = language;
        setLanguageByCode(language);
        m_configParser->setLanguageCode(m_currentLanguage);
    }
}

void Translator::setLanguageByCode(const QString &code)
{
    qApp->removeTranslator(m_translator);

    QString file = QString("%1_%2%3").arg(QGuiApplication::applicationName()).arg(code).arg(extension);
    if(m_translator->load(m_dir.absoluteFilePath(file))){
        QSettings settings;
        settings.setValue("Language/current", code);
    }

    qApp->installTranslator(m_translator);
    m_engine->retranslate();
}
