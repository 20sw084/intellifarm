import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart';

class TasksReportPdf {
  Future<Uint8List> generateReport(List<DocumentSnapshot> plantings) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Tasks Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('Generated on: ${DateTime.now()}'),
              pw.SizedBox(height: 16),
              TableHelper.fromTextArray(
                headers: ['Task Date', 'Task Status', 'Task Name', 'Field Name', 'Task Specific To Planting', 'Planting Name', 'Notes'],
                data: plantings.map((plantingDoc) {
                  var plantingData = plantingDoc.data() as Map<String, dynamic>;
                  return [
                    plantingData['taskDate'] ?? 'N/A',
                    plantingData['taskStatus'] ?? 'N/A',
                    plantingData['taskName'] ?? 'N/A',
                    plantingData['fieldName'] ?? 'N/A',
                    plantingData['taskSpecificToPlanting'] ?? 'N/A',
                    plantingData['plantingName'] ?? 'N/A',
                    plantingData['notes']?.toString() ?? 'N/A',
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 16),
              pw.Text('Notes:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('This report contains data of recent crop plantings and their estimated yields.'),
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
