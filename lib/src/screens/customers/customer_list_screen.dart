import 'dart:async'; // For Timer

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/src/providers/customer_provider.dart';
import 'package:sample/src/util/app_colors.dart';
import 'package:sample/src/util/app_navigation.dart';
import 'package:sample/src/util/app_routes.dart';
// Import the CustomerProvider

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load customers when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CustomerProvider>(context, listen: false).loadCustomers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  // Debounce search logic
  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query;
      });
    });
  }

  void _navigateToCustomerEdit(BuildContext context, int index) {
    NavigationService().pushNavigation(Screenroutes.customerEdit);
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);
    final customers =
        customerProvider.customers
            .where(
              (customer) =>
                  customer.companyName.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
                  customer.representative.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Customer List')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Search Box
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by company or representative...',
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
            // Customer List
            Expanded(
              child:
                  customers.isEmpty
                      ? Center(
                        child: Text(
                          _searchQuery.isEmpty
                              ? 'No customers registered yet.'
                              : 'No results found.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                      : ListView.builder(
                        // padding: EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: customers.length,
                        itemBuilder: (context, index) {
                          final customer = customers[index];
                          return GestureDetector(
                            onTap: () {
                              NavigationService().pushNavigation(
                                Screenroutes.customerDetail,
                                arguments: index,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Card(
                                elevation: 4.0,
                                margin: EdgeInsets.only(bottom: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(16.0),
                                  leading: Icon(Icons.person, size: 30),
                                  title: Text(
                                    customer.companyName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    'Representative: ${customer.representative}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.copyWith(
                                      color: Appcolors.textLightGrayColor(
                                        context,
                                      ),
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.edit, color: Colors.blue),
                                      SizedBox(width: 8),
                                      Icon(Icons.delete, color: Colors.red),
                                    ],
                                  ),
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
    );
  }
}
