import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/src/providers/vehicle_provider.dart';
import 'package:sample/src/util/app_colors.dart';
import 'package:sample/src/util/app_navigation.dart';
import 'package:sample/src/util/app_routes.dart';

import 'vehicle_registration_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _searchQuery = '';
  bool confirmLogout = false;
  void _vehicleDetails(Map<String, dynamic> vehicle) {
    NavigationService().pushNavigation(
      Screenroutes.vehicleDetail,
      arguments: vehicle,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
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

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    final vehicles =
        vehicleProvider.vehicles
            .where(
              (vehicle) =>
                  vehicle['type'].toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
                  vehicle['plateNumber'].toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ),
            )
            .toList();
    ;
    return Consumer<VehicleProvider>(
      builder: (context, vehicleProvider, child) {
        // final vehicles = vehicleProvider.vehicles;
        return Scaffold(
          appBar: AppBar(
            title: Text('Vehicle List'),
            // leading: IconButton(
            //   onPressed: () => _logout(),
            //   icon: Icon(Icons.logout),
            // ),
          ),
          body:
              vehicles.isEmpty
                  ? Center(child: Text('No vehicles registered yet.'))
                  : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue.shade50, Colors.white],
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search by type or vehicle number',
                              hintStyle: TextStyle(
                                color: Appcolors.textLightGrayColor(context),
                              ),
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),

                            onChanged: _onSearchChanged,
                          ),
                        ),
                        Expanded(
                          child:
                              vehicles.isEmpty
                                  ? Center(
                                    child: Text(
                                      _searchQuery.isEmpty
                                          ? 'No vehicles registered yet.'
                                          : 'No results found.',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  )
                                  : ListView.builder(
                                    itemCount: vehicles.length,
                                    itemBuilder: (context, index) {
                                      final vehicle = vehicles[index];
                                      return Dismissible(
                                        key: Key(
                                          vehicle['plateNumber'] ??
                                              index.toString(),
                                        ),
                                        direction: DismissDirection.endToStart,
                                        background: Container(
                                          color: Colors.red,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onDismissed: (direction) {
                                          final vehicleProvider =
                                              Provider.of<VehicleProvider>(
                                                context,
                                                listen: false,
                                              );
                                          vehicleProvider.deleteVehicle(index);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 4,
                                          ),
                                          child: Card(
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: ListTile(
                                              contentPadding: EdgeInsets.all(
                                                16,
                                              ),
                                              leading: Icon(
                                                Icons.directions_car,
                                                size: 30,
                                                color: Colors.blue,
                                              ),
                                              title: Text(
                                                vehicle['plateNumber'] ??
                                                    'Unknown',
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
                                                    icon: Icon(
                                                      Icons.edit,
                                                      color: Colors.blue,
                                                    ),
                                                    onPressed: () async {
                                                      final result =
                                                          await NavigationService()
                                                              .pushNavigation(
                                                                Screenroutes
                                                                    .editDetail,
                                                                arguments:
                                                                    vehicle,
                                                              );
                                                      if (result != null) {
                                                        vehicleProvider
                                                            .addOrUpdateVehicle(
                                                              result,
                                                            );
                                                      }
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () async {
                                                      _deleteVehicle(index);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              onTap:
                                                  () =>
                                                      _vehicleDetails(vehicle),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                        ),
                      ],
                    ),
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
