import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:noc_task_plexus/features/auth/presentation/pages/login_page.dart';
import 'package:noc_task_plexus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:noc_task_plexus/features/auth/presentation/bloc/auth_state.dart';
import 'package:noc_task_plexus/features/auth/presentation/bloc/auth_event.dart';
import 'package:noc_task_plexus/core/theme/presentation/bloc/theme_bloc.dart';
import 'package:noc_task_plexus/features/auth/presentation/pages/widgets/login_form.dart';
import 'package:noc_task_plexus/features/auth/presentation/pages/widgets/login_header.dart';

class MockAuthBloc extends Mock implements AuthBloc {}
class MockThemeBloc extends Mock implements ThemeBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockThemeBloc mockThemeBloc;
  final sl = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(AuthInitial());
    registerFallbackValue(ThemeInitial());
    registerFallbackValue(LoginButtonPressed(email: '', password: ''));
  });

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockThemeBloc = MockThemeBloc();

    // Setup GetIt
    sl.reset();
    sl.registerFactory<AuthBloc>(() => mockAuthBloc);
    sl.registerFactory<ThemeBloc>(() => mockThemeBloc);

    // Default mock behaviors
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.fromIterable([AuthInitial()]));
    when(() => mockThemeBloc.state).thenReturn(ThemeLoaded(ThemeMode.dark));
    when(() => mockThemeBloc.stream).thenAnswer((_) => Stream.fromIterable([ThemeLoaded(ThemeMode.dark)]));
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<ThemeBloc>.value(
        value: mockThemeBloc,
        child: const LoginPage(),
      ),
    );
  }

  testWidgets('Should display login header and form', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(LoginHeader), findsOneWidget);
    expect(find.byType(LoginForm), findsOneWidget);
    expect(find.text('Plexus NOC'), findsOneWidget);
  });

  testWidgets('Should show error snackbar when AuthFailure state is emitted', (WidgetTester tester) async {
    whenListen(
      mockAuthBloc,
      Stream.fromIterable([AuthInitial(), const AuthFailure('Invalid credentials')]),
      initialState: AuthInitial(),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Trigger listener

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Invalid credentials'), findsOneWidget);
  });

  testWidgets('Should validate email and password fields', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final loginButton = find.text('LOGIN');
    await tester.tap(loginButton);
    await tester.pump();

    expect(find.text('Please enter email'), findsOneWidget);
    expect(find.text('Please enter password'), findsOneWidget);
  });

  testWidgets('Should toggle password visibility when eye icon is pressed', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Initially password should be obscured
    final passwordField = find.byType(TextFormField).last;
    
    // Find the TextFormField's internal TextField
    final textFieldFinder = find.descendant(
      of: passwordField,
      matching: find.byType(TextField),
    );
    
    TextField textField = tester.widget<TextField>(textFieldFinder);
    expect(textField.obscureText, isTrue);

    // Tap the visibility icon
    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump();

    // Password should be visible
    textField = tester.widget<TextField>(textFieldFinder);
    expect(textField.obscureText, isFalse);
  });
}

// Simple implementation of whenListen for Mocktail
void whenListen<E, S>(Mock bloc, Stream<S> stream, {required S initialState}) {
  when(() => (bloc as Bloc<E, S>).state).thenReturn(initialState);
  when(() => (bloc as Bloc<E, S>).stream).thenAnswer((_) => stream);
}
