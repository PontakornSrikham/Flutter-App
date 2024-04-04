import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String documentId;
  final String packageType;
  final String additionalInfo;
  final String userEmail;
  final DateTime timestamp;
  final String beginning;
  final String destination;

  Order({
    required this.documentId,
    required this.packageType,
    required this.additionalInfo,
    required this.userEmail,
    required this.timestamp,
    required this.beginning,
    required this.destination,
  });

  factory Order.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Order(
      documentId: snapshot.id,
      packageType: data['package_type'] ?? '',
      additionalInfo: data['additional_info'] ?? '',
      userEmail: data['user_email'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      beginning: data['beginning'] ?? '',
      destination: data['destination'] ?? '',
    );
  }
}