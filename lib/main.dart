import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const PDSApp());
}

class PDSApp extends StatelessWidget {
  const PDSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDS Rationing Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF25343F),
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
    );
  }
}
