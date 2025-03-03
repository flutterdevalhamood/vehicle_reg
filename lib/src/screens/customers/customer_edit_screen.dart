import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sample/src/models/customer_model.dart';
import 'package:sample/src/providers/customer_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerEditScreen extends StatefulWidget {
  final Customer customer;

  const CustomerEditScreen({super.key, required this.customer});

  @override
  _CustomerEditScreenState createState() => _CustomerEditScreenState();
}

class _CustomerEditScreenState extends State<CustomerEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _companyNameController;
  late TextEditingController _addressController;
  late TextEditingController _representativeController;
  late TextEditingController _landlineController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;

  String _trmCertificatePath = '';
  String _tradeLicensePath = '';
  String _ownerIdPath = '';
  String _powerOfAttorneyPath = '';

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the customer's data
    _companyNameController = TextEditingController(
      text: widget.customer.companyName,
    );
    _addressController = TextEditingController(text: widget.customer.address);
    _representativeController = TextEditingController(
      text: widget.customer.representative,
    );
    _landlineController = TextEditingController(text: widget.customer.landline);
    _mobileController = TextEditingController(text: widget.customer.mobile);
    _emailController = TextEditingController(text: widget.customer.email);

    _trmCertificatePath = widget.customer.trmCertificatePath;
    _tradeLicensePath = widget.customer.tradeLicensePath;
    _ownerIdPath = widget.customer.ownerIdPath;
    _powerOfAttorneyPath = widget.customer.powerOfAttorneyPath;
  }

  Future<void> _viewFile(String filePath) async {
    if (filePath.endsWith('.jpg') ||
        filePath.endsWith('.jpeg') ||
        filePath.endsWith('.png')) {
      // Display image in a dialog
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(child: Image.file(File(filePath), fit: BoxFit.cover));
        },
      );
    } else if (filePath.endsWith('.pdf')) {
      // Open PDF using url_launcher
      final uri = Uri.file(filePath);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not open the file.')));
      }
    } else {
      // Handle other file types
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('File type not supported.')));
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    _companyNameController.dispose();
    _addressController.dispose();
    _representativeController.dispose();
    _landlineController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Customer'),
        actions: [
          IconButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Save the updated customer data
                final updatedCustomer = Customer(
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

                // Update the customer in the provider
                customerProvider.updateCustomer(
                  widget.customer,
                  updatedCustomer,
                );

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Customer updated successfully!')),
                );

                // Navigate back
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
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
                _buildTextField(
                  controller: _mobileController,
                  label: 'Mobile',
                  icon: Icons.phone_android,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter mobile number';
                    }
                    if (!value.startsWith('+971')) {
                      return 'Mobile number must start with +971';
                    }
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
                _buildEditableFileUpload(
                  context,
                  'TRM Certificate',
                  _trmCertificatePath,
                  (path) {
                    setState(() {
                      _trmCertificatePath = path;
                    });
                  },
                  () {
                    setState(() {
                      _trmCertificatePath = '';
                    });
                  },
                ),
                _buildEditableFileUpload(
                  context,
                  'Trade License',
                  _tradeLicensePath,
                  (path) {
                    setState(() {
                      _tradeLicensePath = path;
                    });
                  },
                  () {
                    setState(() {
                      _tradeLicensePath = '';
                    });
                  },
                ),
                _buildEditableFileUpload(
                  context,
                  'Owner/Representative ID',
                  _ownerIdPath,
                  (path) {
                    setState(() {
                      _ownerIdPath = path;
                    });
                  },
                  () {
                    setState(() {
                      _ownerIdPath = '';
                    });
                  },
                ),
                _buildEditableFileUpload(
                  context,
                  'Power of Attorney',
                  _powerOfAttorneyPath,
                  (path) {
                    setState(() {
                      _powerOfAttorneyPath = path;
                    });
                  },
                  () {
                    setState(() {
                      _powerOfAttorneyPath = '';
                    });
                  },
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

  Widget _buildEditableFileUpload(
    BuildContext context,
    String label,
    String filePath,
    Function(String) setFilePath,
    Function() onRemove,
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
                if (filePath.isNotEmpty) ...[
                  IconButton(
                    onPressed: () => _viewFile(filePath),
                    icon: Icon(Icons.visibility, color: Colors.blue.shade900),
                  ),
                  IconButton(
                    onPressed: onRemove,
                    icon: Icon(Icons.close, color: Colors.red),
                  ),
                ],
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
