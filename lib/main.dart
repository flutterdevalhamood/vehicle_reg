import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/src/BaseScreen.dart';
import 'package:sample/src/util/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/providers/customer_provider.dart';
import 'src/providers/vehicle_provider.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => VehicleProvider()),
        ChangeNotifierProvider(create: (context) => CustomerProvider()),
      ],
      child: const BaseScreen(),
    ),
  );
}
