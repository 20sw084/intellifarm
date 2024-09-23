import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class TransactionsReportPdf {
  Future<Uint8List> generateReport(List<Map<String, dynamic>> reportData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Transactions Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('Generated on: ${DateTime.now()}'),
              pw.SizedBox(height: 16),
              TableHelper.fromTextArray(
                headers: ['Income', 'Expense'],
                data: reportData.map((item) {
                  return [
                    item['Income'],
                    item['Expense'],
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 16),
              pw.Text('Notes:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('This report contains details about the recent crop plantings and harvests.'),
            ],
          );
        },
      ),
    );

    return pdf.save(); // Returns PDF file as bytes
  }

  Future<String> savePdf(Uint8List pdfBytes, String fileName) async {
    // Get the device's document directory
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName.pdf';

    // Save the PDF file
    final file = File(path);
    await file.writeAsBytes(pdfBytes);

    return path; // Return the saved file path
  }
}
