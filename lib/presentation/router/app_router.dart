import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pitjarusstore/data/repositories/auth_repository.dart';
import 'package:pitjarusstore/data/repositories/store_repository.dart';
import 'package:pitjarusstore/data/repositories/store_visit_repository.dart';
import 'package:pitjarusstore/logic/blocs/login/login_bloc.dart';
import 'package:pitjarusstore/logic/blocs/logout/logout_bloc.dart';
import 'package:pitjarusstore/logic/blocs/store_detail/store_detail_bloc.dart';
import 'package:pitjarusstore/logic/blocs/store_list/store_list_bloc.dart';
import 'package:pitjarusstore/logic/blocs/store_visit/store_visit_bloc.dart';
import 'package:pitjarusstore/presentation/screens/loading/loading_screen.dart';
import 'package:pitjarusstore/presentation/screens/login/login_screen.dart';
import 'package:pitjarusstore/presentation/screens/not_found/not_found_screen.dart';
import 'package:pitjarusstore/presentation/screens/store_detail/store_detail_screen.dart';
import 'package:pitjarusstore/presentation/screens/store_list/store_list_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case LoadingScreen.routeName:
        return PageRouteBuilder(
          opaque: false,
          fullscreenDialog: true,
          pageBuilder: (context, _, __) => const LoadingScreen(),
        );
      case LoginScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(
              authRepository: context.read<AuthRepository>(),
            ),
            child: const LoginScreen(),
          ),
        );
      case StoreListScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<StoreListBloc>(
                create: (context) => StoreListBloc(
                  storeRepository: context.read<StoreRepository>(),
                )..add(StoreListLoad()),
              ),
              BlocProvider<LogoutBloc>(
                create: (context) => LogoutBloc(
                  authRepository: context.read<AuthRepository>(),
                ),
              ),
            ],
            child: const StoreListScreen(),
          ),
        );
      case StoreDetailScreen.routeName:
        final arguments = routeSettings.arguments;
        if (arguments is! StoreDetailScreenArguments) {
          throw 'Please using arguments';
        }
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<StoreDetailBloc>(
                create: (context) => StoreDetailBloc(
                  storeRepository: context.read<StoreRepository>(),
                )..add(StoreDetailLoad(store: arguments.store)),
              ),
              BlocProvider<StoreVisitBloc>(
                create: (context) => StoreVisitBloc(
                  storeVisitRepository: context.read<StoreVisitRepository>(),
                ),
              ),
            ],
            child: StoreDetailScreen(store: arguments.store),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const NotFoundScreen(),
        );
    }
  }
}
