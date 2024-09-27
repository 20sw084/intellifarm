import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/models/fields/field.dart';
import '../controller/references.dart';
import '../screens/farmers_crops_fields_screens/field_screens/add_field_planting.dart';
import '../screens/farmers_crops_fields_screens/field_screens/edit_field_record.dart';
import '../screens/farmers_crops_fields_screens/field_screens/view_field_details.dart';
import '../util/common_methods.dart';
import 'confirm_delete_field_dialog.dart';

class ListDetailsCardField extends StatelessWidget {
  final Map<String, dynamic> dataMap;
  final dynamic onTap;

  const ListDetailsCardField({
    super.key,
    required this.dataMap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Field fieldObject = Field(
      name: dataMap["Name:"],
      fieldType: fieldTypeFromString(dataMap["Field Type:"]),
      lightProfile: lightProfileFromString(dataMap["Light Profile:"]),
      fieldStatus: fieldStatusFromString(dataMap["Field Status:"]),
      sizeOfField: int.tryParse(dataMap["Size of Field:"]),
      notes: dataMap["Notes:"],
    );
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
                    children: const [
                      Text(
                        "Name:",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "Type:",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "Size:",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "Plantings:",
                        style: TextStyle(
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
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        dataMap["Field Type:"],
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        dataMap["Size of Field:"],
                        style: const TextStyle(
                          fontSize: 13,
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
                              child: Text('View Details'),
                            ),
                            const PopupMenuItem(
                              value: 2,
                              child: Text('Edit Record'),
                            ),
                            const PopupMenuItem(
                              value: 3,
                              child: Text('Add Planting'),
                            ),
                            const PopupMenuItem(
                              value: 4,
                              child: Text('Print PDF'),
                            ),
                            const PopupMenuItem(
                              value: 5,
                              child: Text('Delete'),
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
                                  builder: (context) => ViewFieldDetails(
                                    dataMap: dataMap,
                                  ),
                                ),
                              );
                              break;
                            case 2:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditFieldRecord(
                                    field: fieldObject,
                                  ),
                                ),
                              );
                              break;
                            case 3:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddFieldPlanting(
                                    fieldName: dataMap["Name:"],
                                  ),
                                ),
                              );
                              break;
                            case 4:
                              print('Option 5 selected');
                              break;
                            case 5:
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmDeleteFieldDialog(
                                    onConfirm: () async {
                                      try {
                                        References r = References();
                                        r.deleteCropDocument(
                                            "fields", dataMap["Name:"]);
                                      } catch (e) {
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
