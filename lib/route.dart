import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:go_router/go_router.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/features/chatting/contact_screen.dart';
import 'package:social_app/features/home/screens/home_screen.dart';
import 'package:social_app/models/user_model.dart';

import 'features/auth/controller/auth_controller.dart';
import 'features/auth/screens/show_login_or_signup.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/timeline/screens/post_screen.dart';
import 'features/timeline/screens/timeline_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorTimelineKey =
    GlobalKey<NavigatorState>(debugLabel: 'timeline');
final _shellNavigatorProfileKey =
    GlobalKey<NavigatorState>(debugLabel: 'profile');
 final _shellNavigatorcontactKey =
    GlobalKey<NavigatorState>(debugLabel: 'contact');

final goRouteProvider = Provider<GoRouter>((ref) {
  User? m = FirebaseAuth.instance.currentUser;
  UserModel mm = UserModel(
      name: m!.emailVerified.toString(), profilePic: '', uid: m!.uid, score: 0);
  return GoRouter(
    initialLocation: '/timeline',
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const ShowLoginOrSignup(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // the UI shell
          return HomeScreen(navigationShell: navigationShell);
        },
        branches: [
        StatefulShellBranch(
              navigatorKey: _shellNavigatorTimelineKey,
              routes: [
                GoRoute(
                  path: '/timeline',
                  pageBuilder: (context, state) =>
                      NoTransitionPage(child: TimelineScreen()),
                  routes: [
                    GoRoute(
                      path: 'post/:id',
                      builder: (context, state) {
                        final id = state.pathParameters['id']!;
                        return PostScreen(id: id);
                      },
                    ),
                  ],
                ),
              ]),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorcontactKey,
            routes: [
              GoRoute(
                  path: '/contact',
                  builder: (context, state) {
                    return ContactScreen(user: mm,);
                  },
                  routes: [
                    GoRoute(
                      path: 'post/:id',
                      builder: (context, state) {
                        final id = state.pathParameters['id']!;
                        return PostScreen(
                          id: id,
                        );
                      },
                    ),
                  ]),
            ],
          ),     StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                  path: '/profile',
                  builder: (context, state) {
                    return const ProfileScreen();
                  },
                  routes: [
                    GoRoute(
                      path: 'post/:id',
                      builder: (context, state) {
                        final id = state.pathParameters['id']!;
                        return PostScreen(
                          id: id,
                        );
                      },
                    ),
                  ]),
            ],
          )
        ],
      )
    ],
    redirect: (context, state) {
      final userLoggingIn = state.uri.toString() == '/login';
      bool userIsLoggedIn = false;
      final authStatus = ref.watch(authStateChangeProvider).whenData((value) {
        userIsLoggedIn = value != null;
      });
      if (userLoggingIn && userIsLoggedIn) {
        return '/timeline';
      } else if (!userLoggingIn && !userIsLoggedIn) {
        return '/login';
      } else {
        return null;
      }
    },
  );
});
