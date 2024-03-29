#include "NodoTranslator.h"
#include <QGuiApplication>
#include <QDirIterator>
#include <QSettings>

/*
 * Original source code can be found here:
 * https://github.com/eyllanesc/stackoverflow/tree/master/questions/53724753
*/

Translator::Translator(QQmlEngine *engine, QObject *parent) : QObject(parent), m_engine(engine)
{
    initTranslator();
}

void Translator::initTranslator()
{
    m_translator = new QTranslator(this);
    m_dir = QDir(QGuiApplication::applicationDirPath(), "*"+extension, QDir::Name|QDir::IgnoreCase, QDir::Files);
    m_dir.cd("i18n");
    m_languages.clear();
    for(QString entry: m_dir.entryList()){
        entry.remove(0, QGuiApplication::applicationName().length()+1);
        entry.chop(extension.length());
        m_languages.append(entry);
    }
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

void Translator::selectLanguage(const QString &language)
{
    qApp->removeTranslator(m_translator);
    if(m_languages.contains(language)){
        QString file = QString("%1_%2%3").arg(QGuiApplication::applicationName()).arg(language).arg(extension);
        if(m_translator->load(m_dir.absoluteFilePath(file))){
            m_currentLanguage = language;
            QSettings settings;
            settings.setValue("Language/current", language);
            emit currentLanguageChanged();
        }
    }
    qApp->installTranslator(m_translator);
    m_engine->retranslate();
    emit languageChanged();
}
