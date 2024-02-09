// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names, unnecessary_new, sized_box_for_whitespace, prefer_const_constructors

import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myowndata/components/data_edit_item.dart';
import 'package:myowndata/components/data_edit_dropdown.dart';
import 'package:myowndata/screens/main_screen.dart';
import 'package:http/http.dart' as http;

class ConnectDataScreen extends StatefulWidget {
  @override
  ConnectDataApp createState() => ConnectDataApp();
}

class ConnectDataApp extends State<ConnectDataScreen> {
  TextEditingController GivenNameTXT = new TextEditingController();
  TextEditingController FamilyNameTXT = new TextEditingController();
  TextEditingController GenderTXT = new TextEditingController(text:null);
  TextEditingController PhoneTXT = new TextEditingController();
  TextEditingController DiseaseTXT = new TextEditingController();

  bool isLoading = false;

  @override
  initState() {
    super.initState();
  }

  Future<void> UpdateData() async {
    // final prefs = await SharedPreferences.getInstance();
    // var userid = prefs.getString("userid");
    // try {
    //   var url = Uri.parse('http://localhost:8080/api/POST/UpadateFhir');
    //   final response = await http.post(url, headers: POSTheader, body: {
    //     'userid': userid,
    //     'givenname': GivenNameTXT.text,
    //     'identifier': IdentifierTXT.text,
    //     'patientid': FHIRIDTXT.text,
    //     // 'privatekey': PrivateKeyTXT.text,            ///Hard Coded
    //     'privatekey':
    //         "4913b179bdc903d0d7b64cc20c11fc095f5cfe3fe2b68499cbea1913a702df4c",
    //   });
    //   var responseData = json.decode(response.body);
    //   if (responseData['status'] == 200) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => MainScreen(),
    //       ),
    //     );
    //   }
    // } catch (e) {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(const SnackBar(content: Text("Please try again!")));
    // }

    setState(() => isLoading = false);
    return;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height / 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/heart.png",
                    width: 100,
                  ),
                ],
              ),
              Container(
                //width: 400,

                margin: const EdgeInsets.only(top: 24, left: 24, bottom: 24),
                child: Text('Fill your personal details',
                    style: GoogleFonts.getFont('Lexend Deca',
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w600)),
              ),
              Container(
                margin: const EdgeInsets.only(left: 24, right: 24),
                child:
                    DataEditItem(label: "Given Name", controller: GivenNameTXT),
              ),
              Container(
                margin: const EdgeInsets.only(left: 24, right: 24),
                child: DataEditItem(
                    label: "Family Name", controller: FamilyNameTXT),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 24, right: 24),
                  child: DataEditDropdown(controller: GenderTXT, items: ["Male","Female"],  label: "Gender",)),
              Container(
                margin: const EdgeInsets.only(left: 24, right: 24),
                child: DataEditItem(label: "Phone", controller: PhoneTXT),
              ),
              Container(
                margin: const EdgeInsets.only(left: 24, right: 24),
                child: DataEditItem(label: "Disease", controller: DiseaseTXT),
              ),
              Container(
                margin: const EdgeInsets.only(top: 32, left: 24, right: 24),
                child: GestureDetector(
                  onTap: () async {
                    if (isLoading) return;

                    setState(() => isLoading = true);
                    await UpdateData();
                  },
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    elevation: 2,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFF06129),
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
                            : Text("Update",style:GoogleFonts.getFont('Lexend Deca',
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500))
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
