import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intellifarm/providers/crop_provider.dart';
import '../../../providers/search_provider.dart';
import '../../../widgets/list_details_card_crop.dart';
import 'add_crop_record.dart';
import 'view_crop_details.dart';

class CropList extends StatelessWidget {
  CropList({super.key});

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
            const IconButton(
              onPressed: null,
              icon: Icon(Icons.print),
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
                  : const Text("Crop List");
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Consumer<CropProvider>(
            builder: (context, cropProvider, _) {
              if (cropProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (cropProvider.errorMessage.isNotEmpty) {
                return Center(child: Text("Error is: ${cropProvider.errorMessage}"));
              } else {
                var documents = cropProvider.crops
                    .where((doc) => (doc.data() as Map<String, dynamic>)['name']
                    .toString()
                    .toLowerCase()
                    .contains(Provider.of<SearchProvider>(context).searchQuery.toLowerCase()))
                    .toList();
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var data = documents[index].data() as Map<String, dynamic>;
                    return ListDetailsCardCrop(
                      dataMap: {
                        "Name:": data['name'].toString().split(".").last,
                        "Harvest Unit:": data['harvestUnit'].toString().split(".").last,
                        "Varieties:": cropProvider.varietiesCountList[index].toString(),
                        "Plantings:": cropProvider.plantingsCountList[index].toString(),
                        "Notes:": data['notes'].toString(),
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewCropDetails(
                              dataMap: {
                                "Name:": data['name'].toString(),
                                "Harvest Unit:": data['harvestUnit'].toString(),
                                "Varieties:": cropProvider.varietiesCountList[index].toString(),
                                "Plantings:": cropProvider.plantingsCountList[index].toString(),
                                "Notes:": data['notes'].toString(),
                              },
                            ),
                          ),
                        );
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
                builder: (context) => AddCropRecord(),
              ),
            ).then((_) {
              Provider.of<CropProvider>(context, listen: false).needsRefresh = true;
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