#include "NodoLogView.h"
#include "qabstractitemmodel.h"
#include "qdatetime.h"
#include "qdebug.h"
#include "qglobal.h"
#include "qhash.h"
#include "qobject.h"
#include "qsocketnotifier.h"
#include "qstringliteral.h"
#include "qvariant.h"
#include <cstring>
#include <elogind/sd-journal.h>
#include <strings.h>

LogViewModel::LogViewModel(QObject *parent) : QAbstractListModel(parent) {}

LogViewModel::~LogViewModel() { journalClose(); }

int LogViewModel::rowCount(const QModelIndex &parent) const {
  return parent.isValid() ? 0 : m_entries.size();
}

QVariant LogViewModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid() || index.row() >= m_entries.size())
    return QVariant();

  const Entry &e = m_entries.at(index.row());

  switch (role) {
  case MessageRole:
    return e.message;
  case TimestampRole:
    return e.timestamp;
  case PriorityRole:
    return e.priority;
  default:
    return QVariant();
  }
}

QHash<int, QByteArray> LogViewModel::roleNames() const {
  QHash<int, QByteArray> roles;
  roles[MessageRole] = "message";
  roles[TimestampRole] = "timestamp";
  roles[PriorityRole] = "priority";
  return roles;
}

void LogViewModel::setUnit(const QString &unit) {
  if (m_unit == unit)
    return;
  m_unit = unit;
  emit unitChanged();
  journalOpen();
}

QString LogViewModel::fieldValue(const char *data, size_t len) {
  QByteArray arr(data, static_cast<int>(len));
  int i = arr.indexOf('=');
  if (i >= 0)
    return QString::fromUtf8(arr.mid(i + 1));
  return QString();
}

QDateTime LogViewModel::fromUsec(const QString &s) {
  bool b = false;
  quint64 usec = s.toULongLong(&b);
  if (b)
    return QDateTime::fromMSecsSinceEpoch(static_cast<qint64>(usec / 1000));
  return QDateTime();
}

void LogViewModel::journalOpen() {
  journalClose();
  if (m_unit.isEmpty())
    return;

  int r;
  r = sd_journal_open(&m_journal, SD_JOURNAL_LOCAL_ONLY | SD_JOURNAL_SYSTEM);

  if (r < 0) {
    qDebug() << "sd_journal_open: " << strerror(-r);
    return;
  }

  if (m_unit == "kernel") {
    sd_journal_add_match(m_journal, "_TRANSPORT=kernel",
                         strlen("_TRANSPORT=kernel"));
  } else {
    const QByteArray match =
        QStringLiteral("_SYSTEMD_UNIT=%1").arg(m_unit).toUtf8();
    r = sd_journal_add_match(m_journal, match.constData(),
                             static_cast<size_t>(match.size()));
  }

  if (r < 0) {
    qDebug() << "sd_journal_add_match: " << strerror(-r);
  }

  loadScrollback();

  int fd = sd_journal_get_fd(m_journal);
  if (fd < 0) {
    qDebug() << "sd_journal_get_fd: " << strerror(-fd);
    journalClose();
    return;
  }

  sd_journal_process(m_journal);

  m_notifier = new QSocketNotifier(fd, QSocketNotifier::Read, this);
  connect(m_notifier, &QSocketNotifier::activated, this, [this]() {
    int ret = sd_journal_process(m_journal);
    if (ret == SD_JOURNAL_APPEND)
      drain();
    else if (ret == SD_JOURNAL_INVALIDATE)
      journalOpen();
  });
}

void LogViewModel::journalClose() {
  if (m_notifier) {
    m_notifier->setEnabled(false);
    m_notifier->deleteLater();
    m_notifier = nullptr;
  }

  if (m_journal) {
    sd_journal_close(m_journal);
    m_journal = nullptr;
  }
}

LogViewModel::Entry LogViewModel::readEntry() const {
  Entry e;
  if (!m_journal)
    return e;
  const char *data = nullptr;
  size_t len = 0;

  if (sd_journal_get_data(m_journal, "MESSAGE",
                          reinterpret_cast<const void **>(&data), &len) >= 0)
    e.message = fieldValue(data, len);

  if (sd_journal_get_data(m_journal, "PRIORITY",
                          reinterpret_cast<const void **>(&data), &len) >= 0)
    e.priority = fieldValue(data, len).toInt();

  if (sd_journal_get_data(m_journal, "_SOURCE_REALTIME_TIMESTAMP",
                          reinterpret_cast<const void **>(&data), &len) >= 0) {
    e.timestamp = fromUsec(fieldValue(data, len));
  } else if (sd_journal_get_data(m_journal, "__REALTIME_TIMESTAMP",
                                 reinterpret_cast<const void **>(&data),
                                 &len) >= 0) {
    e.timestamp = fromUsec(fieldValue(data, len));
  }
  return e;
}

void LogViewModel::loadScrollback() {
  if (!m_journal)
    return;

  int r;
  r = sd_journal_seek_tail(m_journal);
  if (r < 0) {
    qDebug() << "sd_journal_seek_tail: " << strerror(-r);
    return;
  }

  for (int i = 0; i < m_scrollback; i++) {
    r = sd_journal_previous(m_journal);
    if (r < 0) {
      qDebug() << "sd_journal_previous: " << strerror(-r);
      return;
    }
    if (r == 0)
      break;
  }
  drain();
}

void LogViewModel::drain() {
  if (!m_journal)
    return;
  int r;
  while ((r = sd_journal_next(m_journal)) > 0) {
    appendEntry(readEntry());
  }
  if (r < 0) {
    qDebug() << "sd_journal_next: " << strerror(-r);
  }
}

void LogViewModel::appendEntry(Entry &&e) {
  if (m_entries.size() >= LOGVIEWER_MAXENTRIES) {
    beginRemoveRows(QModelIndex(), 0, 0);
    m_entries.removeFirst();
    endRemoveRows();
  }
  beginInsertRows(QModelIndex(), m_entries.size(), m_entries.size());
  m_entries.append(std::move(e));
  endInsertRows();
}

void LogViewModel::setScrollback(const int &scrollback) {
  if (m_scrollback == scrollback)
    return;
  m_scrollback = scrollback;
  emit scrollbackChanged();
  journalOpen();
}
