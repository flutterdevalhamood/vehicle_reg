import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/src/providers/customer_provider.dart';

class CustomerDetailScreen extends StatelessWidget {
  final int customerIndex;

  const CustomerDetailScreen({super.key, required this.customerIndex});

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);
    final customer = customerProvider.getCustomerByIndex(customerIndex);

    return Scaffold(
      appBar: AppBar(title: Text('Customer Details')),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailCard(
                Icons.business,
                'Company Name',
                customer.companyName,
              ),
              SizedBox(height: 16),
              _buildDetailCard(Icons.location_on, 'Address', customer.address),
              SizedBox(height: 16),
              _buildDetailCard(
                Icons.person,
                'Representative',
                customer.representative,
              ),
              SizedBox(height: 16),
              _buildDetailCard(Icons.phone, 'Landline', customer.landline),
              SizedBox(height: 16),
              _buildDetailCard(Icons.phone_android, 'Mobile', customer.mobile),
              SizedBox(height: 16),
              _buildDetailCard(Icons.email, 'Email', customer.email),
              SizedBox(height: 20),
              if (customer.trmCertificatePath.isNotEmpty)
                _buildFileSection(
                  'TRM Certificate',
                  customer.trmCertificatePath,
                ),
              if (customer.tradeLicensePath.isNotEmpty)
                _buildFileSection('Trade License', customer.tradeLicensePath),
              if (customer.ownerIdPath.isNotEmpty)
                _buildFileSection(
                  'Owner/Representative ID',
                  customer.ownerIdPath,
                ),
              if (customer.powerOfAttorneyPath.isNotEmpty)
                _buildFileSection(
                  'Power of Attorney',
                  customer.powerOfAttorneyPath,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String label, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.blue.shade900),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    value,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileSection(String label, String filePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue.shade900,
            fontWeight: FontWeight.bold,
          ),
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
                child: Text(filePath, style: TextStyle(color: Colors.grey)),
              ),
              IconButton(
                onPressed: () {
                  // Handle file preview or download
                },
                icon: Icon(Icons.visibility, color: Colors.blue.shade900),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
