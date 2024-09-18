import 'dart:io';
import 'package:flutter/material.dart';

class ViewImageScreen extends StatelessWidget {
  final String imageFile;
  final String type;

  const ViewImageScreen({super.key, required this.imageFile, required this.type});

  @override
  Widget build(BuildContext context) {
    bool isNetworkImage = imageFile.startsWith('http') || imageFile.startsWith('https');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        elevation: 0,
        title: Text("View $type Image"),
      ),
      body: Center(
        child: isNetworkImage
            ? Image.network(imageFile) // For network image
            : Image.file(File(imageFile)), // For local file image
      ),
    );
  }
}
