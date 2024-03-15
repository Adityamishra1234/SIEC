import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siec_assignment/bloc/appBloc.dart';
import 'package:siec_assignment/data/repository/appRepo.dart';
import 'package:siec_assignment/homescreen/homepage.dart';

import 'constants/constants.dart';
import 'data/network/apiService.dart';
import 'data/network/interceptors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  Dio dio = Dio();
  dio.interceptors.add(AppInterceptors());
  final ApiService apiService = ApiService(dio);
  runApp( MyApp(sharedPreferences, apiService));
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;
  final ApiService api;
  const MyApp(this.prefs, this.api, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
        }),
        colorScheme: ColorScheme.fromSeed(seedColor: K.primaryColor),
        useMaterial3: true,
      ),
      home: const splashScreen(),
    );
  }
}


// ignore: camel_case_types
class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  _splashScreen createState() => _splashScreen();
}

class _splashScreen extends State<splashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 5),
          () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const homescreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Image.asset("assets/images/bgabovecommon.png",),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: K.primaryColor,
                  child: Icon(Icons.add, color: Colors.white,),
                ),
                SizedBox(height: 10,),
                Text("ToDo App", style: TextStyle(
                  fontFamily: 'PlayfairDisplay'
                ),),
              ],
            )
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset("assets/images/bgcommon.png",),
          ),
        ],
      ),
    );
  }

}