class Customer {
  final String companyName;
  final String address;
  final String representative;
  final String landline;
  final String mobile;
  final String email;
  final String trmCertificatePath;
  final String tradeLicensePath;
  final String ownerIdPath;
  final String powerOfAttorneyPath;

  Customer({
    required this.companyName,
    required this.address,
    required this.representative,
    required this.landline,
    required this.mobile,
    required this.email,
    required this.trmCertificatePath,
    required this.tradeLicensePath,
    required this.ownerIdPath,
    required this.powerOfAttorneyPath,
  });

  // Convert a Customer object to a Map
  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'address': address,
      'representative': representative,
      'landline': landline,
      'mobile': mobile,
      'email': email,
      'trmCertificatePath': trmCertificatePath,
      'tradeLicensePath': tradeLicensePath,
      'ownerIdPath': ownerIdPath,
      'powerOfAttorneyPath': powerOfAttorneyPath,
    };
  }

  // Create a Customer object from a Map
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      companyName: map['companyName'],
      address: map['address'],
      representative: map['representative'],
      landline: map['landline'],
      mobile: map['mobile'],
      email: map['email'],
      trmCertificatePath: map['trmCertificatePath'],
      tradeLicensePath: map['tradeLicensePath'],
      ownerIdPath: map['ownerIdPath'],
      powerOfAttorneyPath: map['powerOfAttorneyPath'],
    );
  }
}
