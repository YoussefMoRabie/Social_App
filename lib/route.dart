import 'package:flutter/material.dart';
import "package:go_router/go_router.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/features/auth/screens/verfication_screen.dart';
import 'package:social_app/features/home/screens/home_screen.dart';

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

final goRouteProvider = Provider<GoRouter>((ref) {
  return GoRouter(
      initialLocation: '/login',
      navigatorKey: _rootNavigatorKey,
      routes: [
        GoRoute(
            path: "/verify",
            name: "verify",
            builder: (context, state) {
              final email = state.uri.queryParameters["email"];
              final pass = state.uri.queryParameters["pass"];
              return VerficationScreen(email: email!, password: pass!);
            }),
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
        final userLoggingIn = state.uri.toString() == '/login' ||
            state.uri.toString().contains("/verify");
        bool userIsLoggedIn = false;
        ref.watch(authStateChangeProvider).whenData((value) {
          userIsLoggedIn = value != null;
        });
        if (userLoggingIn && userIsLoggedIn) {
          return '/timeline';
        } else if (userLoggingIn && state.uri.toString().contains("/verify")) {
          return null;
        } else if (!userLoggingIn && !userLoggingIn) {
          return '/login';
        } else {
          return null;
        }
      }
      );
});
