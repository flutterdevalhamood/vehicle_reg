import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sample/src/blocs/login_bloc.dart';
import 'package:sample/src/providers/vehicle_provider.dart';
import 'package:sample/src/screens/customers/customer_detail_screen.dart';
import 'package:sample/src/screens/customers/customer_list_screen.dart';
import 'package:sample/src/screens/customers/customer_registration_screen.dart';
import 'package:sample/src/screens/vehicles/vehicle_detail_screen.dart';
import 'package:sample/src/screens/vehicles/vehicle_list_screen.dart';
import 'package:sample/src/screens/vehicles/vehicle_registration_screen.dart';

import '../constants/string_constants.dart';
import '../screens/dashboard_screen.dart';
import '../screens/login_screen.dart';
import '../screens/vehicles/edit_vehicle_screen.dart';

class Screenroutes {
  static final RouteObserver<PageRoute> routeobserver =
      RouteObserver<PageRoute>();

  static const String login = "login";
  static const String vehicleRegistration = "vehicleRegistration";
  static const String vehicleDetail = "vehicleDetail";
  static const String homeScreen = "HomeScreen";
  static const String editDetail = "EditDetail";
  static const String dashboard = "DashBoard";
  static const String customerRegistration = "CustomerRegistration";
  static const String customerList = "CustomerList";
  static const String customerDetail = "customerDetail";
  static const String customerEdit = "customerEdit";
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

      case Screenroutes.dashboard:
        return MaterialPageRoute(
          settings: const RouteSettings(name: Screenroutes.dashboard),
          builder: (BuildContext context) {
            return DashBoardScreen();
          },
        );

      case Screenroutes.customerRegistration:
        return MaterialPageRoute(
          settings: const RouteSettings(
            name: Screenroutes.customerRegistration,
          ),
          builder: (BuildContext context) {
            return CustomerRegistrationScreen();
          },
        );

      case Screenroutes.customerList:
        return MaterialPageRoute(
          settings: const RouteSettings(name: Screenroutes.customerList),
          builder: (BuildContext context) {
            return CustomerListScreen();
          },
        );

      case Screenroutes.customerDetail:
        final index = settings.arguments as int;
        // final data = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          settings: const RouteSettings(name: Screenroutes.customerDetail),
          builder: (BuildContext context) {
            return CustomerDetailScreen(customerIndex: index);
          },
        );

      // case Screenroutes.customerEdit:
      //   return MaterialPageRoute(
      //     settings: const RouteSettings(name: Screenroutes.customerEdit),
      //     builder: (BuildContext context) {
      //       return CustomerDetailScreen();
      //     },
      //   );
    }
    return null;
  }
}
