import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../controller/references.dart';
import '../screens/activities_screens/plantings/add_planting.dart';
import '../screens/farmers_crops_fields_screens/crop_screens/add_crop_variety.dart';
import '../screens/farmers_crops_fields_screens/crop_screens/edit_crop_record.dart';
import '../screens/farmers_crops_fields_screens/crop_screens/view_crop_details.dart';
import '../util/units_enum.dart';
import 'confirm_delete_crop_dialog.dart';

class ListDetailsCardCrop extends StatelessWidget {
  final Map<String, dynamic> dataMap;
  final dynamic onTap;

  ListDetailsCardCrop({
    super.key,
    // this.keys,
    // this.values,
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
                              child: Text('View Details'),
                              value: 1,
                            ),
                            const PopupMenuItem(
                              child: Text('Edit Record'),
                              value: 2,
                            ),
                            // (keys?.elementAt(1) == "Type:")?
                            const PopupMenuItem(
                              child: Text('Add Variety'),
                              value: 3,
                            ),
                            const PopupMenuItem(
                              child: Text('Add Planting'),
                              value: 4,
                            ),
                            const PopupMenuItem(
                              child: Text('Print PDF'),
                              value: 5,
                            ),
                            const PopupMenuItem(
                              child: Text('Delete'),
                              value: 6,
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
                                    // keys: keys, values: values,
                                    // dataMap: {
                                    //   "Name:": dataMap['name'].toString(),
                                    //   "Harvest Unit:": dataMap['harvestUnit'].toString(),
                                    //   "Varieties:": varietiesCountList[index].toString(),
                                    //   "Plantings:": plantingsCountList[index].toString(),
                                    //   "Notes:": dataMap['notes'].toString(),
                                    // },
                                  ),
                                ),
                              );
                              break;
                            case 2:
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditCropRecord(dataMap: dataMap,),));
                              break;
                            case 3:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddCropVariety(cropName: dataMap["Name:"],),
                                ),
                              );
                              break;
                            case 4:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddPlanting(cropName: dataMap["Name:"],),
                                ),
                              );
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
                                      try {
                                        References r = References();
                                        r.deleteCropDocument("crops", dataMap["Name:"],);
                                      } catch(e){
                                        if (kDebugMode) {
                                          print(e);
                                        }
                                      }
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
}
