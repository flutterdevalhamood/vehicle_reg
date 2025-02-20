import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sample/src/providers/vehicle_provider.dart';
import 'package:sample/src/util/app_navigation.dart';
import 'package:sample/src/util/app_routes.dart';
import 'package:sample/src/util/shared_pref.dart';

class EditVehicleScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const EditVehicleScreen({super.key, required this.data});

  @override
  _EditVehicleScreenState createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  late TextEditingController _typeController;
  late TextEditingController _plateNumberController;
  late TextEditingController _capacityController;
  late TextEditingController _capacityUnitController;
  late TextEditingController _noteController;

  // Dropdown values
  String? _selectedType;
  String? _selectedCapacityUnit;

  // Dropdown options
  final List<String> _typeOptions = [
    'Flat trailer',
    'Fuel Tanker',
    'Equipments',
    'Water Tanker',
  ];
  final List<String> _capacityUnitOptions = ['IQ', 'Litres', 'Pcs'];

  // Image picker
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data
    _typeController = TextEditingController(text: widget.data['type'] ?? '');
    _plateNumberController = TextEditingController(
      text: widget.data['plateNumber'] ?? '',
    );
    _capacityController = TextEditingController(
      text: widget.data['capacity'] ?? '',
    );
    _capacityUnitController = TextEditingController(
      text: widget.data['capacityUnit'] ?? '',
    );
    _noteController = TextEditingController(text: widget.data['note'] ?? '');

    _selectedType = widget.data['type'];
    _selectedCapacityUnit = widget.data['capacityUnit'];
    _loadImages();
    // final List<String> imagePaths = List<String>.from(
    //   widget.data['images'] ?? [],
    // );
    // _selectedImages = imagePaths.map((path) => File(path)).toList();
  }

  Future<void> _loadImages() async {
    final appDir = await getApplicationDocumentsDirectory();
    final List<String> imageFileNames = List<String>.from(
      widget.data['images'] ?? [],
    );

    _selectedImages = [];
    for (final fileName in imageFileNames) {
      final file = File('${appDir.path}/$fileName');
      if (await file.exists()) {
        _selectedImages.add(file); // Add the File object
      }
    }

    setState(() {});
  }

  Future<void> _saveData() async {
    final List<String> imageFileNames =
        _selectedImages.map((file) => file.path.split('/').last).toList();
    // final List<String> imagePaths =
    //     _selectedImages.map((file) => file.path).toList();
    final vehicleData = {
      'type': _typeController.text,
      'plateNumber': _plateNumberController.text,
      'capacity': _capacityController.text,
      'capacityUnit': _capacityUnitController.text,
      'note': _noteController.text,
      'images': imageFileNames,
    };

    final vehicleProvider = Provider.of<VehicleProvider>(
      context,
      listen: false,
    );
    await vehicleProvider.addOrUpdateVehicle(vehicleData);

    Navigator.pop(context, vehicleData); // Return to the home screen
  }

  void _deleteData() async {
    // Show a confirmation dialog before deleting
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Vehicle'),
          content: Text('Are you sure you want to delete this vehicle?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    // If the user confirms deletion
    if (confirmDelete == true) {
      await prefs?.remove('vehicleData'); // Replace with your key

      // Show a confirmation message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Vehicle deleted successfully!')));

      // Navigate back to the previous screen
      Navigator.pop(context);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Vehicle Details')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Type Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedType,
                  items:
                      _typeOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedType = newValue;
                      _typeController.text = newValue ?? '';
                    });
                  },
                ),
                SizedBox(height: 20),

                // Plate Number TextField
                TextField(
                  readOnly: true,

                  controller: _plateNumberController,
                  decoration: InputDecoration(
                    labelText: 'Plate Number',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ), // Grey border when disabled
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ), // No highlight when focused
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                SizedBox(height: 20),

                // Capacity Row (TextField + Dropdown)
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _capacityController,
                        decoration: InputDecoration(
                          labelText: 'Capacity',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Unit',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedCapacityUnit,
                        items:
                            _capacityUnitOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCapacityUnit = newValue;
                            _capacityUnitController.text = newValue ?? '';
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Note TextField
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    labelText: 'Note',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 20),

                // Selected Images GridView
                _selectedImages.isNotEmpty
                    ? GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        final file = _selectedImages[index];
                        return FutureBuilder<bool>(
                          future: file.exists(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (!snapshot.hasData || !snapshot.data!) {
                              // File does not exist, show a placeholder
                              return Container(
                                width: 150,
                                color: Colors.grey[200],
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            } else {
                              // File exists, display the image
                              return Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Image.file(file, fit: BoxFit.cover),
                                  GestureDetector(
                                    onTap: () => _removeImage(index),
                                    child: Container(
                                      margin: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        );
                      },
                    )
                    : Text('No images selected.'),
                SizedBox(height: 10),

                // Buttons for adding images
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImageFromGallery,
                      icon: Icon(Icons.photo_library),
                      label: Text('Gallery'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _captureImageFromCamera,
                      icon: Icon(Icons.camera_alt),
                      label: Text('Camera'),
                    ),
                  ],
                ),
                SizedBox(height: 80), // Extra space for the Save button
              ],
            ),
          ),

          // Save Button (Sticky at the bottom)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              // color: Colors.white,
              padding: EdgeInsets.all(16.0),
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _deleteData,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(double.infinity, 10),
                          ),
                          child: Text('Delete', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveData,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(double.infinity, 10),
                          ),
                          child: Text('Save', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Red color for logout
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(double.infinity, 10),
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Save updated data

  // Remove image from selected images
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(
        image.path,
      ).copy('${appDir.path}/$fileName');
      setState(() {
        _selectedImages.add(savedImage); // Add the File object
      });
    }
  }

  Future<void> _captureImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(
        image.path,
      ).copy('${appDir.path}/$fileName');
      setState(() {
        _selectedImages.add(savedImage); // Add the File object
      });
    }
  }

  // Pick image from gallery
  // Future<void> _pickImageFromGallery() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     setState(() {
  //       _selectedImages.add(File(image.path));
  //     });
  //   }
  // }

  // Capture image from camera
  // Future<void> _captureImageFromCamera() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.camera);
  //   if (image != null) {
  //     setState(() {
  //       _selectedImages.add(File(image.path));
  //     });
  //   }
  // }
}
