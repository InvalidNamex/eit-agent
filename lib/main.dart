import 'dart:io';
import 'dart:ui';

import 'package:eit/screens/new_return_invoice/new_return_invoice.dart';
import 'package:eit/screens/no_connection.dart';
import 'package:eit/screens/reports_screens/customer_ledger_screen.dart';
import 'package:eit/screens/reports_screens/sales_analysis/sales_analysis.dart';
import 'package:eit/screens/sales_returns_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '/constants.dart';
import '/screens/home_screen.dart';
import '/screens/index_screen.dart';
import '/screens/login_screen.dart';
import '/screens/new_customer.dart';
import '/screens/new_receipt.dart';
import '/screens/receipt_screen.dart';
import '/screens/reports_screens/cash_flow_screen.dart';
import '/screens/reports_screens/customers_reports/customers_balances_screen.dart';
import '/screens/reports_screens/reports_screen.dart';
import '/screens/reports_screens/stock_by_treeList.dart';
import '/screens/splash_screen.dart';
import '/screens/stock_screen.dart';
import '/screens/visits_screen.dart';
import 'bindings.dart';
import 'localization_hierarchy/lanugages.dart';
import 'localization_hierarchy/localization_controller.dart'; // Added import
import 'screens/new_invoice/new_invoice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //! this class overrides the check for certificate validation and logs user in even with expired certificate
  HttpOverrides.global = MyHttpOverrides();
  runApp(Phoenix(child: const MyApp()));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown
      };
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final LocalizationController localizationController =
        Get.put(LocalizationController());

    return GetMaterialApp(
      locale: Get.locale ?? Get.deviceLocale,
      translations: Languages(),
      fallbackLocale: const Locale('en', 'US'),
      title: 'EIT',
      initialRoute: '/',
      enableLog: true,
      logWriterCallback: (text, {isError = false}) {
        if (isError) {
          Logger().e(text);
        } else {
          Logger().i(text);
        }
      },
      theme: ThemeData(
          useMaterial3: false,
          fontFamily: 'Cairo',
          appBarTheme: const AppBarTheme(
              backgroundColor: lightColor,
              iconTheme: IconThemeData(color: darkColor))),
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      initialBinding: AuthBinding(),
      getPages: [
        GetPage(
            name: '/',
            page: () => const SplashScreen(),
            binding: AuthBinding(),
            transition: Transition.fadeIn,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/login-screen',
            page: () => const LoginScreen(),
            binding: AuthBinding(),
            transition: Transition.upToDown,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/index-screen',
            page: () => const IndexScreen(),
            binding: HomeBinding(),
            transition: Transition.fadeIn,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/home-screen',
            page: () => const HomeScreen(),
            binding: HomeBinding(),
            transition: Transition.rightToLeft,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/receipt-screen',
            page: () => const ReceiptScreen(),
            binding: HomeBinding(),
            transition: Transition.leftToRight,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/stock-screen',
            page: () => const StockScreen(),
            binding: HomeBinding(),
            transition: Transition.upToDown,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/new-invoice',
            page: () => const NewInvoice(),
            binding: HomeBinding(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 300)),
        GetPage(
            name: '/new-customer',
            page: () => NewCustomer(),
            binding: HomeBinding(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 300)),
        GetPage(
            name: '/new-receipt',
            page: () => const NewReceipt(),
            binding: HomeBinding(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 300)),
        GetPage(
            name: '/reports-screen',
            page: () => const ReportsScreen(),
            binding: HomeBinding(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 300)),
        GetPage(
            name: '/visits-screen',
            page: () => const VisitsScreen(),
            binding: HomeBinding(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 300)),
        GetPage(
            name: '/cash-flow',
            page: () => const CashFlowScreen(),
            binding: HomeBinding(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 300)),
        GetPage(
            name: '/new-sales-return',
            page: () => const NewReturnInvoice(),
            binding: HomeBinding(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 300)),
        GetPage(
            name: '/sales-returns',
            page: () => const SalesReturnsScreen(),
            binding: HomeBinding(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 300)),
        GetPage(
            name: '/stock-by-tree-list',
            page: () => const StockByTreeList(),
            binding: HomeBinding(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 300)),
        GetPage(
            name: '/customers-balances',
            page: () => const CustomersBalancesScreen(),
            binding: HomeBinding(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 300)),
        GetPage(
            name: '/customer-ledger',
            page: () => const CustomerLedgerScreen(),
            binding: HomeBinding(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 300)),
        GetPage(
            name: '/sales-analysis',
            page: () => const SalesAnalysis(),
            binding: HomeBinding(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 300)),
        GetPage(
            name: '/no-connection',
            page: () => const NoConnection(),
            binding: AuthBinding(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 100)),
      ],
      builder: (context, child) {
        return Obx(() {
          return Directionality(
            textDirection: localizationController.textDirection.value,
            child: child!,
          );
        });
      },
    );
  }
}
