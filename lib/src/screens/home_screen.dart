import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/src/providers/vehicle_provider.dart';
import 'package:sample/src/util/app_navigation.dart';
import 'package:sample/src/util/app_routes.dart';

import 'vehicle_registration_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _vehicleDetails(Map<String, dynamic> vehicle) {
    NavigationService().pushNavigation(
      Screenroutes.vehicleDetail,
      arguments: vehicle,
    );
  }

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
                  onPressed:
                      () => NavigationService().navigateToUntil(
                        Screenroutes.login,
                      ),
                  child: Text('Logout', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!confirmLogout) {
      NavigationService().navigateToUntil(Screenroutes.login);

      // Use a short delay to ensure navigation completes before showing the message
      Future.delayed(Duration(milliseconds: 500), () {
        final context = NavigationService().navigatorKey.currentContext;
        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User Logged out successfully!')),
          );
        }
      });
    }
  }

  void _deleteVehicle(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Vehicle"),
          content: Text("Are you sure you want to delete this vehicle?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final vehicleProvider = Provider.of<VehicleProvider>(
                  context,
                  listen: false,
                );
                await vehicleProvider.deleteVehicle(index);
                // Delete the vehicle
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VehicleProvider>(
      builder: (context, vehicleProvider, child) {
        final vehicles = vehicleProvider.vehicles;
        return Scaffold(
          appBar: AppBar(
            title: Text('Vehicle List'),
            leading: IconButton(
              onPressed: () => _logout(),
              icon: Icon(Icons.logout),
            ),
          ),
          body:
              vehicles.isEmpty
                  ? Center(child: Text('No vehicles registered yet.'))
                  : ListView.builder(
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = vehicles[index];
                      return Dismissible(
                        key: Key(vehicle['plateNumber'] ?? index.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          final vehicleProvider = Provider.of<VehicleProvider>(
                            context,
                            listen: false,
                          );
                          vehicleProvider.deleteVehicle(index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              leading: Icon(
                                Icons.directions_car,
                                size: 40,
                                color: Colors.blue,
                              ),
                              title: Text(
                                vehicle['plateNumber'] ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                vehicle['type'] ?? 'No Type',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () async {
                                      final result = await NavigationService()
                                          .pushNavigation(
                                            Screenroutes.editDetail,
                                            arguments: vehicle,
                                          );
                                      if (result != null) {
                                        vehicleProvider.addOrUpdateVehicle(
                                          result,
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      _deleteVehicle(index);
                                    },
                                  ),
                                ],
                              ),
                              onTap: () => _vehicleDetails(vehicle),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Navigate to VehicleRegistrationScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VehicleRegistrationScreen(),
                ),
              ).then(
                (_) => vehicleProvider.loadVehicles(),
              ); // Refresh the list after returning
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
