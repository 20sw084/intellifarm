import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/references.dart';
import '../providers/crop_provider.dart';
import '../screens/activities_screens/plantings/add_planting.dart';
import '../screens/farmers_crops_fields_screens/crop_screens/add_crop_variety.dart';
import '../screens/farmers_crops_fields_screens/crop_screens/edit_crop_record.dart';
import '../screens/farmers_crops_fields_screens/crop_screens/view_crop_details.dart';
import '../util/units_enum.dart';
import 'confirm_delete_crop_dialog.dart';

class ListDetailsCardCrop extends StatelessWidget {
  final Map<String, dynamic> dataMap;
  final dynamic onTap;

  const ListDetailsCardCrop({
    super.key,
    required this.dataMap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 110,
        child: GestureDetector(
          onTap: onTap,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        "Name:",
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "Harvest Unit:",
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "Varieties:",
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "Plantings:",
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        dataMap["Name:"],
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        dataMap["Harvest Unit:"],
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        dataMap["Varieties:"],
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        dataMap["Plantings:"],
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () {
                        showMenu(
                          context: context,
                          position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                          items: [
                            const PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(Icons.remove_red_eye, color: Colors.amber,),
                                  SizedBox(width: 10.0,),
                                  Text('View Details'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 2,
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.amber,),
                                  SizedBox(width: 10.0,),
                                  Text('Edit Record'),
                                ],
                              ),
                            ),
                            // (keys?.elementAt(1) == "Type:")?
                            const PopupMenuItem(
                              value: 3,
                              child: Row(
                                children: [
                                  Icon(Icons.add_box, color: Colors.amber,),
                                  SizedBox(width: 10.0,),
                                  Text('Add Variety'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 4,
                              child: Row(
                                children: [
                                  Icon(Icons.add_box, color: Colors.amber,),
                                  SizedBox(width: 10.0,),
                                  Text('Add Planting'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 5,
                              child: Row(
                                children: [
                                  Icon(Icons.print, color: Colors.amber,),
                                  SizedBox(width: 10.0,),
                                  Text('Print PDF'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 6,
                              child: Row(
                                children: [
                                  Icon(Icons.delete_forever_rounded, color: Colors.red,),
                                  SizedBox(width: 10.0,),
                                  Text('Delete Crop'),
                                ],
                              ),
                            ),
                          ],
                          // Handle the selected menu item
                          elevation: 8.0,
                        ).then((value) {
                          // Handle the selected value
                          switch (value) {
                            case 1:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewCropDetails(
                                    dataMap: dataMap,
                                  ),
                                ),
                              );
                              break;
                            case 2:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditCropRecord(
                                      dataMap: dataMap,
                                    ),
                                  ));
                              break;
                            case 3:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddCropVariety(
                                    cropName: dataMap["Name:"],
                                  ),
                                ),
                              ).then((_) {
                                Provider.of<CropProvider>(
                                  context,
                                  listen: false,
                                ).needsRefresh = true;
                              });
                              break;
                            case 4:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddPlanting(
                                    cropName: dataMap["Name:"],
                                  ),
                                ),
                              ).then((_) {

                                Provider.of<CropProvider>(
                                  context,
                                  listen: false,
                                ).needsRefresh = true;
                              });
                              break;
                            case 5:
                              print('Option 5 selected');
                              break;
                            case 6:
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmDeleteCropDialog(
                                    onConfirm: () async {
                                      await _deleteCrop(context, dataMap["Name:"]);
                                    },
                                  );
                                },
                              );
                              break;
                          }
                        });
                      },
                      icon: const Icon(Icons.more_vert),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _deleteCrop(BuildContext context, String cropName) async {
    try {
      final cropProvider = Provider.of<CropProvider>(context, listen: false);
      await cropProvider.deleteCrop("CropType.$cropName");
      cropProvider.needsRefresh = true;
    } catch (e) {
      print('Error deleting field: $e');
    }
  }
}
