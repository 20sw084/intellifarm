import 'package:flutter/material.dart';

import '../../widgets/card_widget.dart';
import 'crop_screens/crop_list.dart';
import 'farmer_screens/farmer_list.dart';
import 'field_screens/field_list.dart';

class FarmerCropsAndFields extends StatelessWidget {
  const FarmerCropsAndFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff727530),
        foregroundColor: Colors.white,
        title: Text("Farmers, Crops & Fields"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CardWidget(
                    width: 140,
                    height: 180,
                    text: "Farmers",
                    logo: Icons.supervised_user_circle,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FarmerList(),));
                    },
                  ),
                  CardWidget(
                    width: 140,
                    height: 180,
                    text: "Crops",
                    logo: Icons.rice_bowl,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CropList(),));
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: CardWidget(
                width: 140,
                height: 180,
                text: "Fields",
                logo: Icons.agriculture,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FieldList(),));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
