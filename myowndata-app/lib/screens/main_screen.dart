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
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainScreen extends  ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
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
        
        navbarViewmodel.updateIndex(newIndex);
      }),
      body: IndexedStack(
        children: widgets,
        index: navbarViewmodel.selectedIndex,
      ),
    );
  }
}
