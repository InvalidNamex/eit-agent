import 'package:eit/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

import '../models/customer_ledger_model.dart';

class CustomTable extends StatelessWidget {
  final List<CustomerLedgerModel> list;
  const CustomTable({required this.list, super.key});

  @override
  Widget build(BuildContext context) {
    double runningTotal = 0.0;
    Widget customHeaderCell(String text) {
      return Container(
          height: 50,
          color: accentColor,
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            textAlign: TextAlign.center,
          ));
    }

    Widget customRowCell({required String text, required int index}) {
      return Container(
          alignment: Alignment.center,
          height: 70,
          color: index % 2 == 0 ? Colors.white : Colors.grey.shade200,
          child: Text(
            text,
            style:
                const TextStyle(color: darkColor, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Table(
            textDirection: TextDirection.rtl,
            defaultVerticalAlignment: TableCellVerticalAlignment.top,
            border: TableBorder.all(width: 1.0, color: darkColor),
            children: [
              TableRow(children: [
                customHeaderCell('SN'.tr),
                customHeaderCell('Date'.tr),
                customHeaderCell('DEBIT'.tr),
                customHeaderCell('CREDIT'.tr),
                customHeaderCell('Balance'.tr),
                customHeaderCell('Note'.tr),
              ]),
            ],
            columnWidths: const {
              0: FixedColumnWidth(50),
              1: FixedColumnWidth(100),
              2: FixedColumnWidth(150),
              3: FixedColumnWidth(150),
              4: FixedColumnWidth(200),
              5: FixedColumnWidth(300),
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Table(
                textDirection: TextDirection.rtl,
                defaultVerticalAlignment: TableCellVerticalAlignment.top,
                border: TableBorder.all(width: 1.0, color: darkColor),
                children: list.asMap().entries.map((customerLedger) {
                  int index = customerLedger.key;
                  CustomerLedgerModel transaction = customerLedger.value;
                  runningTotal += (transaction.eqDebit!.toDouble() -
                      transaction.eqCredit!.toDouble());
                  return TableRow(children: [
                    customRowCell(text: index.toString(), index: index),
                    customRowCell(
                        text: intl.DateFormat('yyyy-MM-dd')
                            .format(transaction.moveDate!),
                        index: index),
                    customRowCell(
                        text: transaction.eqDebit?.toStringAsFixed(2) ?? '0',
                        index: index),
                    customRowCell(
                        text: transaction.eqCredit?.toStringAsFixed(2) ?? '0',
                        index: index),
                    customRowCell(
                        text: runningTotal.toStringAsFixed(2), index: index),
                    customRowCell(
                        text: transaction.masterNote.toString(), index: index),
                  ]);
                }).toList(),
                columnWidths: const {
                  0: FixedColumnWidth(50),
                  1: FixedColumnWidth(100),
                  2: FixedColumnWidth(150),
                  3: FixedColumnWidth(150),
                  4: FixedColumnWidth(200),
                  5: FixedColumnWidth(300),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
