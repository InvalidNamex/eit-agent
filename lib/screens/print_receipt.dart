import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<pw.Font> getArabicFont() async {
  final fontData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
  return pw.Font.ttf(fontData);
}

Future<void> generateReceiptPdf(
    {required String agent,
    required String customerName,
    required double amount}) async {
  final doc = pw.Document();
  final arabicFont = await getArabicFont();
  final date = DateFormat('dd/MM/yyyy').format(DateTime.now());

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Container(
            decoration:
                pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Container(
                  alignment: pw.Alignment.center,
                  padding: const pw.EdgeInsets.all(8),
                  color: PdfColors.black,
                  child: pw.Text(
                    'إيصال استلام نقدية',
                    textDirection: pw.TextDirection.rtl,
                    style: pw.TextStyle(
                      fontSize: 18,
                      font: arabicFont,
                      color: PdfColors.white,
                    ),
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'المندوب: $agent',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(font: arabicFont),
                        ),
                        pw.Text(
                          'التاريخ: $date',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(font: arabicFont),
                        ),
                      ],
                    )),
                pw.SizedBox(height: 16),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          color: PdfColors.black,
                          child: pw.Text(
                            'البيــان',
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                              fontSize: 12,
                              font: arabicFont,
                              color: PdfColors.white,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          color: PdfColors.black,
                          child: pw.Text(
                            'العميل',
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                              fontSize: 12,
                              font: arabicFont,
                              color: PdfColors.white,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          color: PdfColors.black,
                          child: pw.Text(
                            'المبلغ',
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                              fontSize: 12,
                              font: arabicFont,
                              color: PdfColors.white,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'تلقيت المبلغ',
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(font: arabicFont),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            customerName,
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(font: arabicFont),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            amount.toStringAsFixed(2),
                            style: pw.TextStyle(font: arabicFont),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ));
      },
    ),
  );

  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save());
}
