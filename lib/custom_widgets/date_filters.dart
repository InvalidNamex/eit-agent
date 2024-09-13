import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

Card dateToFilterMethod(Rx<DateTime> dateToFilter, BuildContext context,
    {Function? optionalFunction}) {
  return Card(
    child: ListTile(
      trailing: const Icon(
        Icons.calendar_month,
        color: accentColor,
      ),
      title: Text('Date To'.tr),
      subtitle: FittedBox(
        child: Text(DateFormat('dd-MM-yyyy').format(dateToFilter.value)),
      ),
      onTap: () async {
        if (optionalFunction != null) {
          selectDate(context, dateToFilter, optionalFunction: optionalFunction);
        } else {
          selectDate(context, dateToFilter);
        }
      },
    ),
  );
}

Card dateFromFilterMethod(Rx<DateTime> dateFromFilter, BuildContext context,
    {Function? optionalFunction}) {
  return Card(
    child: ListTile(
        trailing: const Icon(
          Icons.calendar_month,
          color: accentColor,
        ),
        title: Text('Date From'.tr),
        subtitle: FittedBox(
          child: Text(DateFormat('dd-MM-yyyy').format(dateFromFilter.value)),
        ),
        onTap: () async {
          if (optionalFunction != null) {
            selectDate(context, dateFromFilter,
                optionalFunction: optionalFunction);
          } else {
            selectDate(context, dateFromFilter);
          }
        }),
  );
}

DateTime firstOfJanuaryLastYear() {
  DateTime now = DateTime.now();
  int lastYear = now.year - 1;
  return DateTime(lastYear, 1, 1); // 1st January of last year
}

Future<void> selectDate(BuildContext context, Rx<DateTime> x,
    {Function? optionalFunction}) async {
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: x.value,
      firstDate: DateTime(2010),
      lastDate: DateTime.now());
  if (picked != null && picked != x.value) {
    x(picked);
    if (optionalFunction != null) {
      await optionalFunction();
    }
  }
}
