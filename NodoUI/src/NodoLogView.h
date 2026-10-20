#ifndef NODOLOGVIEW_H_
#define NODOLOGVIEW_H_

#include "qabstractitemmodel.h"
#include "qdatetime.h"
#include "qlist.h"
#include "qobject.h"
#include "qobjectdefs.h"
#include "qsocketnotifier.h"
#include "qvariant.h"
#include <QObject>
#if __has_include("systemd/sd-journal.h") // I don't have systemd on here
#include <systemd/sd-journal.h>
#elif __has_include("elogind/sd-journal.h")
#include <elogind/sd-journal.h>
#endif

#define LOGVIEWER_MAXENTRIES 25000
#define LOGVIEWER_SCROLLBACK (LOGVIEWER_MAXENTRIES / 4)

class LogViewModel : public QAbstractListModel {

  Q_OBJECT
  Q_PROPERTY(QStringList unit READ unit WRITE setUnit NOTIFY unitChanged)
  Q_PROPERTY(int scrollback READ scrollback WRITE setScrollback NOTIFY
                 scrollbackChanged)

public:
  enum Roles {
    MessageRole = Qt::UserRole + 1,
    TimestampRole,
    PriorityRole,
  };

  Q_ENUM(Roles)

  explicit LogViewModel(QObject *parent = nullptr);
  ~LogViewModel() override;

  int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  QVariant data(const QModelIndex &index, int role) const override;
  QHash<int, QByteArray> roleNames() const override;

  QString getUnit() const { return m_unit; }
  void setUnit(const QString &unit);
  void setScrollback(const int &scrollback);

signals:
  void unitChanged();
  void scrollbackChanged();

private:
  struct Entry {
    QString message;
    QDateTime timestamp;
    int priority;
  };

  sd_journal *m_journal = nullptr;
  QSocketNotifier *m_notifier = nullptr;
  QString m_unit;
  QList<Entry> m_entries;
  int m_scrollback;

  void journalOpen();
  void journalClose();
  void drain();
  void appendEntry(Entry &&e);
  Entry readEntry() const;
  void loadScrollback();

  static QString fieldValue(const char *data, size_t len);
  static QDateTime fromUsec(const QString &s);
};

#endif // NODOLOGVIEW_H_
