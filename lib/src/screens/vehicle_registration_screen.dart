import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sample/src/constants/image_constants.dart';
import 'package:sample/src/providers/vehicle_provider.dart';
import 'package:sample/src/util/app_navigation.dart';
import 'package:sample/src/util/app_routes.dart';

class VehicleRegistrationScreen extends StatefulWidget {
  const VehicleRegistrationScreen({super.key});

  @override
  State<VehicleRegistrationScreen> createState() =>
      _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState extends State<VehicleRegistrationScreen> {
  late List<String> _predefinedImages;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<VehicleProvider>(context, listen: false).clearControllers();
    });
    _predefinedImages = [
      ImageConstants.heavyvehicle1(context),
      ImageConstants.heavyvehicle2(context),
      ImageConstants.heavyvehicle3(context),
      ImageConstants.heavyvehicle4(context),
      ImageConstants.heavyvehicle5(context),
      ImageConstants.heavyvehicle6(context),
    ];
    super.initState();
  }

  // Controllers for text fields
  final _plateNumberController = TextEditingController();
  final _capacityController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    // Clean up controllers
    _plateNumberController.dispose();
    _capacityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // // Dropdown values
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
  final List<File> _selectedImages = [];

  // Save data locally
  // Future<void> _saveData() async {
  //   List<String> existingVehicles = prefs?.getStringList('vehicles') ?? [];
  //   Map<String, dynamic> newVehicle = {
  //     'type': _selectedType ?? '',
  //     'plateNumber': _plateNumberController.text,
  //     'capacity': _capacityController.text,
  //     'capacityUnit': _selectedCapacityUnit ?? '',
  //     'note': _noteController.text,
  //     'images':
  //         _selectedImages.map((image) => image.path.split('/').last).toList(),
  //   };
  //   existingVehicles.add(jsonEncode(newVehicle));
  //   await prefs?.setStringList('vehicles', existingVehicles);
  //
  //   final vehicleProvider = Provider.of<VehicleProvider>(
  //     context,
  //     listen: false,
  //   );
  //   await vehicleProvider.loadVehicles();
  //
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Vehicle details saved successfully!')),
  //   );
  //   NavigationService().pushNavigation(Screenroutes.homeScreen);
  // }

  Future<void> _logout() async {
    NavigationService().navigateToUntil(Screenroutes.login);
  }

  Future<File> _saveImageToAppDirectory(File imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    return savedImage;
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final File savedImage = await _saveImageToAppDirectory(File(image.path));
      Provider.of<VehicleProvider>(context, listen: false).addImage(savedImage);
      // setState(() {
      //   _selectedImages.add(savedImage);
      // });
    }
  }

  Future<void> _captureImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final File savedImage = await _saveImageToAppDirectory(File(image.path));
      Provider.of<VehicleProvider>(context, listen: false).addImage(savedImage);
    }
  }

  // Add predefined image to selected images
  void _addPredefinedImage(String imagePath) async {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    try {
      // Load the image from the asset bundle
      final byteData = await rootBundle.load(imagePath);

      // Use the app's document directory (persistent storage) instead of temporary directory
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = imagePath.split('/').last; // Extract the file name
      final file = File('${appDir.path}/$fileName');

      // Check if the file already exists to avoid duplicates
      if (!file.existsSync()) {
        await file.writeAsBytes(byteData.buffer.asUint8List());
      }

      Provider.of<VehicleProvider>(context, listen: false).addImage(file);
    } catch (e) {
      print('Error adding predefined image: $e');
    }
    // final byteData = await rootBundle.load(imagePath);
    // final tempDir = await getTemporaryDirectory();
    // final file = File('${tempDir.path}/${imagePath.split('/').last}');
    // await file.writeAsBytes(byteData.buffer.asUint8List());
    //
    // setState(() {
    //   _selectedImages.add(file);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Vehicle Registration'), centerTitle: true),
      body: Stack(
        children: [
          // Scrollable Content
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
                  value: vehicleProvider.selectedType,
                  items:
                      _typeOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (newValue) {
                    vehicleProvider.setSelectedType(newValue);
                  },
                ),
                SizedBox(height: 20),

                // Plate Number TextField
                TextField(
                  controller: vehicleProvider.plateNumberController,
                  decoration: InputDecoration(
                    labelText: 'Plate Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),

                // Capacity Row (TextField + Dropdown)
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: vehicleProvider.capacityController,
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
                        value: vehicleProvider.selectedCapacity,
                        items:
                            _capacityUnitOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (newValue) {
                          vehicleProvider.setSelectedCapacity(newValue);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Note TextField
                TextField(
                  controller: vehicleProvider.noteController,
                  decoration: InputDecoration(
                    labelText: 'Note',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 20),

                // Image Section
                Text(
                  'Pictures',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // Predefined Images GridView
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _predefinedImages.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        final byteData = await rootBundle.load(
                          _predefinedImages[index],
                        );
                        final appDir = await getApplicationDocumentsDirectory();
                        final fileName =
                            _predefinedImages[index].split('/').last;
                        final file = File('${appDir.path}/$fileName');
                        if (!file.existsSync()) {
                          await file.writeAsBytes(
                            byteData.buffer.asUint8List(),
                          );
                        }
                        Provider.of<VehicleProvider>(
                          context,
                          listen: false,
                        ).addImage(file);
                        // _addPredefinedImage(_predefinedImages[index]);
                      },
                      child: Image.asset(
                        _predefinedImages[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),

                // Selected Images GridView
                vehicleProvider.selectedImages.isNotEmpty
                    ? GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: vehicleProvider.selectedImages.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            // Image
                            Image.file(
                              vehicleProvider.selectedImages[index],
                              fit: BoxFit.cover,
                            ),
                            // Close Icon
                            GestureDetector(
                              onTap: () => vehicleProvider.removeImage(index),
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
                      },
                    )
                    : Text('No images selected.'),
                SizedBox(height: 10),
                // Buttons for adding images
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _pickImageFromGallery();
                      },
                      icon: Icon(Icons.photo_library),
                      label: Text('Gallery'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _captureImageFromCamera();
                      },
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
              color: Colors.white,
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  await vehicleProvider.saveData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Vehicle details saved successfully!'),
                    ),
                  );
                  NavigationService().pushNavigation(Screenroutes.homeScreen);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(double.infinity, 50), // Full width
                ),
                child: Text('Save', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
