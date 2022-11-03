import "dart:io";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:com_nicodevelop_dotmessenger/firebase_options.dart";
import "package:com_nicodevelop_dotmessenger/repositories/chat_repository.dart";
import "package:com_nicodevelop_dotmessenger/repositories/group_repository.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/foundation.dart";
import "package:get_it/get_it.dart";
import "package:injectable/injectable.dart";

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r"$initGetIt",
)
Future<void> configureDependancies(
  String environment,
) async =>
    $initGetIt(
      getIt,
      environment: environment,
    );

$initGetIt(
  GetIt getIt, {
  required String environment,
  EnvironmentFilter? environmentFilter,
}) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    String host = "localhost";

    if (!kIsWeb) {
      host = Platform.isAndroid ? "10.0.2.2" : "localhost";
    }

    await FirebaseAuth.instance.useAuthEmulator(
      host,
      9099,
    );

    FirebaseFirestore.instance.useFirestoreEmulator(
      host,
      8080,
    );
  }

  final gh = GetItHelper(getIt, environment);

  gh.factory<GroupRepository>(
    () => GroupRepository(),
  );

  gh.factory<ChatRepository>(
    () => ChatRepository(),
  );

  gh.factory<ProfileRepository>(() => ProfileRepository(
        FirebaseAuth.instance,
        FirebaseFirestore.instance,
      ));
}
