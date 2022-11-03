import "package:com_nicodevelop_dotmessenger/config/dependency_config.dart";
import "package:com_nicodevelop_dotmessenger/repositories/chat_repository.dart";
import "package:com_nicodevelop_dotmessenger/repositories/group_repository.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:com_nicodevelop_dotmessenger/screens/home_screen.dart";
import "package:com_nicodevelop_dotmessenger/screens/login_screen.dart";
import "package:com_nicodevelop_dotmessenger/services/service_factory.dart";
import "package:com_nicodevelop_dotmessenger/utils/logger.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_ui_localizations/firebase_ui_localizations.dart";
// ignore: depend_on_referenced_packages
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter/foundation.dart";

import "package:flutter/material.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(
    widgetsBinding: widgetsBinding,
  );

  await configureDependancies(
    kDebugMode ? "development" : "production",
  );

  User? user = await FirebaseAuth.instance.authStateChanges().first;

  if (user != null) {
    info("User is signed in", data: {
      "uid": user.uid,
    });
  }

  FlutterNativeSplash.remove();

  runApp(App(
    user: user,
  ));
}

class App extends StatelessWidget {
  final User? user;

  const App({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ServiceFactory(
      getIt.get<GroupRepository>(),
      getIt.get<ChatRepository>(),
      getIt.get<ProfileRepository>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FirebaseUILocalizations.delegate,
        ],
        theme: ThemeData(
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        home: user != null ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }
}
