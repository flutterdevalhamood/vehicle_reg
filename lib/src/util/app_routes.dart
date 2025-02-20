import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sample/src/blocs/login_bloc.dart';
import 'package:sample/src/providers/vehicle_provider.dart';
import 'package:sample/src/screens/home_screen.dart';
import 'package:sample/src/screens/vehicle_detail_screen.dart';
import 'package:sample/src/screens/vehicle_registration_screen.dart';

import '../constants/string_constants.dart';
import '../screens/edit_vehicle_screen.dart';
import '../screens/login_screen.dart';

class Screenroutes {
  static final RouteObserver<PageRoute> routeobserver =
      RouteObserver<PageRoute>();

  static const String login = "login";
  static const String vehicleRegistration = "vehicleRegistration";
  static const String vehicleDetail = "vehicleDetail";
  static const String homeScreen = "HomeScreen";
  static const String editDetail = "EditDetail";
  static Route<dynamic>? routes(RouteSettings settings) {
    StringConstants.currentRoute = settings.name ?? "";

    switch (settings.name) {
      case Screenroutes.login:
        return MaterialPageRoute(
          settings: const RouteSettings(name: Screenroutes.login),
          builder: (BuildContext context) {
            return BlocProvider(
              create: (context) => LoginBloc(),
              child: const LoginScreen(),
            );
          },
        );

      case Screenroutes.vehicleRegistration:
        return MaterialPageRoute(
          settings: const RouteSettings(name: Screenroutes.vehicleRegistration),
          builder: (BuildContext context) {
            return VehicleRegistrationScreen();
          },
        );

      case Screenroutes.vehicleDetail:
        final vehicle = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          settings: const RouteSettings(name: Screenroutes.vehicleDetail),
          builder: (BuildContext context) {
            return VehicleDetailScreen(vehicle: vehicle ?? {});
          },
        );

      case Screenroutes.homeScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: Screenroutes.homeScreen),
          builder: (BuildContext context) {
            return HomeScreen();
          },
        );

      case Screenroutes.editDetail:
        final vehicle = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          settings: const RouteSettings(name: Screenroutes.editDetail),
          builder: (BuildContext context) {
            return ChangeNotifierProvider.value(
              value: Provider.of<VehicleProvider>(context, listen: false),
              child: EditVehicleScreen(data: vehicle ?? {}),
            );
          },
        );
    }
    return null;
  }
}
