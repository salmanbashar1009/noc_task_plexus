import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noc_task_plexus/features/auth/presentation/pages/widgets/login_header.dart';


void main() {
  testWidgets('LoginHeader displays icon and texts', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LoginHeader(),
        ),
      ),
    );

    // Verify main title
    expect(find.text('Plexus Cloud NOC'), findsOneWidget);

    // Verify subtitle
    expect(find.text('Network Operations Center'), findsOneWidget);

    // Verify icon exists
    expect(find.byIcon(Icons.wifi_tethering), findsOneWidget);

    // Verify Column exists
    expect(find.byType(Column), findsOneWidget);
  });
}