import 'package:eit/controllers/customer_controller.dart'; // Import your customer controller
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<pw.Font> getArabicFont() async {
  final fontData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
  return pw.Font.ttf(fontData);
}

Future<void> generateCustomersReportPdf(CustomerController controller) async {
  final doc = pw.Document();
  final headers = ['Name'.tr, 'Phone'.tr];
  final arabicFont = await getArabicFont();

  final data = controller.customersList.map((customer) {
    return [customer.custName?.trim() ?? '', customer.phone?.trim() ?? ''];
  }).toList();

  doc.addPage(
    pw.MultiPage(
      textDirection: pw.TextDirection.rtl,
      build: (context) => [
        pw.TableHelper.fromTextArray(
          headers: headers,
          headerAlignment: pw.Alignment.center,
          data: data,
          border: pw.TableBorder.all(),
          headerStyle:
              pw.TextStyle(fontWeight: pw.FontWeight.bold, font: arabicFont),
          cellStyle: pw.TextStyle(font: arabicFont),
          cellHeight: 30,
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
          cellAlignments: {
            0: pw.Alignment.centerRight,
            1: pw.Alignment.centerRight,
          },
        ),
      ],
      header: (context) {
        return pw.Header(
            level: 0,
            child: pw.Text('Customer Report'.tr,
                style: pw.TextStyle(fontSize: 18, font: arabicFont)));
      },
      footer: (context) {
        final pagesCount = context.pagesCount;
        return pw.Footer(
          title: pw.Text('Page ${context.pageNumber} of $pagesCount',
              style: pw.TextStyle(font: arabicFont)),
        );
      },
    ),
  );
  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save());
}
