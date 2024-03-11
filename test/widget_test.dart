// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_mock_test/main.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import 'github_api_repository_test.mocks.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets("Widgetテストにモックを使う & タップ時に値を変更する", (WidgetTester tester) async {
    final repository = MockGithubApiRepository();
    final answers = [1, 5];
    when(repository.countRepositories())
        .thenAnswer((_) async => answers.removeAt(0));
    GetIt.I.registerLazySingleton<GithubApiRepository>(() => repository);

    await tester.pumpWidget(const MyApp());
    expect(find.text("0"), findsOneWidget);
    expect(find.text("1"), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text("0"), findsNothing);
    expect(find.text("1"), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text("0"), findsNothing);
    expect(find.text("1"), findsNothing);
    expect(find.text("5"), findsOneWidget);
  });
}
