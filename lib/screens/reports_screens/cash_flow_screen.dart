import 'package:eit/custom_widgets/custom_appBar.dart';
import 'package:eit/custom_widgets/custom_drawer.dart';
import 'package:eit/helpers/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

import '../../constants.dart';
import '../../controllers/reports_controllers/cashflow_controller.dart';
import '../../custom_widgets/date_filters.dart';
import '../../models/cash_flow_model.dart';

class CashFlowScreen extends GetView<CashFlowController> {
  const CashFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getCashFlow();
    final ScrollController scrollController = ScrollController();

    void _scrollListener() {
      if (scrollController.position.extentAfter < 200) {
        if (controller.hasMoreData.value) {
          controller.getCashFlow(isLoadMore: true);
        }
      }
    }

    scrollController.addListener(_scrollListener);
    return Scaffold(
      appBar: customAppBar(text: 'Cash Flow Report'.tr),
      endDrawer: const CustomDrawer(),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child:
                        dateFromFilterMethod(controller.dateFromFilter, context,
                            optionalFunction: () async {
                      await controller.getCashFlow();
                    }),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: dateToFilterMethod(controller.dateToFilter, context,
                        optionalFunction: () async {
                      await controller.getCashFlow();
                    }),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.cashFlowList.isEmpty) {
                return Center(child: Text('No data available'.tr));
              }
              return CashFlowTable(
                  list: controller.cashFlowList,
                  scrollController: scrollController);
            }),
          ),
          Obx(() => controller.isLoading.value
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: loader(),
                )
              : Container(
                  height: 0,
                )),
        ],
      ),
    );
  }
}

class CashFlowTable extends StatelessWidget {
  final List<CashFlowModel> list;
  final ScrollController scrollController;
  const CashFlowTable({required this.list, required this.scrollController});

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
                customHeaderCell('Date'.tr),
                customHeaderCell('Notes'.tr),
                customHeaderCell('DEBIT'.tr),
                customHeaderCell('CREDIT'.tr),
                customHeaderCell('Balance'.tr),
              ]),
            ],
            columnWidths: const {
              0: FixedColumnWidth(150),
              1: FixedColumnWidth(300),
              2: FixedColumnWidth(150),
              3: FixedColumnWidth(150),
              4: FixedColumnWidth(200),
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Table(
                textDirection: TextDirection.rtl,
                defaultVerticalAlignment: TableCellVerticalAlignment.top,
                border: TableBorder.all(width: 1.0, color: darkColor),
                children: list.asMap().entries.map((cashFlow) {
                  int index = cashFlow.key;
                  CashFlowModel cashFlowModel = cashFlow.value;
                  runningTotal += (cashFlowModel.eqDebit!.toDouble() -
                      cashFlowModel.eqCredit!.toDouble());
                  return TableRow(children: [
                    customRowCell(
                        text: intl.DateFormat('yyyy-MM-dd')
                            .format(cashFlowModel.moveDate!),
                        index: index),
                    customRowCell(
                        text: cashFlowModel.masterNote.toString(),
                        index: index),
                    customRowCell(
                        text: cashFlowModel.eqDebit?.toStringAsFixed(2) ?? '0',
                        index: index),
                    customRowCell(
                        text: cashFlowModel.eqCredit?.toStringAsFixed(2) ?? '0',
                        index: index),
                    customRowCell(text: runningTotal.toString(), index: index),
                  ]);
                }).toList(),
                columnWidths: const {
                  0: FixedColumnWidth(150),
                  1: FixedColumnWidth(300),
                  2: FixedColumnWidth(150),
                  3: FixedColumnWidth(150),
                  4: FixedColumnWidth(200),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
