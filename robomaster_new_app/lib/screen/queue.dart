import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:robomaster_new_app/model/order.dart' as MyAppOrder;

class QueueScreen extends StatelessWidget {
  const QueueScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Queue',
          style: TextStyle(
            color: Colors.white, // ตั้งค่าสีตัวอักษรเป็นสีขาวที่นี่
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('queue')
            .orderBy('timestamp')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final List<MyAppOrder.Order> orderList = snapshot.data!.docs
              .map((DocumentSnapshot document) =>
                  MyAppOrder.Order.fromSnapshot(document))
              .toList();

          return ListView.builder(
            itemCount: orderList.length,
            itemBuilder: (context, index) {
              return OrderCard(
                orderNumber: index + 1,
                order: orderList[index],
                onTap: () => showOrderDetails(context, orderList[index]),
                onDelete: () => removeOrder(context, orderList[index].documentId),
              );
            },
          );
        },
      ),
    );
  }

  void removeOrder(BuildContext context, String documentId) async {
    // Remove the order from the 'queue' collection in Firestore
    await FirebaseFirestore.instance.collection('queue').doc(documentId).delete();

    // Show SnackBar to notify the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order removed successfully'),
      ),
    );
  }

  void showOrderDetails(BuildContext context, MyAppOrder.Order order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Order Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('User Email: ${order.userEmail}'),
              Text('Additional Info: ${order.additionalInfo}'),
              Text('Package Type: ${order.packageType}'),
              Text('Beginning: ${order.beginning}'),
              Text('Destination: ${order.destination}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final int orderNumber;
  final MyAppOrder.Order order;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const OrderCard({
    Key? key,
    required this.orderNumber,
    required this.order,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order $orderNumber: ${order.userEmail}'),
            Text(
              'Additional Info: ${order.additionalInfo}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              'Package Type: ${order.packageType}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        onTap: onTap,
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
