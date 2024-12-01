import 'package:eit/constants.dart';
import 'package:eit/models/api/api_sales_analysis_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SalesAnalysisTable extends GetView {
  final List<SalesAnalysisModel> data;

  const SalesAnalysisTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all<Color>(accentColor),
          border: TableBorder.all(color: accentColor),
          columns: [
            DataColumn(
                label: Text(
              'Serial'.tr,
              style: const TextStyle(color: lightColor),
            )),
            DataColumn(
                label: Text('Invoice Date'.tr,
                    style: const TextStyle(color: lightColor))),
            DataColumn(
                label: Text('Item Discount'.tr,
                    style: const TextStyle(color: lightColor))),
            DataColumn(
                label:
                    Text('VAT'.tr, style: const TextStyle(color: lightColor))),
            DataColumn(
                label: Text('Net Total'.tr,
                    style: const TextStyle(color: lightColor))),
            DataColumn(
              label: Expanded(
                child: Text('Customer Name'.tr,
                    style: const TextStyle(color: lightColor)),
              ),
            ),
            DataColumn(
                label: Text('Invoice Type'.tr,
                    style: const TextStyle(color: lightColor))),
          ],
          rows: data.map((item) {
            return DataRow(cells: [
              DataCell(Text((data.indexOf(item) + 1).toString())),
              DataCell(Text(dateConversion(item.invDate?.toString() ?? ''))),
              DataCell(Text(item.itemDiscount?.toString() ?? '')),
              DataCell(Text(item.vat?.toString() ?? '')),
              DataCell(Text(item.netTotal?.toString() ?? '')),
              DataCell(Text(item.custName ?? '')),
              DataCell(Text(item.invTypeName ?? '')),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}

String dateConversion(dateTimeString) {
  final dateTime = DateTime.parse(dateTimeString);
  final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  return formattedDate;
}
