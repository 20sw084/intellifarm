import 'package:flutter/material.dart';
import 'package:intellifarm/screens/miscellaneous_screens/expense_categories/expense_categories_screen.dart';
import 'package:intellifarm/screens/miscellaneous_screens/income_categories/income_categories_screen.dart';
import '../../widgets/card_widget.dart';

class MiscellaneousScreen extends StatelessWidget{
  const MiscellaneousScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          title: Text("Miscellaneous"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CardWidget(
                      width: 140,
                      height: 180,
                      text: "Income Categories",
                      logo: Icons.attach_money,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IncomeCategoriesScreen(),
                            ));
                      },
                    ),
                    CardWidget(
                      width: 140,
                      height: 180,
                      text: "Expense Categories",
                      logo: Icons.attach_money,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExpenseCategoriesScreen(),
                            ));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
