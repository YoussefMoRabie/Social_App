import 'package:flutter/material.dart';
import "package:go_router/go_router.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/features/home/screens/home_screen.dart';

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
    initialLocation: '/timeline',
    navigatorKey: _rootNavigatorKey,
    routes: [
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
  );
});
