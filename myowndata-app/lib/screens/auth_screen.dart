import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myowndata/screens/connect_data.dart';
import 'package:myowndata/screens/informedconsent_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myowndata/components/data_edit_item.dart';
import 'package:myowndata/components/register_modal.dart';
import 'package:myowndata/screens/get_ready.dart';
import 'package:myowndata/screens/study_id_screen.dart';
import 'package:myowndata/screens/main_screen.dart';
import 'package:myowndata/model/airtable_api.dart';

class AuthScreen extends StatefulWidget {
  @override
  AuthScreenApp createState() => AuthScreenApp();
}

class AuthScreenApp extends State<AuthScreen> {
  TextEditingController emailTXT = new TextEditingController();
  TextEditingController passwordTXT = new TextEditingController();
  bool isLoading = false;
  var POSTheader = {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };
  @override
  initState() {
    GetAccount();
    super.initState();
  }

  Future<void> GetAccount() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString("userid"));
    if (prefs.getString("userid") != "" && prefs.getString("userid") != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ),
      );
    }
  }

  Future<void> LoginAccount() async {
    final usersTable = base('users');
    var filterByFormula =
        ' AND({email} = \'${emailTXT.text}\', {password} = \'${passwordTXT.text}\')';
    final records = await usersTable.select(filterBy: (filterByFormula));

    if ((records.isNotEmpty)) {
      var userid = records[0]['id'];

      final prefs = await SharedPreferences.getInstance();

      prefs.setString("userid", userid);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ConnectDataScreen(),
        ),
      );
      print(prefs.getString("userid"));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email/password is incorrect!")));
    }

    setState(() => isLoading = false);
    return;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.asset("assets/images/bg.png").image,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 16, top: 20, right: 16, bottom: 20),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: size.height / 1.1,
                  constraints: const BoxConstraints(
                    minHeight: 500,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: SvgPicture.asset(
                          "assets/images/Logo.svg",
                          height: 150,
                          width: 150,
                        ),
                      ),
                      Column(children: [
                        Text("I own my data,",
                            style: GoogleFonts.getFont('Lexend Deca',
                                color: Color(0xFFF06129),
                                fontSize: 20,
                                fontWeight: FontWeight.w700)),
                        Text("my data is my own",
                            style: GoogleFonts.getFont('Lexend Deca',
                                color: Color(0xFFF06129),
                                fontSize: 20,
                                fontWeight: FontWeight.w700))
                      ]),
                      Container(
                        width: size.width,
                        height: 260,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                Image.asset("assets/images/login-picture.png")
                                    .image,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 24, left: 24, right: 24),
                        child:
                            DataEditItem(label: "Email", controller: emailTXT),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 24, right: 24),
                        child: DataEditItem(
                            label: "Password",
                            isPassword: true,
                            controller: passwordTXT),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 24, right: 24),
                        child: GestureDetector(
                          onTap: () async {
                            if (isLoading) return;
                            if (emailTXT.text == "" || passwordTXT.text == "")
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Please fill all fields!")));
                            setState(() => isLoading = true);
                            await LoginAccount();
                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(8),
                            elevation: 2,
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFFF06129),
                              ),
                              child: Center(
                                child: isLoading
                                    ? SizedBox(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                        height: 20.0,
                                        width: 20.0,
                                      )
                                    : Text("Login",
                                        style: GoogleFonts.getFont(
                                            'Lexend Deca',
                                            fontSize: 16,
                                            color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 24, right: 24),
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            //showCupertinoModalBottomSheet(context: context, builder: builder)
                            showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) => RegisterModal(),
                            );
                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1.2, color: Color(0xFF6B7280)),
                                color: const Color(0xFFF3F4F6),
                              ),
                              child: Center(
                                child: Text("Register",
                                    style: GoogleFonts.getFont('Lexend Deca',
                                        fontSize: 16,
                                        color: Color(0xFF6B7280))),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
