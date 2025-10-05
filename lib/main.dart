import 'package:cole20/core/localstorage/local_storage_service.dart';
import 'package:cole20/features/auth/presentation/compleate_profile.dart';
import 'package:flutter/material.dart';
import 'package:cole20/features/auth/presentation/signin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Signup App',
      theme: ThemeData(
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: CompleteProfileScreen(),
    );
  }
}
