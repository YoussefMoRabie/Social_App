import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/firebase_options.dart';
import 'package:social_app/theme/pallete.dart';
import 'package:social_app/route.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

import 'features/auth/controller/auth_controller.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp( ProviderScope(child: MyApp()));
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
}

class MyApp extends ConsumerWidget {
   MyApp({super.key});

  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouteProvider);

     ref.watch(authStateChangeProvider).whenData((data) {
      if (data != null) {
        getData(ref, data);
      }
    });

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: Palette.darkModeAppTheme,
      routerConfig: router,
    );
  }
}
