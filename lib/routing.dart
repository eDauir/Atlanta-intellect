import 'package:barber/pages/Error/error.dart';
import 'package:barber/pages/Home/Home.dart';
import 'package:barber/pages/Notification/Notification.dart';
import 'package:barber/pages/Profile/account/mainProfile.dart';
import 'package:barber/pages/Profile/account/profile.dart';
import 'package:barber/pages/Profile/control/auth.dart';
import 'package:barber/pages/Profile/control/recPass.dart';
import 'package:barber/pages/Profile/control/reg.dart';
import 'package:barber/pages/Search/Search.dart';
import 'package:barber/pages/Tarif/tarif.dart';
import 'package:barber/pages/Welcome/Welcome.dart';
import 'package:barber/pages/Wrapper.dart';
import 'package:barber/pages/book/book.dart';
import 'package:barber/pages/list/lists.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:go_router/go_router.dart';

goRouterShow({required String url, required ThemeProvider theme}) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: url,
    // urlPathStrategy :true,
    errorPageBuilder: (context, state) {
      return NoTransitionPage(
          child: Wrapper(
            them: theme,
            bodyWidget: const NotPages(),
            numWidget: 0,
          ),
          key: state.pageKey);
    },
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
              child: Wrapper(
                them: theme,
                bodyWidget: Home(),
                numWidget: 1,
              ),
              key: state.pageKey);
        },
      ),
      GoRoute(
        path: '/welcome',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
              child: Wrapper(
                them: theme,
                bodyWidget: WelcomePage(),
                numWidget: 88,
              ),
              key: state.pageKey);
        },
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
              child: Wrapper(
                them: theme,
                bodyWidget: MainProdile(),
                numWidget: 5,
              ),
              key: state.pageKey);
        },
      ),
      GoRoute(
        path: '/auth',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
              child: Wrapper(
                them: theme,
                bodyWidget: AuthPage(),
                numWidget: 6,
              ),
              key: state.pageKey);
        },
      ),
      GoRoute(
        path: '/reg',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
              child: Wrapper(
                them: theme,
                bodyWidget: RegPage(),
                numWidget: 7,
              ),
              key: state.pageKey);
        },
      ),
      GoRoute(
        path: '/recPass',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
              child: Wrapper(
                them: theme,
                bodyWidget: RecPass(),
                numWidget: 8,
              ),
              key: state.pageKey);
        },
      ),
      GoRoute(
        path: '/redProfile',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
              child: Wrapper(
                them: theme,
                bodyWidget: Profile(),
                numWidget: 9,
              ),
              key: state.pageKey);
        },
      ),
      GoRoute(
        path: '/sad',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
              child: Wrapper(
                them: theme,
                bodyWidget: ListItem(),
                numWidget: 2,
              ),
              key: state.pageKey);
        },
      ),
      GoRoute(
        path: '/search',
        pageBuilder: (context, state) {
          print(state.extra);
          return NoTransitionPage<void>(
              child: Wrapper(
                them: theme,
                bodyWidget: Search(extra: state.extra,),
                numWidget: 10,
              ),
              key: state.pageKey);
        },
      ),
      GoRoute(
        path: '/noti',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
              child: Wrapper(
                them: theme,
                bodyWidget: Notification(),
                numWidget: 11,
              ),
              key: state.pageKey);
        },
      ),
      GoRoute(
        path: '/tarif',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
              child: Wrapper(
                them: theme,
                bodyWidget: TarifPage(),
                numWidget: 15,
              ),
              key: state.pageKey);
        },
      ),
      GoRoute(
        path: '/book',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
              child: Wrapper(
                them: theme,
                bodyWidget: BookPage(),
                numWidget: 16,
              ),
              key: state.pageKey);
        },
      ),
    ],
  );
}
