// lib/screens/farmers_crops_fields_screens/farmer_screens/farmer_list.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intellifarm/providers/farmer_provider.dart';
import '../../../providers/search_provider.dart';
import '../../../widgets/list_details_card_farmer.dart';
import 'add_farmer_record.dart';
import 'farmers_report_pdf.dart';

class FarmerList extends StatelessWidget {
  FarmerList({super.key});

  List<DocumentSnapshot> reportData = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          actions: [
            Consumer<SearchProvider>(
              builder: (context, searchProvider, _) => IconButton(
                onPressed: () {
                  searchProvider.toggleSearch();
                },
                icon: Icon(searchProvider.searchFlag ? Icons.close : Icons.search),
              ),
            ),
            IconButton(
              onPressed: () async{
                final FarmersReportPdf reportGenerator = FarmersReportPdf();
                final pdfBytes = await reportGenerator.generateReport(reportData);
                final path = await reportGenerator.savePdf(pdfBytes, 'farmers_report');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('PDF saved at $path')),
                );
              },
              icon: const Icon(Icons.print),
            ),
          ],
          title: Consumer<SearchProvider>(
            builder: (context, searchProvider, _) {
              return searchProvider.searchFlag
                  ? Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      searchProvider.updateSearchQuery(value);
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchProvider.clearSearch();
                          _searchController.clear();
                        },
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              )
                  : const Text("Farmer List");
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Consumer<FarmerProvider>(
            builder: (context, farmerProvider, _) {
              if (farmerProvider.needsRefresh) {
                farmerProvider.fetchFarmersData();
              }
              if (farmerProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (farmerProvider.errorMessage.isNotEmpty) {
                return Center(child: Text("Error is: ${farmerProvider.errorMessage}"));
              } else {
                var documents = farmerProvider.farmers
                    .where((doc) => (doc.data() as Map<String, dynamic>)['name']
                    .toString()
                    .toLowerCase()
                    .contains(Provider.of<SearchProvider>(context).searchQuery.toLowerCase()))
                    .toList();
                reportData = documents;
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var data = documents[index].data() as Map<String, dynamic>;
                    var id = documents[index].id;
                    return ListDetailsCardFarmer(
                      farmerId: id,
                      dataMap: {
                        "Name:": data['name'].toString(),
                        "Phone Number:": data['phoneNumber'].toString(),
                        "C-NIC Number:": data['cnic'].toString(),
                        "Unique Code:": data['loginCode'].toString(),
                        "Share Rule:": data['shareRule'].toString().split(".").last,
                        "Crop Planting Id:": data['cropPlantingId'],
                      },
                      onTap: () {
                        // Logic which might not needed
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddFarmerRecord(),
              ),
            ).then((_) {
              Provider.of<FarmerProvider>(context, listen: false).needsRefresh = true;
            });
          },
          icon: const Icon(Icons.add),
          label: const Text('Add'),
          tooltip: 'Add',
        ),
      ),
    );
  }
}