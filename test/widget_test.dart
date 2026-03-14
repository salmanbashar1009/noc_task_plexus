import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:noc_task_plexus/features/splash/presentation/pages/splash_page.dart';
import 'package:noc_task_plexus/features/auth/presentation/pages/login_page.dart';
import 'package:noc_task_plexus/core/theme/presentation/bloc/theme_bloc.dart';
import 'package:noc_task_plexus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:noc_task_plexus/features/auth/presentation/bloc/auth_state.dart';

class MockAuthBloc extends Mock implements AuthBloc {}
class MockThemeBloc extends Mock implements ThemeBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockThemeBloc mockThemeBloc;
  final sl = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(AuthInitial());
    registerFallbackValue(ThemeInitial());
  });

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockThemeBloc = MockThemeBloc();

    sl.reset();
    sl.registerFactory<AuthBloc>(() => mockAuthBloc);
    sl.registerFactory<ThemeBloc>(() => mockThemeBloc);

    // Mocking default states for navigation destination
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockThemeBloc.state).thenReturn(ThemeLoaded(ThemeMode.dark));
    when(() => mockThemeBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  group('SplashPage Widget Tests', () {
    testWidgets('should display logo icon and brand texts', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SplashPage()));

      // Verify the logo icon exists
      expect(find.byIcon(Icons.wifi_tethering), findsOneWidget);

      // Verify the main title and subtitle
      expect(find.text('Plexus Cloud NOC'), findsOneWidget);
      expect(find.text('Network Operations Center'), findsOneWidget);

      // Clear the 2-second timer from SplashPage
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('should have centered layout with a column', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SplashPage()));

      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      
      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisAlignment, MainAxisAlignment.center);

      // Clear the 2-second timer from SplashPage
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('should navigate to login page after 2 seconds delay', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/': (context) => const SplashPage(),
            '/login': (context) => BlocProvider<ThemeBloc>.value(
                  value: mockThemeBloc,
                  child: const LoginPage(),
                ),
          },
        ),
      );

      // Verify initial presence of SplashPage
      expect(find.byType(SplashPage), findsOneWidget);

      // Advance time by 2 seconds to trigger navigation
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify transition to LoginPage
      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(SplashPage), findsNothing);
    });
  });
}
