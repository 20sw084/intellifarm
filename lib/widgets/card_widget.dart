import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  double height;
  double width;
  String text;
  IconData? logo;
  dynamic onTap;

  CardWidget({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    this.logo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: width,
        height: height,
        child: GestureDetector(
          onTap: onTap,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      logo,
                      size: 100,
                      color: Color(0xff727530),
                    ),
                    Text(
                      text,
                      style: TextStyle(
                        color: Color(0xff727530),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
