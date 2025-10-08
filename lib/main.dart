
import 'package:cole20/core/localstorage/local_storage_service.dart';
import 'package:cole20/core/localstorage/storage_key.dart';
import 'package:cole20/core/providers.dart';
import 'package:cole20/features/auth/presentation/signin.dart';
import 'package:cole20/features/rituals/presentation/root_page.dart';
import 'package:cole20/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalStorageService.init();
  // runApp(ProviderScope(child: MyApp()));

  // runApp(AppLifecycleHandler(child: ProviderScope(child: MyApp())));
  runApp(
    ProviderScope(
      child: AppLifecycleHandler(
        child: const MyApp(),
      ),
    ),
  );

}


class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  Future<bool> _hasValidToken(WidgetRef ref) async {
    final localStorage = ref.read(localStorageProvider);
    final sessionMemory = ref.read(sessionMemoryProvider);

    final localToken = await localStorage.getString(StorageKey.token);
    final sessionToken = sessionMemory.token;

    // ✅ Check if either token exists and not empty
    return (sessionToken != null && sessionToken.isNotEmpty) ||
           (localToken != null && localToken.isNotEmpty);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
      future: _hasValidToken(ref),
      builder: (context, snapshot) {
        // Show simple loading while checking
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final hasToken = snapshot.data ?? false;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Cole20',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: Colors.white,
          ),
          home: hasToken ? RootPage() : SignInScreen(),
        );
      },
    );
  }
}



/// Handles app lifecycle events (auto-logout when app closes).
class AppLifecycleHandler extends ConsumerStatefulWidget {
  final Widget child;

  const AppLifecycleHandler({Key? key, required this.child}) : super(key: key);

  @override
  ConsumerState<AppLifecycleHandler> createState() =>
      _AppLifecycleHandlerState();
}

class _AppLifecycleHandlerState extends ConsumerState<AppLifecycleHandler>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // ✅ When the app is terminated or detached, auto logout
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      try {
        await ref.read(authNotifierProvider.notifier).signout(ref);
      } catch (_) {
        // Silently ignore errors during cleanup
      }
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}


