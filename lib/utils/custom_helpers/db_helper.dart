// import 'package:alzheimer_smartcare/utils/constants/endpoints.dart';
// import 'package:intl/intl.dart';
// import 'package:sqflite/sqflite.dart';
// import '../../screens/patient/Schedule/model.dart';
// import 'cache_helper.dart';
// import 'package:path/path.dart';
//
// class DbHelper {
//   static Database? db;
//   static final int version = 1;
//   static final String tableName = "tasks";
//
//   // Initialize database connection
//   static Future<void> initDb() async {
//     if (db != null) return;
//
//     try {
//       final String path = join(await getDatabasesPath(), 'tasks.db');
//       db = await openDatabase(
//         path,
//         version: version,
//         onCreate: (db, version) async {
//           await db.execute('''
//             CREATE TABLE $tableName(
//               id INTEGER PRIMARY KEY AUTOINCREMENT,
//               userEmail TEXT,
//               title TEXT,
//               description TEXT,
//               date TEXT,
//               startTime TEXT,
//               endTime TEXT,
//               remind INTEGER,
//               repeat TEXT,
//               isCompleted INTEGER,
//               image TEXT,
//               type TEXT
//             )
//           ''');
//           print("Created $tableName table");
//         },
//       );
//     } catch (e) {
//       print("Database initialization failed: $e");
//       rethrow;
//     }
//   }
//
//   static Future<int> insert(Reminder task) async {
//     try {
//       final userEmail = CacheHelper().getDataString(key: ApiKey.email);
//       print("Inserting task with email: $userEmail");
//
//       final taskData = task.toJson();
//       taskData['userEmail'] = userEmail;
//
//       final id = await db!.insert(tableName, taskData);
//       print("Task inserted successfully. ID: $id");
//       return id;
//     } catch (e) {
//       print("Error inserting task: $e");
//       rethrow;
//     }
//   }
//
//   static Future<void> deleteDatabaseFile() async {
//     String path = await getDatabasesPath() + 'tasks.db';
//     await deleteDatabase(path);
//     print("Database deleted successfully");
//   }
//
//   static Future<List<Map<String, dynamic>>> query() async {
//     final userEmail = CacheHelper().getDataString(key: ApiKey.email);
//     if (userEmail == null) return [];
//
//     return await db!.query(
//       'tasks',
//       where: 'userEmail = ?',
//       whereArgs: [userEmail],
//     );
//   }
//
//   static Future<int> delete(Reminder task) async {
//     if (db == null) {
//       throw Exception("Database not initialized");
//     }
//
//     String? userEmail = CacheHelper().getDataString(key: ApiKey.email);
//     if (userEmail == null) {
//       throw Exception("User email not found.");
//     }
//
//     return await db!.delete(
//       tableName,
//       where: "id = ? AND userEmail = ?",
//       whereArgs: [task.id, userEmail],
//     );
//   }
//
//   static Future<List<Reminder>> getSortedReminders() async {
//     if (db == null) {
//       throw Exception("Database not initialized");
//     }
//
//     String? userEmail = CacheHelper().getDataString(key: ApiKey.email);
//     print("tokennnnnnnnnnnnnnnnnnnnnnnnnnnnn ${userEmail}");
//     if (userEmail == null) {
//       throw Exception("User email not found.");
//     }
//
//     final List<Map<String, dynamic>> maps = await db!.query(
//       tableName,
//       where: "userEmail = ?",
//       whereArgs: [userEmail],
//     );
//
//     List<Reminder> tasks = maps
//         .map((map) =>
//         Reminder(
//           id: map['id'],
//           title: map['title'],
//           description: map['description'] ?? '',
//           date: map['date'] ?? '',
//           repeat: map['repeat'] ?? '',
//           isCompleted: (map['isCompleted'] ?? 0) == 1,
//           startTime: map['startTime'] ?? '',
//           endTime: map['endTime'] ?? '',
//           remind: map['remind'] ?? 0,
//           image: map['image'],
//           type: map['type'],
//         ))
//         .toList();
//     return tasks;
//   }
//
//   static Future<int> update(Reminder task) async {
//     if (db == null) {
//       throw Exception("Database not initialized");
//     }
//
//     String? userEmail = CacheHelper().getDataString(key: ApiKey.email);
//     if (userEmail == null) {
//       throw Exception("User email not found.");
//     }
//
//     return await db!.update(
//       tableName,
//       task.toJson(),
//       where: 'id = ? AND userEmail = ?',
//       whereArgs: [task.id, userEmail],
//     );
//   }
//
//   static Future<Reminder?> getNearestReminderByType(String type) async {
//     String? userEmail = CacheHelper().getDataString(key: ApiKey.email);
//     if (userEmail == null) {
//       throw Exception("User email not found.");
//     }
//     List<Reminder> reminders = await getSortedReminders();
//     reminders.sort((a, b) {
//       DateFormat format = DateFormat("M/d/yyyy hh:mm a", "en_US");
//       DateTime dateA = format.parse("${a.date} ${a.startTime}");
//       DateTime dateB = format.parse("${b.date} ${b.startTime}");
//
//       return dateA.compareTo(dateB);
//     });
//     for (var reminder in reminders) {
//       if (reminder.type == type) {
//         return reminder;
//       }
//     }
//     return null;
//   }
// }
