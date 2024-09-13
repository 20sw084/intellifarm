import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/models/receipt.dart';
import '../../../controller/references.dart';

class ViewReceipts extends StatelessWidget {
  String plantingId;
  ViewReceipts({
    super.key,
    required this.plantingId,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          title: const Text('View Receipts'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Un-Approved'),
              Tab(text: 'Rejected'),
              Tab(text: 'Approved'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ReceiptUnApprovedList(plantingId: plantingId),
            ReceiptRejectedList(plantingId: plantingId),
            ReceiptApprovedList(plantingId: plantingId),
          ],
        ),
      ),
    );
  }
}

class ReceiptApprovedList extends StatelessWidget {
  final String plantingId;
  const ReceiptApprovedList({
    super.key,
    required this.plantingId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: getAllApprovedReceipts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while data is being fetched
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle errors during data fetching
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Handle case when no data is returned
          return const Center(child: Text('No approved receipts found.'));
        } else {
          // Data successfully fetched, build the list
          final receipts = snapshot.data!;

          return ListView.builder(
            itemCount: receipts.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.network(
                      receipts[index]['imageURL'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text('Receipt #${receipts[index].id}'),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<List<QueryDocumentSnapshot>> getAllApprovedReceipts() async {
    References r = References();
    String? id = await r.getLoggedUserId();

    // List to store all approved receipts
    List<QueryDocumentSnapshot> allApprovedReceipts = [];

    // Fetch all crops for the given user
    QuerySnapshot cropsSnapshot = await r.usersRef.doc(id).collection("crops").get();

    // Iterate through each crop to find the correct planting
    for (var cropDoc in cropsSnapshot.docs) {
      // Fetch the plantings subcollection under each crop
      QuerySnapshot plantingsSnapshot = await r.usersRef
          .doc(id)
          .collection("crops")
          .doc(cropDoc.id)
          .collection("plantings")
          .where(FieldPath.documentId, isEqualTo: plantingId)
          .get();

      // If the planting is found under this crop
      if (plantingsSnapshot.docs.isNotEmpty) {
        // Get the "approvedReceipts" subcollection for the matching planting document
        QuerySnapshot approvedReceiptsSnapshot = await r.usersRef
            .doc(id)
            .collection("crops")
            .doc(cropDoc.id)
            .collection("plantings")
            .doc(plantingId)
            .collection("approvedReceipts")
            .get();

        // Add all approved receipts to the list
        allApprovedReceipts.addAll(approvedReceiptsSnapshot.docs);
        break; // Exit the loop since we found the planting
      }
    }

    return allApprovedReceipts;
  }
}

class ReceiptRejectedList extends StatelessWidget {
  final String plantingId;
  const ReceiptRejectedList({
    super.key,
    required this.plantingId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: getAllRejectedReceipts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while data is being fetched
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle errors during data fetching
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Handle case when no data is returned
          return const Center(child: Text('No rejected receipts found.'));
        } else {
          // Data successfully fetched, build the list
          final receipts = snapshot.data!;

          return ListView.builder(
            itemCount: receipts.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.network(
                      receipts[index]['imageURL'],
                      fit: BoxFit.cover,
                      // width: 50,
                      // height: 50,
                    ),
                  ),
                  title: Text('Receipt # ${receipts[index].id}'),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<List<QueryDocumentSnapshot>> getAllRejectedReceipts() async {
    References r = References();
    String? id = await r.getLoggedUserId();

    // List to store all approved receipts
    List<QueryDocumentSnapshot> allApprovedReceipts = [];

    // Fetch all crops for the given user
    QuerySnapshot cropsSnapshot =
        await r.usersRef.doc(id).collection("crops").get();

    // Iterate through each crop to find the correct planting
    for (var cropDoc in cropsSnapshot.docs) {
      // Fetch the plantings subcollection under each crop
      QuerySnapshot plantingsSnapshot = await r.usersRef
          .doc(id)
          .collection("crops")
          .doc(cropDoc.id)
          .collection("plantings")
          .where(FieldPath.documentId, isEqualTo: plantingId)
          .get();

      // If the planting is found under this crop
      if (plantingsSnapshot.docs.isNotEmpty) {
        // Get the "approvedReceipts" subcollection for the matching planting document
        QuerySnapshot approvedReceiptsSnapshot = await r.usersRef
            .doc(id)
            .collection("crops")
            .doc(cropDoc.id)
            .collection("plantings")
            .doc(plantingId)
            .collection("rejectedReceipts")
            .get();

        // Add all approved receipts to the list
        allApprovedReceipts.addAll(approvedReceiptsSnapshot.docs);
        break; // Exit the loop since we found the planting
      }
    }

    return allApprovedReceipts;
  }
}

class ReceiptUnApprovedList extends StatelessWidget {
  final String plantingId;
  const ReceiptUnApprovedList({
    super.key,
    required this.plantingId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: getAllReceiptsForSpecificPlanting(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while data is being fetched
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle errors during data fetching
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Handle case when no data is returned
          return const Center(child: Text('No unapproved receipts found.'));
        } else {
          // Data successfully fetched, build the list
          final receipts = snapshot.data!;

          return ListView.builder(
            itemCount: receipts.length,
            itemBuilder: (context, index) {
              final receiptData =
                  receipts[index].data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: Image.network(
                    receiptData['imageURL'] ?? 'https://via.placeholder.com/50',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text('Receipt #${receipts[index].id}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.done),
                        onPressed: () {
                          // Handle approve action
                          addApprovedData(receipts[index].id, receiptData['imageURL'], receiptData['date']);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          // Handle reject action
                          addRejectedData(receipts[index].id, receiptData['imageURL'], receiptData['date']);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  addApprovedData(String receiptId, String imageURL, String date) async {
    References r = References();
    String? id = await r.getLoggedUserId();

    Receipt rec = Receipt(imageURL: imageURL, date: date);

    try {
      // Fetch all crops for the given user
      QuerySnapshot cropsSnapshot =
      await r.usersRef.doc(id).collection("crops").get();

      // Iterate through each crop to find the correct planting
      for (var cropDoc in cropsSnapshot.docs) {
        // Fetch the plantings subcollection under each crop
        QuerySnapshot plantingsSnapshot = await r.usersRef
            .doc(id)
            .collection("crops")
            .doc(cropDoc.id)
            .collection("plantings")
            .where(FieldPath.documentId, isEqualTo: plantingId)
            .get();

        // If the planting is found under this crop
        if (plantingsSnapshot.docs.isNotEmpty) {
          String? farmerId = await findFarmerIdByCropPlantingId(plantingId);

          try {
            await r.usersRef.doc(id).collection("farmers").doc(farmerId).collection("receipts").doc(receiptId).delete();
          } catch (e) {
            print("Failed to delete receipt from user path: $e");
          }

          try {
            await FirebaseFirestore.instance.collection('farmers').doc(farmerId).collection("receipts").doc(receiptId).delete();
          } catch (e) {
            print("Failed to delete receipt from global path: $e");
          }

          await r.usersRef.doc(id).collection('crops').doc(cropDoc.id).collection("plantings").doc(plantingId).collection("approvedReceipts").doc(receiptId).set(
            rec.getReceiptDataMap(),
          );
          break; // Exit the loop since we found the planting
        }
      }
        print("Approved successfully.");
    } catch (e) {
      print(e);
    }
  }

  addRejectedData(String receiptId, String imageURL, String date) async {
    References r = References();
    String? id = await r.getLoggedUserId();

    Receipt rec = Receipt(imageURL: imageURL, date: date);

    try {
      // Fetch all crops for the given user
      QuerySnapshot cropsSnapshot =
      await r.usersRef.doc(id).collection("crops").get();

      // Iterate through each crop to find the correct planting
      for (var cropDoc in cropsSnapshot.docs) {
        // Fetch the plantings subcollection under each crop
        QuerySnapshot plantingsSnapshot = await r.usersRef
            .doc(id)
            .collection("crops")
            .doc(cropDoc.id)
            .collection("plantings")
            .where(FieldPath.documentId, isEqualTo: plantingId)
            .get();

        // If the planting is found under this crop
        if (plantingsSnapshot.docs.isNotEmpty) {
          String? farmerId = await findFarmerIdByCropPlantingId(plantingId);

          try {
            await r.usersRef.doc(id).collection("farmers").doc(farmerId).collection("receipts").doc(receiptId).delete();
          } catch (e) {
            print("Failed to delete receipt from user path: $e");
          }

          try {
            await FirebaseFirestore.instance.collection('farmers').doc(farmerId).collection("receipts").doc(receiptId).delete();
          } catch (e) {
            print("Failed to delete receipt from global path: $e");
          }

          await r.usersRef.doc(id).collection('crops').doc(cropDoc.id).collection("plantings").doc(plantingId).collection("rejectedReceipts").doc(receiptId).set(
            rec.getReceiptDataMap(),
          );
          break; // Exit the loop since we found the planting
        }
      }
        print("Rejected successfully.");
    } catch (e) {
      print(e);
    }
  }

  Future<String?> findFarmerIdByCropPlantingId(String plantingId) async {
    References r = References();
    String? userId = await r.getLoggedUserId();

    // Fetch all farmers for the given user
    QuerySnapshot farmersSnapshot = await r.usersRef.doc(userId).collection("farmers").get();

    // Iterate through each farmer to find the correct cropPlantingId
    for (var farmerDoc in farmersSnapshot.docs) {
      // Check if the farmer's cropPlantingId matches the given plantingId
      if (farmerDoc.get('cropPlantingId') == plantingId) {
        return farmerDoc.id; // Return the farmerId if found
      }
    }

    return null; // Return null if no match is found
  }


  Future<List<QueryDocumentSnapshot>>
      getAllReceiptsForSpecificPlanting() async {
    References r = References();
    String? id = await r.getLoggedUserId();

    // Get the specific farmer document where the cropPlantingId matches the provided plantingId
    QuerySnapshot farmersSnapshot = await r.usersRef
        .doc(id)
        .collection("farmers")
        .where("cropPlantingId", isEqualTo: plantingId)
        .get();

    // List to store all receipts
    List<QueryDocumentSnapshot> allReceipts = [];

    // Check if we found a matching farmer document
    if (farmersSnapshot.docs.isNotEmpty) {
      // Loop through each farmer document (although there should only be one if plantingId is unique)
      for (var farmerDoc in farmersSnapshot.docs) {
        // Fetch the "receipts" subcollection for the matching farmer document
        QuerySnapshot receiptsSnapshot = await r.usersRef
            .doc(id)
            .collection("farmers")
            .doc(farmerDoc.id)
            .collection("receipts")
            .get();

        // Add all receipts to the list
        allReceipts.addAll(receiptsSnapshot.docs);
      }
    }

    return allReceipts;
  }
}
