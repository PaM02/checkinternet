import 'package:checkinternet/no_internet.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';


void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool hasInternet = false;
  ConnectivityResult result = ConnectivityResult.none;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Connectivity().onConnectivityChanged.listen((result) {
    //   setState(() => this.result = result);
    // });

    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() => this.hasInternet = hasInternet);
    });
  }
  @override
  Widget build(BuildContext context) => (
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: hasInternet ? Center(
          child: ElevatedButton(
            onPressed: () async {
              result = await Connectivity().checkConnectivity();
              showTopSnackbar(result, context);
            },
            child: const Text("Check Connection"),
          ),
        ) : const NoInternetScreen(),
      ),
    )
  );

  void showTopSnackbar(ConnectivityResult result, BuildContext context) {

    var netConnect = false;

    if (result != ConnectivityResult.none){
      netConnect = true;
    }

    if (result == ConnectivityResult.mobile){
      Fluttertoast.showToast(
        msg: "Mobile Internet",
        gravity: ToastGravity.BOTTOM,
      );
    }else if (result == ConnectivityResult.wifi){
      Fluttertoast.showToast(
        msg: "Wifi Internet",
        gravity: ToastGravity.BOTTOM,
      );
    }else{
      Fluttertoast.showToast(
        msg: "No Internet",
        gravity: ToastGravity.BOTTOM,
      );
    }

    final message = netConnect
        ? 'You have Internet'
        : 'You have no Internet !';
    final color = netConnect?Colors.green:Colors.red;
    Text(message);


  }
}
