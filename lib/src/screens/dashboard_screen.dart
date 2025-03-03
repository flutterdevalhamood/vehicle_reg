import 'package:flutter/material.dart';
import 'package:sample/src/util/app_navigation.dart';
import 'package:sample/src/util/app_routes.dart';

import '../../main.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final List<Map<String, dynamic>> gridItems = [
    {
      'title': 'Customers',
      'icon': Icons.people,
      'route': Screenroutes.customerList,
    },
    {
      'title': 'Vehicles',
      'icon': Icons.directions_car,
      'route': Screenroutes.homeScreen,
    },
    {'title': 'Drivers', 'icon': Icons.person},
    {
      'title': 'Add New Customer',
      'icon': Icons.person_add,
      'route': Screenroutes.customerRegistration,
    },
  ];
  void _logout() async {
    // Show a confirmation dialog before deleting
    bool confirmLogout =
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Logout'),
              content: Text('Are you sure you want to Logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Logout', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirmLogout) {
      NavigationService().navigateToUntil(Screenroutes.login);
      Future.delayed(Duration(milliseconds: 500), () {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('User Logged out successfully!')),
        );
      });
    }
  }

  _getBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade50, Colors.white],
        ),
      ),
      child: GridView.builder(
        padding: EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 10.0, // Spacing between columns
          mainAxisSpacing: 10.0, // Spacing between rows
          childAspectRatio: 1.0, // Aspect ratio of the grid items
        ),
        itemCount: gridItems.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2.0,
            child: InkWell(
              onTap: () {
                NavigationService().pushNavigation(gridItems[index]['route']);
                // print('${gridItems[index]['title']} tapped');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(gridItems[index]['icon'], size: 40.0),
                  SizedBox(height: 10.0),
                  Text(
                    gridItems[index]['title'],
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        leading: IconButton(
          onPressed: () => _logout(),
          icon: Icon(Icons.logout),
        ),
      ),
      body: _getBody(context),
    );
  }
}
