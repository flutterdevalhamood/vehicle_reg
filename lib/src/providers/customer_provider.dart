// import 'package:flutter/material.dart';
// import 'package:sample/src/models/customer_model.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Import the Customer model
//
// class CustomerProvider with ChangeNotifier {
//   // Form fields for customer registration
//   String _companyName = '';
//   String _address = '';
//   String _representative = '';
//   String _landline = '';
//   String _mobile = '';
//   String _email = '';
//   String _trmCertificatePath = '';
//   String _tradeLicensePath = '';
//   String _ownerIdPath = '';
//   String _powerOfAttorneyPath = '';
//
//   // List of registered customers
//   List<Customer> _customers = [];
//
//   // Getters for form fields
//   String get companyName => _companyName;
//   String get address => _address;
//   String get representative => _representative;
//   String get landline => _landline;
//   String get mobile => _mobile;
//   String get email => _email;
//   String get trmCertificatePath => _trmCertificatePath;
//   String get tradeLicensePath => _tradeLicensePath;
//   String get ownerIdPath => _ownerIdPath;
//   String get powerOfAttorneyPath => _powerOfAttorneyPath;
//
//   // Getters for customer list
//   List<Customer> get customers => _customers;
//
//   // Setters for form fields
//   void setCompanyName(String value) {
//     _companyName = value;
//     notifyListeners();
//   }
//
//   void setAddress(String value) {
//     _address = value;
//     notifyListeners();
//   }
//
//   void setRepresentative(String value) {
//     _representative = value;
//     notifyListeners();
//   }
//
//   void setLandline(String value) {
//     _landline = value;
//     notifyListeners();
//   }
//
//   void setMobile(String value) {
//     _mobile = value;
//     notifyListeners();
//   }
//
//   void setEmail(String value) {
//     _email = value;
//     notifyListeners();
//   }
//
//   void setTrmCertificatePath(String path) {
//     _trmCertificatePath = path;
//     notifyListeners();
//   }
//
//   void setTradeLicensePath(String path) {
//     _tradeLicensePath = path;
//     notifyListeners();
//   }
//
//   void setOwnerIdPath(String path) {
//     _ownerIdPath = path;
//     notifyListeners();
//   }
//
//   void setPowerOfAttorneyPath(String path) {
//     _powerOfAttorneyPath = path;
//     notifyListeners();
//   }
//
//   // Save customer details to SharedPreferences
//   Future<void> saveCustomer() async {
//     final customer = Customer(
//       companyName: _companyName,
//       address: _address,
//       representative: _representative,
//       landline: _landline,
//       mobile: _mobile,
//       email: _email,
//       trmCertificatePath: _trmCertificatePath,
//       tradeLicensePath: _tradeLicensePath,
//       ownerIdPath: _ownerIdPath,
//       powerOfAttorneyPath: _powerOfAttorneyPath,
//     );
//
//     _customers.add(customer); // Add the new customer to the list
//     await _saveCustomers();
//     print(
//       'customerlist $_customers',
//     ); // Save the updated list to SharedPreferences
//     notifyListeners();
//   }
//
//   // Save the list of customers to SharedPreferences
//   Future<void> _saveCustomers() async {
//     final prefs = await SharedPreferences.getInstance();
//     final customerMaps =
//         _customers.map((customer) => customer.toMap()).toList();
//     await prefs.setStringList(
//       'customers',
//       customerMaps.map((map) => map.toString()).toList(),
//     );
//     print('customermaps $customerMaps');
//   }
//
//   // Load customers from SharedPreferences
//   Future<void> loadCustomers() async {
//     final prefs = await SharedPreferences.getInstance();
//     final customerStrings = prefs.getStringList('customers') ?? [];
//     _customers =
//         customerStrings.map((string) {
//           // Convert the string to a Map<String, dynamic>
//           final map = Map<String, dynamic>.fromEntries(
//             string.substring(1, string.length - 1).split(', ').map((entry) {
//               final parts = entry.split(': ');
//               return MapEntry(parts[0].trim(), parts[1].trim());
//             }),
//           );
//           return Customer.fromMap(map);
//         }).toList();
//     notifyListeners();
//   }
//
//   // Clear form fields after registration
//   void clearForm() {
//     _companyName = '';
//     _address = '';
//     _representative = '';
//     _landline = '';
//     _mobile = '';
//     _email = '';
//     _trmCertificatePath = '';
//     _tradeLicensePath = '';
//     _ownerIdPath = '';
//     _powerOfAttorneyPath = '';
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:sample/src/models/customer_model.dart'; // Import the Customer model
import 'package:shared_preferences/shared_preferences.dart';

class CustomerProvider with ChangeNotifier {
  // List of registered customers
  List<Customer> _customers = [];

  // Getters for customer list
  List<Customer> get customers => _customers;

  // Fetch a specific customer by index
  Customer getCustomerByIndex(int index) {
    return _customers[index];
  }

  // Save customer details to SharedPreferences
  Future<void> saveCustomer(Customer customer) async {
    _customers.add(customer); // Add the new customer to the list
    await _saveCustomers(); // Save the updated list to SharedPreferences
    notifyListeners();
  }

  // Save the list of customers to SharedPreferences
  Future<void> _saveCustomers() async {
    final prefs = await SharedPreferences.getInstance();
    final customerMaps =
        _customers.map((customer) => customer.toMap()).toList();
    await prefs.setStringList(
      'customers',
      customerMaps.map((map) => map.toString()).toList(),
    );
  }

  // Load customers from SharedPreferences
  Future<void> loadCustomers() async {
    final prefs = await SharedPreferences.getInstance();
    final customerStrings = prefs.getStringList('customers') ?? [];
    _customers =
        customerStrings.map((string) {
          // Convert the string to a Map<String, dynamic>
          final map = Map<String, dynamic>.fromEntries(
            string.substring(1, string.length - 1).split(', ').map((entry) {
              final parts = entry.split(': ');
              return MapEntry(parts[0].trim(), parts[1].trim());
            }),
          );
          return Customer.fromMap(map);
        }).toList();
    notifyListeners();
  }
}
