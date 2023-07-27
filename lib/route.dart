import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:go_router/go_router.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/features/chatting/contact_screen.dart';
import 'package:social_app/features/home/screens/home_screen.dart';
import 'package:social_app/features/leaderboard/screens/leaderboard_screen.dart';
import 'package:social_app/features/profile/screens/profile_page.dart';
import 'package:social_app/features/profile/screens/random_profile_page.dart';
import 'package:social_app/features/profile/screens/update_profile.dart';
import 'package:social_app/features/timeline/screens/send_post.dart';

import 'features/auth/controller/auth_controller.dart';
import 'features/auth/screens/show_login_or_signup.dart';
import 'features/chatting/views/chat.dart';
import 'features/profile/screens/settings_screen.dart';
import 'features/timeline/screens/post_screen.dart';
import 'features/timeline/screens/timeline_screen.dart';
import 'models/user_model.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorTimelineKey =
    GlobalKey<NavigatorState>(debugLabel: 'timeline');
final _shellNavigatorLeaderboardKey =
    GlobalKey<NavigatorState>(debugLabel: 'leaderboard');
final _shellNavigatorProfileKey =
    GlobalKey<NavigatorState>(debugLabel: 'profile');
final _shellNavigatorContactKey =
    GlobalKey<NavigatorState>(debugLabel: 'contact');

final goRouteProvider = Provider<GoRouter>((ref) {
  User? m = FirebaseAuth.instance.currentUser;
  UserModel mm = UserModel(
      name: 'w',
      profilePic: '',
      uid: '000',
      score: 0,
      followers: [],
      following: [],
      key: '9999',
      validityOfKey: 2);
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
                    GoRoute(
                      path: 'post',
                      builder: (context, state) {
                        return SendPostSreen();
                      },
                    ),
                  ],
                ),
              ]),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorLeaderboardKey,
            routes: [
              GoRoute(
                path: '/leaderboard',
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: LeaderboardScreen()),
                routes: [],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorContactKey,
            routes: [
              GoRoute(
                  path: '/contact',
                  builder: (context, state) {
                    return Chat();
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
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                  path: '/profile',
                  builder: (context, state) {
                    return const ProfilePage();
                  },
                  routes: [
                    GoRoute(
                      path: 'settings',
                      builder: (context, state) {
                        return const SettingsScreen();
                      },
                    ),
                    GoRoute(
                      path: 'update',
                      builder: (context, state) {
                        return const UpdateProfileScreen();
                      },
                    ),
                    GoRoute(
                      path: ':id',
                      builder: (context, state) {
                        final id = state.pathParameters['id']!;
                        return RandomProfilePage(
                          id: id,
                        );
                      },
                    ),
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
      ref.watch(authStateChangeProvider).whenData((value) {
        userIsLoggedIn = value != null;
      });

      if (userLoggingIn && userIsLoggedIn) {
        return '/timeline';
      } else if ((!userLoggingIn && !userIsLoggedIn)) {
        return '/login';
      } else {
        return null;
      }
    },
  );
});
