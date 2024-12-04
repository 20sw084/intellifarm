import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intellifarm/models/receipt.dart';
import 'dart:io';
import '../controller/references.dart';
import '../widgets/card_widget.dart';
import 'package:intellifarm/util/common_methods.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key, }); // Initialize it in the constructor

  @override
  FarmerDashboardState createState() => FarmerDashboardState();
}

class FarmerDashboardState extends State<FarmerDashboard> {
  File? _selectedReceipt;
  String? type;

  Future<void> _pickReceipt(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedReceipt = File(pickedFile.path);
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewImageScreen(
            imageFile: _selectedReceipt!,
            type: type ?? '', // Pass the type variable
          ),
        ),
      );
    } else {
      print('No image selected.');
    }
  }

  Future<void> _pickStatus() async {
    type = "Status";
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedReceipt = File(pickedFile.path);
      });

      // Ensure the type is not null and pass it to the ViewImageScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewImageScreen(
            imageFile: _selectedReceipt!,
            type: type ?? '', // Pass the type variable
          ),
        ),
      );
    } else {
      print('No image selected.');
    }
  }

  void _showPickerDialog() {
    type = "Receipt";
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pick from Gallery'),
                onTap: () {
                  _pickReceipt(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Capture with Camera'),
                onTap: () {
                  _pickReceipt(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Color(0xff727530),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu),
            ),
          ),
          title: Text("Farmer Dashboard"),
        ),
        drawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 5.0,
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 80,
                  backgroundColor: Color(0xff727530),
                  child: CircleAvatar(
                    radius: 75,
                    backgroundImage: NetworkImage(
                        "https://avatars.githubusercontent.com/u/83652548?v=4"),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.edit, color: Color(0xff727530)),
                  title: Text('Edit Profile'),
                  onTap: () {
                    print('Edit Profile clicked');
                  },
                ),
                Spacer(),
                ListTile(
                  leading: Icon(Icons.logout, color: Color(0xff727530)),
                  title: Text('Logout'),
                  onTap: () {
                    logout(context);
                  },
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CardWidget(
                      width: 170,
                      height: 180,
                      text: "Give Status",
                      logo: Icons.signal_wifi_statusbar_4_bar,
                      onTap: _pickStatus,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CardWidget(
                      width: 170,
                      height: 180,
                      text: "Upload Receipt",
                      logo: Icons.upload,
                      onTap: _showPickerDialog,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Add your onPressed action here
            print('Button pressed!');
          },
          backgroundColor: Color(0xff727530),
          foregroundColor: Colors.white,
          icon: Icon(Icons.refresh),
          label: Text('Sync Data'),
          tooltip: 'Sync Data', // Tooltip text
        ),
      ),

    );
  }
}

class ViewImageScreen extends StatelessWidget {
  final File imageFile;
  final String type;

  const ViewImageScreen({super.key, required this.imageFile, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff727530),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text("View $type Image"),
        actions: [
          IconButton(
            icon: Icon(Icons.done, color: Colors.white, size: 30),
            onPressed: () async {
              // Call saveImage with context and type
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
              await _saveImage(context, type);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Image.file(imageFile),
      ),
    );
  }

  Future<void> _saveImage(BuildContext context, String type) async {
    References r = References();
    String? farmerId = await r.getLoggedUserId();
    String? ownerId = await r.getSecondaryUserId();

    try {
      if (farmerId != null) {
        // Step 1: Upload the image to Firebase Storage
        String imageId = generateRandomDocId(); // Generate or use a consistent ID for the farmer

        if (type == "Receipt") {
          String storagePath = 'receipts/$farmerId/$imageId.png'; // Define storage path
          final ref = FirebaseStorage.instance.ref().child(storagePath);
          UploadTask uploadTask = ref.putFile(imageFile);
          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();
          Receipt rec = Receipt(imageURL: downloadUrl, date: DateTime.now().toString());

          await r.usersRef
              .doc(ownerId)
              .collection('farmers')
              .doc(farmerId)
              .collection("receipts")
              .doc(imageId)
              .set(rec.getReceiptDataMap());

          await FirebaseFirestore.instance
              .collection('farmers')
              .doc(farmerId)
              .collection("receipts")
              .doc(imageId)
              .set(rec.getReceiptDataMap());

          print("Receipt Uploaded Successfully.");
        } else if (type == "Status") {
          String storagePath = 'status/$farmerId/$imageId.png'; // Define storage path
          final ref = FirebaseStorage.instance.ref().child(storagePath);
          UploadTask uploadTask = ref.putFile(imageFile);
          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();

          await r.usersRef
              .doc(ownerId)
              .collection('farmers')
              .doc(farmerId)
              .collection("status")
              .doc(imageId)
              .set({"statusLink": downloadUrl, "date": DateTime.now(),});

          await FirebaseFirestore.instance
              .collection('farmers')
              .doc(farmerId)
              .collection("status")
              .doc(imageId)
              .set({"statusLink": downloadUrl, "date": DateTime.now(),});

          print("Status Uploaded Successfully.");
        } else {
          print("Some error.");
        }

        Navigator.pop(context); // Close the form
      } else {
        print("Error: User ID is null");
        Navigator.pop(context); // Close the loading dialog
      }
    } catch (e) {
      print(e);
      Navigator.pop(context); // Close the loading dialog
    }
  }
}
