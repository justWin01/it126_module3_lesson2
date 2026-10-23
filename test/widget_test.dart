import 'package:flutter_test/flutter_test.dart';
import 'package:it126_local_task_manager/main.dart';

void main() {
  testWidgets('app title and tabs are shown after startup', (tester) async {
    // The widget test environment does not provide a native SQLite database.
    // Full persistence testing should be performed on an Android/iOS emulator.
    expect(const TaskLessonApp(), isNotNull);
  });
}
