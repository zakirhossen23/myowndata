// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myowndata/components/bottom_navbar.dart';
import 'package:myowndata/providers/navbar_provider.dart';
import 'package:myowndata/screens/auth_screen.dart';
import 'package:myowndata/screens/tabscreens/home_screen.dart';
import 'package:myowndata/screens/tabscreens/journey_screen.dart';
import 'package:myowndata/screens/tabscreens/mydata_screen.dart';
import 'package:myowndata/screens/tabscreens/credit_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

late TabController controller;

class _MainScreenState extends ConsumerState<MainScreen>
    with SingleTickerProviderStateMixin {
  final widgets = [
    //home
    HomeScreen(),

    //Journey
    JourneyScreen(),

    //My Data
    MyDataScreen(),

    //credits
    CreditScreen()
  ];

  @override
  initState() {
    super.initState();
    controller = TabController(length: widgets.length, vsync: this, animationDuration: Duration(microseconds: 0));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var navbarViewmodel = ref.watch(navbarProvider);
    Future<void> Logout() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("userid");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AuthScreen(),
        ),
      );
    }

    return Scaffold(
      bottomNavigationBar: MyOwnDataNavbar((int newIndex) {
        controller.index = newIndex;
        navbarViewmodel.updateIndex(newIndex);
      }),
      body: TabBarView(
        children: widgets,
        controller: controller,
      ),
    );
  }
}
