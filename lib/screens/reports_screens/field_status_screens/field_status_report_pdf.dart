import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart';

class FieldStatusReportPdf {
  Future<Uint8List> generateReport(List<DocumentSnapshot> plantings) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Crop Planting Report',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('Generated on: ${DateTime.now()}'),
              pw.SizedBox(height: 16),
              TableHelper.fromTextArray(
                headers: [
                  'Field',
                  'Crop',
                  'Variety',
                  'Planting Date',
                  'Estimated Yield',
                  "Planting Type",
                  "Quantity Planted",
                  "Distance Between Plants",
                  // "First Harvest Date",
                  // "Seed Company",
                  // "Seed Lot Number",
                  // "Seed Origin",
                  // "Seed Type",
                  // "Notes",
                ],
                data: plantings.map((plantingDoc) {
                  var plantingData = plantingDoc.data() as Map<String, dynamic>;
                  return [
                    plantingData['fieldName'] ?? 'N/A',
                    plantingData['cropName'] ?? 'N/A',
                    plantingData['varietyName'] ?? 'N/A',
                    plantingData['plantingDate'] ?? 'N/A',
                    plantingData['estimatedYield']?.toString() ?? 'N/A',
                    plantingData['plantingType']?.toString() ?? 'N/A',
                    plantingData['quantityPlanted']?.toString() ?? 'N/A',
                    plantingData['distanceBetweenPlants']?.toString() ?? 'N/A',
                    // plantingData['firstHarvestDate']?.toString() ?? 'N/A',
                    // plantingData['seedCompany']?.toString() ?? 'N/A',
                    // plantingData['seedLotNumber']?.toString() ?? 'N/A',
                    // plantingData['seedOrigin']?.toString() ?? 'N/A',
                    // plantingData['seedType']?.toString() ?? 'N/A',
                    // plantingData['notes']?.toString() ?? 'N/A',
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 16),
              pw.Text('Notes:',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text(
                  'This report contains data of recent crop plantings and their estimated yields.'),
            ],
          );
        },
      ),
    );

    return pdf.save(); // Returns PDF file as bytes
  }

  Future<String> savePdf(Uint8List pdfBytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName.pdf';
    final file = File(path);
    await file.writeAsBytes(pdfBytes);

    return path;
  }
}
