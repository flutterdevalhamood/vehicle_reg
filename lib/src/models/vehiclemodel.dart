import 'dart:io';

class Vehicle {
  final String type;
  final String plateNumber;
  final String capacity;
  final String capacityUnit;
  final String note;
  final List<File> images;

  Vehicle({
    required this.type,
    required this.plateNumber,
    required this.capacity,
    required this.capacityUnit,
    required this.note,
    required this.images,
  });
}
