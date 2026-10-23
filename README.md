# IT 126 – Module 3, Lesson 2: Local Storage and Database Operations

A simple Flutter project demonstrating both the **Activity** (temporary in-memory list) and the **Application** (persistent SQLite task manager).

## Features

- **Activity tab:** adds and displays task titles using `List<String>` in memory. The list is intentionally not saved.
- **SQLite App tab:** creates, reads, updates completion status, and deletes tasks using SQLite.
- Uses `sqflite` and `path`.
- Uses a `TaskRepository` to keep database operations separate from the UI.
- Rejects empty or whitespace-only task titles.
- Displays loading and error messages and refreshes the task list after successful operations.

## Project structure

```text
lib/
  main.dart
  data/
    task_repository.dart
  screens/
    memory_activity_screen.dart
    task_manager_screen.dart
README.md
pubspec.yaml
analysis_options.yaml
```

## Requirements

- Flutter SDK installed
- Android Studio or another supported Android development setup
- Android emulator or an Android device

`sqflite` is intended for supported mobile platforms such as Android and iOS; this project is not configured for Flutter Web.

## Run the project

1. Extract the project folder.
2. Open a terminal in the `it126_module3_lesson2` folder.
3. If platform folders are not present yet, run:

   ```bash
   flutter create --platforms=android,ios .
   ```

   If you only need Android, use `flutter create --platforms=android .` instead.

4. Fetch dependencies:

   ```bash
   flutter pub get
   ```

5. Run on an emulator or connected device:

   ```bash
   flutter run
   ```

6. Test persistence:
   - In **Activity**, add a task. It is only in memory and will be lost when the app process ends.
   - In **SQLite App**, add tasks, mark one complete, and delete one.
   - Close/terminate and reopen the app. SQLite tasks should still be present.

## Activity observations

When a task title is added to the in-memory list, it appears on the screen while the application is running. The app can display it because the list is held in the running program's memory. When the application process ends, the list object is not stored as a durable record, so the task titles do not remain after relaunch. A `StatefulWidget` manages UI state during the running process; it does not automatically make data persistent.

## Analysis answers

**1. What happened to the task titles when you added them to the list?**  
The task titles were appended to the Dart list and appeared on the screen.

**2. Why could the application display the tasks while it was running?**  
The list remained in the application's memory, and the UI read the list to display its current items.

**3. What happened after the application process ended and the application was relaunched?**  
The in-memory list was recreated as an empty list, so the previous task titles were no longer available.

**4. Would keeping the list inside a StatefulWidget automatically make the tasks persistent? Explain your answer.**  
No. `StatefulWidget` helps manage changing UI state while the app runs. It does not save the list to permanent storage when the process ends.

**5. What would the application need to do to preserve the tasks between sessions?**  
It needs to write the tasks to persistent storage, such as a local SQLite database, and load them again when the application opens.

**6. If the application eventually stored hundreds or thousands of tasks, what problems might arise from managing all the data manually in memory?**  
The app would need to implement searching, sorting, editing, deletion, validation, and saving/loading itself. The code could become difficult to maintain, and all list data would still be lost unless it was saved separately. A database provides structured queries and persistent records.

**7. How could separating the operations that save and retrieve tasks from the UI make the application easier to maintain?**  
A repository keeps data-access code in one place. The UI can call methods such as `createTask`, `getAllTasks`, `setCompleted`, and `deleteTask` without handling SQL directly. This reduces duplicated code and makes changes and testing easier.

## Reflection answers

**1. Why does the application use SQLite instead of relying only on a Dart list?**  
A Dart list only keeps the task data in memory during the current process. SQLite stores task records in a local database file, so tasks remain available after the app is closed and reopened. SQLite also supports structured queries and CRUD operations.

**2. What is the purpose of the primary key in the tasks table?**  
The `id` column is an automatically generated primary key that uniquely identifies each task. The app uses it to update or delete the correct task, even if two tasks have the same title.

**3. How does the repository simplify the UI's interaction with the database?**  
`TaskRepository` contains the database setup and CRUD methods. The UI calls repository methods instead of running SQL or database queries directly. This separates presentation from data access.

**4. What would happen if a task were removed from the displayed list but not deleted from SQLite?**  
It would disappear temporarily from the screen, but the database record would still exist. When the app reloads the records from SQLite, the task would appear again. The application should delete the record from SQLite and then refresh the displayed list.

**5. If the database schema later needed a new column for task priority, what parts of the application might need to change?**  
The SQLite table schema and database version/migration would need to change. The `Task` model and repository methods would likely need to read and write the priority value, and the UI would need controls to show or edit it. Existing database installations would need a migration, such as an `onUpgrade` handler, so saved tasks are preserved.

## References

- Flutter. (n.d.). *Persist data with SQLite*. https://docs.flutter.dev/cookbook/persistence/sqlite
- SQLite Consortium. (n.d.). *CREATE TABLE*. https://www.sqlite.org/lang_createtable.html
- Tekartik. (n.d.). *sqflite: Flutter plugin for SQLite*. https://pub.dev/packages/sqflite
- Dart. (n.d.). *Asynchronous programming: Futures, async, and await*. https://dart.dev/libraries/async/async-await

## GitHub submission checklist

1. Create a **public** GitHub repository, for example `it126-module3-lesson2`.
2. Extract this project and run the setup commands above.
3. Open a terminal in the project folder and run:

   ```bash
   git init
   git add .
   git commit -m "Complete IT 126 Module 3 Lesson 2"
   git branch -M main
   git remote add origin https://github.com/YOUR-USERNAME/it126-module3-lesson2.git
   git push -u origin main
   ```

4. Replace `YOUR-USERNAME` with your GitHub username and confirm that the repository visibility is **Public**.
5. Submit only the repository URL in your course submission.

Do not submit the example URL above; use the actual URL of your own public repository.
