#ifndef WORKOUTDB_H
#define WORKOUTDB_H

#include <QSqlDatabase>
#include <QSqlDriver>
#include <QSqlError>
#include <QSqlQuery>

class DbManager {
public:
    DbManager(const QString& path);
private:
    QSqlDatabase m_db;
};

#endif // WORKOUTDB_H
