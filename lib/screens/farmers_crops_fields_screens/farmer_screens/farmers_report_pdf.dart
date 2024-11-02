import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class FarmersReportPdf {
  Future<void> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      // The permission is granted
      print("Permission Granted!");
    } else {
      // The permission is denied
      print("Permission Denied!");
    }
  }

  Future<Uint8List> generateReport(List<DocumentSnapshot> farmers) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Farmers Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('Generated on: ${DateTime.now()}'),
              pw.SizedBox(height: 16),
              TableHelper.fromTextArray(
                headers: ['Farmer Name', 'Phone Number', 'CNIC Number', 'Unique Code', 'Share Rule', 'Linked Planting Id',],
                data: farmers.map((farmerDoc) {
                  var farmerData = farmerDoc.data() as Map<String, dynamic>;
                  return [
                    farmerData['name'] ?? 'N/A',
                    farmerData['phoneNumber'] ?? 'N/A',
                    farmerData['cnic'] ?? 'N/A',
                    farmerData['loginCode'] ?? 'N/A',
                    farmerData['shareRule'] ?? 'N/A',
                    farmerData['cropPlantingId'] ?? 'N/A',
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 16),
              pw.Text('Notes:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('This report contains data of all the farmers against a specific land owner.'),
            ],
          );
        },
      ),
    );

    return pdf.save(); // Returns PDF file as bytes
  }

  Future<String> savePdf(Uint8List pdfBytes, String fileName) async {
    // Request storage permission
    await requestStoragePermission();

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName.pdf';
    final file = File(path);
    await file.writeAsBytes(pdfBytes);

    return path;
  }
}