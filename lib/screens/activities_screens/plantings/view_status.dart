import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/screens/activities_screens/plantings/view_image_screen.dart';
import '../../../controller/references.dart';

class ViewStatus extends StatelessWidget {
  final String plantingId;
  const ViewStatus({
    super.key,
    required this.plantingId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text('View Status\''),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: getAllStatusForSpecificPlanting(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while data is being fetched
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle errors during data fetching
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Handle case when no data is returned
            return const Center(child: Text('No status\' found.'));
          } else {
            // Data successfully fetched, build the list
            final status = snapshot.data!;

            return ListView.builder(
              itemCount: status.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewImageScreen(
                                imageFile: status[index]['statusLink'],
                                type: 'Status', // Pass the type variable
                              ),
                            ),
                          );
                        },
                        child: Image.network(
                          status[index]['statusLink'],
                          fit: BoxFit.cover,
                          // width: 50,
                          // height: 50,
                        ),
                      ),
                    ),
                    title: Text('Status # ${status[index].id}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<QueryDocumentSnapshot>> getAllStatusForSpecificPlanting() async {
    References r = References();
    String? id = await r.getLoggedUserId();

    // Get the specific farmer document where the cropPlantingId matches the provided plantingId
    QuerySnapshot farmersSnapshot = await r.usersRef
        .doc(id)
        .collection("farmers")
        .where("cropPlantingId", isEqualTo: plantingId)
        .get();

    // List to store all receipts
    List<QueryDocumentSnapshot> allStatus = [];

    // Check if we found a matching farmer document
    if (farmersSnapshot.docs.isNotEmpty) {
      // Loop through each farmer document (although there should only be one if plantingId is unique)
      for (var farmerDoc in farmersSnapshot.docs) {
        // Fetch the "receipts" subcollection for the matching farmer document
        QuerySnapshot receiptsSnapshot = await r.usersRef
            .doc(id)
            .collection("farmers")
            .doc(farmerDoc.id)
            .collection("status")
            .get();

        // Add all receipts to the list
        allStatus.addAll(receiptsSnapshot.docs);
      }
    }

    return allStatus;
  }
}
