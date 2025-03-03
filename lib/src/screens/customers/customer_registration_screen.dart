// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart'; // For file upload
// import 'package:provider/provider.dart';
// import 'package:sample/src/providers/customer_provider.dart';
// import 'package:sample/src/util/input_validator.dart'; // Import the CustomerProvider
//
// class CustomerRegistrationScreen extends StatefulWidget {
//   const CustomerRegistrationScreen({super.key});
//
//   @override
//   _CustomerRegistrationScreenState createState() =>
//       _CustomerRegistrationScreenState();
// }
//
// class _CustomerRegistrationScreenState
//     extends State<CustomerRegistrationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _companyNameController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _representativeController =
//       TextEditingController();
//   final TextEditingController _landlineController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     final customerProvider = Provider.of<CustomerProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Customer Registration')),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.blue.shade50, Colors.white],
//           ),
//         ),
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 SizedBox(height: 20),
//                 Text(
//                   'Register a New Customer',
//                   style:
//                       Theme.of(
//                         context,
//                       ).textTheme.displayMedium, // Use displayMedium
//                 ),
//                 SizedBox(height: 20),
//                 _buildTextField(
//                   controller: _companyNameController,
//                   label: 'Company Name',
//                   icon: Icons.business,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter company name';
//                     }
//                     return null;
//                   },
//                   // onChanged: (value) => customerProvider.setCompanyName(value),
//                 ),
//                 _buildTextField(
//                   controller: _addressController,
//                   label: 'Address',
//                   icon: Icons.location_on,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter address';
//                     }
//                     return null;
//                   },
//                   onChanged: (value) => customerProvider.setAddress(value),
//                 ),
//                 _buildTextField(
//                   controller: _representativeController,
//                   label: 'Representative',
//                   icon: Icons.person,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter representative name';
//                     }
//                     return null;
//                   },
//                   onChanged:
//                       (value) => customerProvider.setRepresentative(value),
//                 ),
//                 _buildTextField(
//                   controller: _landlineController,
//                   label: 'Landline',
//                   icon: Icons.phone,
//                   keyboardType: TextInputType.phone,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter landline number';
//                     }
//                     // if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
//                     //   return 'Landline number must contain only digits';
//                     // }
//                     return null;
//                   },
//                   onChanged: (value) => customerProvider.setLandline(value),
//                 ),
//                 _buildTextField(
//                   controller: _mobileController,
//                   label: 'Mobile',
//                   icon: Icons.phone_android,
//                   keyboardType: TextInputType.phone,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter mobile number';
//                     }
//                     // if (!value.startsWith('+971')) {
//                     //   return 'Mobile number must start with +971';
//                     // }
//                     // if (!RegExp(r'^\+971[0-9]{9}$').hasMatch(value)) {
//                     //   return 'Enter a valid UAE mobile number (e.g., +971501234567)';
//                     // }
//                     return null;
//                   },
//                   onChanged: (value) => customerProvider.setMobile(value),
//                 ),
//                 _buildTextField(
//                   controller: _emailController,
//                   label: 'Email',
//                   icon: Icons.email,
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter email';
//                     }
//                     if (!RegExp(
//                       r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                     ).hasMatch(value)) {
//                       return 'Enter a valid email address';
//                     }
//                     return null;
//                   },
//                   // onChanged: (value) => customerProvider.setEmail(value),
//                 ),
//                 SizedBox(height: 20),
//                 _buildFileUpload(
//                   context,
//                   'TRM Certificate',
//                   customerProvider.trmCertificatePath,
//                   (path) => customerProvider.setTrmCertificatePath(path),
//                 ),
//                 _buildFileUpload(
//                   context,
//                   'Trade License',
//                   customerProvider.tradeLicensePath,
//                   (path) => customerProvider.setTradeLicensePath(path),
//                 ),
//                 _buildFileUpload(
//                   context,
//                   'Owner/Representative ID',
//                   customerProvider.ownerIdPath,
//                   (path) => customerProvider.setOwnerIdPath(path),
//                 ),
//                 _buildFileUpload(
//                   context,
//                   'Power of Attorney',
//                   customerProvider.powerOfAttorneyPath,
//                   (path) => customerProvider.setPowerOfAttorneyPath(path),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () async {
//                     if (_formKey.currentState!.validate()) {
//                       await customerProvider.saveCustomer();
//                       customerProvider
//                           .clearForm(); // Clear the form after saving
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('Customer registered successfully!'),
//                         ),
//                       );
//                       Navigator.pop(context); // Navigate back after submission
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     backgroundColor: Colors.blue.shade900,
//                   ),
//                   child: Text(
//                     'Submit',
//                     style: TextStyle(fontSize: 18, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     required String? Function(String?) validator,
//     // required Function(String) onChanged,
//     TextInputType? keyboardType,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: TextFormField(
//         controller: controller,
//         inputFormatters: InputValidator.userIdValidator(),
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, color: Colors.blue.shade900),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(color: Colors.blue.shade900),
//           ),
//         ),
//         keyboardType: keyboardType,
//         validator: validator,
//         // onChanged: onChanged,
//       ),
//     );
//   }
//
//   Widget _buildFileUpload(
//     BuildContext context,
//     String label,
//     String filePath,
//     Function(String) setFilePath,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(fontSize: 16, color: Colors.blue.shade900),
//           ),
//           SizedBox(height: 8),
//           Container(
//             padding: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.blue.shade900),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     filePath.isNotEmpty ? filePath : 'No file selected',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () async {
//                     final pickedFile = await ImagePicker().pickImage(
//                       source: ImageSource.gallery,
//                     );
//                     if (pickedFile != null) {
//                       setFilePath(pickedFile.path);
//                     }
//                   },
//                   icon: Icon(Icons.upload, color: Colors.blue.shade900),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart'; // For file upload
// // import 'package:provider/provider.dart';
// // import 'package:sample/src/providers/customer_provider.dart';
// //
// // class CustomerRegistrationScreen extends StatefulWidget {
// //   const CustomerRegistrationScreen({super.key});
// //
// //   @override
// //   _CustomerRegistrationScreenState createState() =>
// //       _CustomerRegistrationScreenState();
// // }
// //
// // class _CustomerRegistrationScreenState
// //     extends State<CustomerRegistrationScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final TextEditingController _companyNameController = TextEditingController();
// //   final TextEditingController _addressController = TextEditingController();
// //   final TextEditingController _representativeController =
// //       TextEditingController();
// //   final TextEditingController _landlineController = TextEditingController();
// //   final TextEditingController _mobileController = TextEditingController();
// //   final TextEditingController _emailController = TextEditingController();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     // Clear file paths when the screen is initialized
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       final customerProvider = Provider.of<CustomerProvider>(
// //         context,
// //         listen: false,
// //       );
// //       customerProvider.setTrmCertificatePath('');
// //       customerProvider.setTradeLicensePath('');
// //       customerProvider.setOwnerIdPath('');
// //       customerProvider.setPowerOfAttorneyPath('');
// //     });
// //     _mobileController.text = '+971';
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final customerProvider = Provider.of<CustomerProvider>(context);
// //
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Customer Registration')),
// //       body: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //             colors: [Colors.blue.shade50, Colors.white],
// //           ),
// //         ),
// //         child: SingleChildScrollView(
// //           padding: EdgeInsets.all(16.0),
// //           child: Form(
// //             key: _formKey,
// //             child: Column(
// //               children: [
// //                 SizedBox(height: 20),
// //                 Text(
// //                   'Register a New Customer',
// //                   style:
// //                       Theme.of(
// //                         context,
// //                       ).textTheme.displayMedium, // Use displayMedium
// //                 ),
// //                 SizedBox(height: 20),
// //                 _buildTextField(
// //                   controller: _companyNameController,
// //                   label: 'Company Name',
// //                   icon: Icons.business,
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please enter company name';
// //                     }
// //                     return null;
// //                   },
// //                   onChanged: (value) => customerProvider.setCompanyName(value),
// //                 ),
// //                 _buildTextField(
// //                   controller: _addressController,
// //                   label: 'Address',
// //                   icon: Icons.location_on,
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please enter address';
// //                     }
// //                     return null;
// //                   },
// //                   onChanged: (value) => customerProvider.setAddress(value),
// //                 ),
// //                 _buildTextField(
// //                   controller: _representativeController,
// //                   label: 'Representative',
// //                   icon: Icons.person,
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please enter representative name';
// //                     }
// //                     return null;
// //                   },
// //                   onChanged:
// //                       (value) => customerProvider.setRepresentative(value),
// //                 ),
// //                 _buildTextField(
// //                   controller: _landlineController,
// //                   label: 'Landline',
// //                   icon: Icons.phone,
// //                   keyboardType: TextInputType.phone,
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please enter landline number';
// //                     }
// //                     if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
// //                       return 'Landline number must contain only digits';
// //                     }
// //                     return null;
// //                   },
// //                   onChanged: (value) => customerProvider.setLandline(value),
// //                 ),
// //                 _buildMobileTextField(
// //                   controller: _mobileController,
// //                   label: 'Mobile',
// //                   icon: Icons.phone_android,
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please enter mobile number';
// //                     }
// //                     if (!RegExp(r'^[0-9]{9}$').hasMatch(value)) {
// //                       return 'Enter a valid UAE mobile number (e.g., +971501234567)';
// //                     }
// //                     return null;
// //                   },
// //                   onChanged: (value) => customerProvider.setMobile(value),
// //                 ),
// //                 _buildTextField(
// //                   controller: _emailController,
// //                   label: 'Email',
// //                   icon: Icons.email,
// //                   keyboardType: TextInputType.emailAddress,
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please enter email';
// //                     }
// //                     if (!RegExp(
// //                       r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
// //                     ).hasMatch(value)) {
// //                       return 'Enter a valid email address';
// //                     }
// //                     return null;
// //                   },
// //                   onChanged: (value) => customerProvider.setEmail(value),
// //                 ),
// //                 SizedBox(height: 20),
// //                 _buildFileUpload(
// //                   context,
// //                   'TRM Certificate',
// //                   customerProvider.trmCertificatePath,
// //                   (path) => customerProvider.setTrmCertificatePath(path),
// //                 ),
// //                 _buildFileUpload(
// //                   context,
// //                   'Trade License',
// //                   customerProvider.tradeLicensePath,
// //                   (path) => customerProvider.setTradeLicensePath(path),
// //                 ),
// //                 _buildFileUpload(
// //                   context,
// //                   'Owner/Representative ID',
// //                   customerProvider.ownerIdPath,
// //                   (path) => customerProvider.setOwnerIdPath(path),
// //                 ),
// //                 _buildFileUpload(
// //                   context,
// //                   'Power of Attorney',
// //                   customerProvider.powerOfAttorneyPath,
// //                   (path) => customerProvider.setPowerOfAttorneyPath(path),
// //                 ),
// //                 SizedBox(height: 20),
// //                 ElevatedButton(
// //                   onPressed: () async {
// //                     if (_formKey.currentState!.validate()) {
// //                       await customerProvider.saveCustomer();
// //                       customerProvider
// //                           .clearForm(); // Clear the form after saving
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         SnackBar(
// //                           content: Text('Customer registered successfully!'),
// //                         ),
// //                       );
// //                       Navigator.pop(context); // Navigate back after submission
// //                     }
// //                   },
// //                   style: ElevatedButton.styleFrom(
// //                     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     backgroundColor: Colors.blue.shade900,
// //                   ),
// //                   child: Text(
// //                     'Submit',
// //                     style: TextStyle(fontSize: 18, color: Colors.white),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTextField({
// //     required TextEditingController controller,
// //     required String label,
// //     required IconData icon,
// //     required String? Function(String?) validator,
// //     required Function(String) onChanged,
// //     TextInputType? keyboardType,
// //   }) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 16.0),
// //       child: TextFormField(
// //         controller: controller,
// //         decoration: InputDecoration(
// //           labelText: label,
// //           prefixIcon: Icon(icon, color: Colors.blue.shade900),
// //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //           focusedBorder: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(10),
// //             borderSide: BorderSide(color: Colors.blue.shade900),
// //           ),
// //         ),
// //         keyboardType: keyboardType,
// //         validator: validator,
// //         onChanged: onChanged,
// //       ),
// //     );
// //   }
// //
// //   Widget _buildMobileTextField({
// //     required TextEditingController controller,
// //     required String label,
// //     required IconData icon,
// //     required String? Function(String?) validator,
// //     required Function(String) onChanged,
// //   }) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 16.0),
// //       child: TextFormField(
// //         controller: controller,
// //         decoration: InputDecoration(
// //           labelText: label,
// //           prefixIcon: Icon(icon, color: Colors.blue.shade900),
// //           prefix: Padding(
// //             padding: const EdgeInsets.only(right: 8.0),
// //             child: Row(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Text('🇦🇪', style: TextStyle(fontSize: 20)), // UAE flag
// //                 SizedBox(width: 4),
// //                 Text(
// //                   '+971',
// //                   style: TextStyle(fontSize: 16),
// //                 ), // UAE country code
// //               ],
// //             ),
// //           ),
// //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //           focusedBorder: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(10),
// //             borderSide: BorderSide(color: Colors.blue.shade900),
// //           ),
// //         ),
// //         keyboardType: TextInputType.phone,
// //         validator: validator,
// //         onChanged: onChanged,
// //       ),
// //     );
// //   }
// //
// //   Widget _buildFileUpload(
// //     BuildContext context,
// //     String label,
// //     String filePath,
// //     Function(String) setFilePath,
// //   ) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 16.0),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             label,
// //             style: TextStyle(fontSize: 16, color: Colors.blue.shade900),
// //           ),
// //           SizedBox(height: 8),
// //           Container(
// //             padding: EdgeInsets.all(10),
// //             decoration: BoxDecoration(
// //               border: Border.all(color: Colors.blue.shade900),
// //               borderRadius: BorderRadius.circular(10),
// //             ),
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: Text(
// //                     filePath.isNotEmpty ? filePath : 'No file selected',
// //                     style: TextStyle(color: Colors.grey),
// //                   ),
// //                 ),
// //                 IconButton(
// //                   onPressed: () async {
// //                     final pickedFile = await ImagePicker().pickImage(
// //                       source: ImageSource.gallery,
// //                     );
// //                     if (pickedFile != null) {
// //                       setFilePath(pickedFile.path);
// //                     }
// //                   },
// //                   icon: Icon(Icons.upload, color: Colors.blue.shade900),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For file upload
import 'package:provider/provider.dart';
import 'package:sample/src/models/customer_model.dart'; // Import the Customer model
import 'package:sample/src/providers/customer_provider.dart';

class CustomerRegistrationScreen extends StatefulWidget {
  const CustomerRegistrationScreen({super.key});

  @override
  _CustomerRegistrationScreenState createState() =>
      _CustomerRegistrationScreenState();
}

class _CustomerRegistrationScreenState
    extends State<CustomerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _representativeController =
      TextEditingController();
  final TextEditingController _landlineController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _trmCertificatePath = '';
  String _tradeLicensePath = '';
  String _ownerIdPath = '';
  String _powerOfAttorneyPath = '';

  @override
  void initState() {
    super.initState();
    // Prepend +971 to the mobile controller
    // _mobileController.text = '+971';
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Customer Registration')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'Register a New Customer',
                  style:
                      Theme.of(
                        context,
                      ).textTheme.displayMedium, // Use displayMedium
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: _companyNameController,
                  label: 'Company Name',
                  icon: Icons.business,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company name';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _addressController,
                  label: 'Address',
                  icon: Icons.location_on,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter address';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _representativeController,
                  label: 'Representative',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter representative name';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _landlineController,
                  label: 'Landline',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter landline number';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Landline number must contain only digits';
                    }
                    return null;
                  },
                ),
                _buildMobileTextField(
                  controller: _mobileController,
                  label: 'Mobile',
                  icon: Icons.phone_android,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter mobile number';
                    }
                    // if (!value.startsWith('+971')) {
                    //   return 'Mobile number must start with +971';
                    // }
                    if (!RegExp(r'^\+971[0-9]{9}$').hasMatch(value)) {
                      return 'Enter a valid UAE mobile number (e.g., +971501234567)';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _buildFileUpload(
                  context,
                  'TRM Certificate',
                  _trmCertificatePath,
                  (path) {
                    setState(() {
                      _trmCertificatePath = path;
                    });
                  },
                ),
                _buildFileUpload(context, 'Trade License', _tradeLicensePath, (
                  path,
                ) {
                  setState(() {
                    _tradeLicensePath = path;
                  });
                }),
                _buildFileUpload(
                  context,
                  'Owner/Representative ID',
                  _ownerIdPath,
                  (path) {
                    setState(() {
                      _ownerIdPath = path;
                    });
                  },
                ),
                _buildFileUpload(
                  context,
                  'Power of Attorney',
                  _powerOfAttorneyPath,
                  (path) {
                    setState(() {
                      _powerOfAttorneyPath = path;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Create a Customer object
                      final customer = Customer(
                        companyName: _companyNameController.text,
                        address: _addressController.text,
                        representative: _representativeController.text,
                        landline: _landlineController.text,
                        mobile: _mobileController.text,
                        email: _emailController.text,
                        trmCertificatePath: _trmCertificatePath,
                        tradeLicensePath: _tradeLicensePath,
                        ownerIdPath: _ownerIdPath,
                        powerOfAttorneyPath: _powerOfAttorneyPath,
                      );

                      // Save the customer
                      await customerProvider.saveCustomer(customer);

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Customer registered successfully!'),
                        ),
                      );

                      // Navigate back
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.blue.shade900,
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue.shade900),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue.shade900),
          ),
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  Widget _buildMobileTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue.shade900),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue.shade900),
          ),
        ),
        keyboardType: TextInputType.phone,
        validator: validator,
      ),
    );
  }

  Widget _buildFileUpload(
    BuildContext context,
    String label,
    String filePath,
    Function(String) setFilePath,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.blue.shade900),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade900),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    filePath.isNotEmpty ? filePath : 'No file selected',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final pickedFile = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      setFilePath(pickedFile.path);
                    }
                  },
                  icon: Icon(Icons.upload, color: Colors.blue.shade900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
