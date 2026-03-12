import 'package:flutter/material.dart';
import 'injection_container.dart' as di;
import 'features/auth/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const PlexusApp());
}

class PlexusApp extends StatelessWidget {
  const PlexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plexus NOC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        useMaterial3: true,
      ),
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        // We will define Dashboard route in Phase 2
      },
    );
  }
}
