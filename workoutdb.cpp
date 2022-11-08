#include "workoutdb.h"
#include <QDebug>

DbManager::DbManager(const QString& path) {
   m_db = QSqlDatabase::addDatabase("QSQLITE");
   m_db.setDatabaseName(path);

   if (!m_db.open())
   {
      qInfo() << "Error: connection with database failed";
   }
   else
   {
      qInfo() << "Database: connection ok";
   }
}
