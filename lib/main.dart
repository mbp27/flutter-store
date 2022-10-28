import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pitjarusstore/data/repositories/auth_repository.dart';
import 'package:pitjarusstore/data/repositories/store_repository.dart';
import 'package:pitjarusstore/data/repositories/store_visit_repository.dart';
import 'package:pitjarusstore/helpers/colors.dart';
import 'package:pitjarusstore/logic/blocs/auth/auth_bloc.dart';
import 'package:pitjarusstore/logic/blocs/selected_location/selected_location_bloc.dart';
import 'package:pitjarusstore/presentation/router/app_router.dart';
import 'package:pitjarusstore/presentation/screens/login/login_screen.dart';
import 'package:pitjarusstore/presentation/screens/store_list/store_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()?.restartApp();
  }

  static NavigatorState? navigator(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>()?.navigator;
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UniqueKey _key = UniqueKey();
  final navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get navigator => navigatorKey.currentState!;

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthRepository>(
            create: (context) => AuthRepository(),
          ),
          RepositoryProvider<StoreRepository>(
            create: (context) => StoreRepository(),
          ),
          RepositoryProvider<StoreVisitRepository>(
            create: (context) => StoreVisitRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(
                authRepository: context.read<AuthRepository>(),
              ),
            ),
            BlocProvider<SelectedLocationBloc>(
              create: (context) => SelectedLocationBloc(),
            ),
          ],
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: MaterialApp(
              navigatorKey: navigatorKey,
              title: 'Pitjarus Store',
              theme: ThemeData(primarySwatch: MyColors.pallete),
              home: Container(color: Theme.of(context).scaffoldBackgroundColor),
              onGenerateRoute: AppRouter().onGenerateRoute,
              builder: (context, child) => BlocListener<AuthBloc, AuthState>(
                listenWhen: (previous, current) =>
                    previous.status != current.status ||
                    previous.refreshTime != current.refreshTime,
                listener: (context, state) async {
                  if (state.status == AuthStatus.authenticated) {
                    Navigator.of(navigator.context).pushNamedAndRemoveUntil(
                      StoreListScreen.routeName,
                      (route) => false,
                    );
                  } else {
                    Navigator.of(navigator.context).pushNamedAndRemoveUntil(
                      LoginScreen.routeName,
                      (route) => false,
                    );
                  }
                },
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
