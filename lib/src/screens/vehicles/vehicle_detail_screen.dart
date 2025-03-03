import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sample/src/util/app_navigation.dart';
import 'package:sample/src/util/app_sizes.dart';
import 'package:sample/src/util/shared_pref.dart';

class VehicleDetailScreen extends StatefulWidget {
  final Map<String, dynamic> vehicle;
  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  late Future<Map<String, dynamic>> _vehicleData;
  List<File> _selectedImages = [];
  late Directory appDir;

  @override
  void initState() {
    _loadVehicleData();
    _loadAppDirectory();
    _loadImagesFromAppDirectory();
    super.initState();
  }

  void _loadVehicleData() {
    setState(() {
      _vehicleData = _getSavedData();
    });
  }

  Future<void> _loadAppDirectory() async {
    appDir = await getApplicationDocumentsDirectory();
  }

  Future<void> _loadImagesFromAppDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final List<String> imageFileNames = List<String>.from(
      widget.vehicle['images'] ?? [],
    );

    _selectedImages = [];
    for (final fileName in imageFileNames) {
      final file = File('${appDir.path}/$fileName');
      if (await file.exists()) {
        _selectedImages.add(file);
      }
    }

    setState(() {});
    // final List<String> imagePaths = List<String>.from(
    //   widget.vehicle['images'] ?? [],
    // );
    //
    // // Filter out invalid paths and load only existing images
    // _selectedImages = [];
    // for (final path in imagePaths) {
    //   final file = File(path);
    //   if (await file.exists()) {
    //     _selectedImages.add(file);
    //   }
    // }
    //
    // setState(() {});
  }

  void showFullScreenImage(BuildContext context, File imageFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: GestureDetector(
              onTap: NavigationService().popNavigation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(imageFile, fit: BoxFit.cover),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _getSavedData() async {
    return {
      'type': prefs?.getString('type') ?? 'N/A',
      'plateNumber': prefs?.getString('plateNumber') ?? 'N/A',
      'capacity': prefs?.getString('capacity') ?? 'N/A',
      'capacityUnit': prefs?.getString('capacityUnit') ?? 'N/A',
      'note': prefs?.getString('note') ?? 'N/A',
      'images': prefs?.getStringList('images') ?? [],
    };
  }

  // Check if a file exists at the given path
  Future<bool> _fileExists(String path) async {
    return await File(path).exists();
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = widget.vehicle;
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Details'),
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor, // Use global theme
        iconTheme: Theme.of(context).appBarTheme.iconTheme, // Use global theme
      ),
      body: _getBody(context, vehicle),
    );
  }

  _getBody(BuildContext context, Map<String, dynamic> vehicle) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getSavedData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading data'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data found'));
        }

        final data = snapshot.data!;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade50, Colors.white],
            ),
          ),

          child: Column(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),

                    // Vehicle Type
                    _buildDetailCard(
                      Icons.directions_car,
                      'Type',
                      vehicle['type'],
                    ),
                    SizedBox(height: 16),

                    // Plate Number
                    _buildDetailCard(
                      Icons.confirmation_number,
                      'Plate Number',
                      vehicle['plateNumber'],
                    ),
                    SizedBox(height: 16),

                    // Capacity
                    _buildDetailCard(
                      Icons.storage,
                      'Capacity',
                      '${vehicle['capacity']} ${vehicle['capacityUnit']}',
                    ),
                    SizedBox(height: 16),

                    // Note
                    _buildDetailCard(Icons.note, 'Note', vehicle['note']),
                    SizedBox(height: 20),

                    // Images Section
                    if (vehicle['images'].isNotEmpty)
                      Text(
                        'Images',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    SizedBox(height: 10),
                    if (vehicle['images'].isNotEmpty)
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: vehicle['images'].length,
                          itemBuilder: (context, index) {
                            final imagePath = vehicle['images'][index];
                            return FutureBuilder<bool>(
                              future: _fileExists('${appDir.path}/$imagePath'),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (!snapshot.hasData ||
                                    !snapshot.data!) {
                                  // File does not exist, show a placeholder
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: 150,
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  // File exists, display the image
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: GestureDetector(
                                        onTap: () {
                                          File imageFile = File(
                                            '${appDir.path}/$imagePath',
                                          );
                                          showFullScreenImage(
                                            context,
                                            imageFile,
                                          );
                                        },
                                        child: Image.file(
                                          File('${appDir.path}/$imagePath'),
                                          width: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              // _buildEditButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: ElevatedButton(
        onPressed: () async {
          // final vehicleData = await _getSavedData();
          // final result = NavigationService().pushNavigation(
          //   Screenroutes.editDetail,
          //   arguments: vehicleData,
          // );
          // // await Navigator.push(
          // //   context,
          // //   MaterialPageRoute(
          // //     builder: (context) => EditVehicleScreen(data: vehicleData),
          // //   ),
          // // );
          //
          // if (result != null) {
          //   _loadVehicleData();
          // }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.blue,
        ),
        child: Text(
          'Edit Vehicle',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Helper method to build a detail card
  Widget _buildDetailCard(IconData? icon, String? label, String? value) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label ?? '',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    value ?? '',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: AppWidgetSizes.fontSize18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
