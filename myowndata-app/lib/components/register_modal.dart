// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'dart:convert';
import 'dart:html';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myowndata/components/data_edit_item.dart';
import 'package:myowndata/components/data_edit_date_item.dart';
import 'package:myowndata/model/airtable_api.dart';

class RegisterModal extends StatefulWidget {
  @override
  RegisterApp createState() => RegisterApp();
}

class RegisterApp extends State<RegisterModal> {
  TextEditingController fullnameTXT = new TextEditingController();
  TextEditingController emailTXT = new TextEditingController();
  TextEditingController dateTXT = new TextEditingController();
  TextEditingController passwordTXT = new TextEditingController();
  TextEditingController ConPassTXT = new TextEditingController();
  bool isLoading = false;
  var POSTheader = {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };

  Future<void> RegisterAccount() async {
    final usersTable = base('users');
    var filterByFormula =
        ' AND({email} = \'${emailTXT.text}\', {password} = \'${passwordTXT.text}\')';
    final records = await usersTable.select(filterBy: (filterByFormula));

    if ((records.isEmpty)) {
        await usersTable.create({
            "name": fullnameTXT.text,
            "email": emailTXT.text,
            "password": passwordTXT.text,
            "birth_date": dateTXT.text,
            "image": "https://i.postimg.cc/SsxGw5cZ/person.jpg",
            "credits": 0          
        });
        Navigator.pop(context);
    }
   
   
    setState(() => isLoading = false);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        child: Container(
          height: 560,
          width: 400,
          child: Column(
            children: [
              Container(
                width: 400,
                margin: EdgeInsets.only(top: 24, left: 24, bottom: 24),
                child: Text('Register your account',
                    style: GoogleFonts.getFont('Lexend Deca',
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w600)),
              ),
              Container(
                margin: EdgeInsets.only(left: 24, right: 24),
                child:
                    DataEditItem(label: "Full Name", controller: fullnameTXT),
              ),
              Container(
                margin: EdgeInsets.only(left: 24, right: 24),
                child: DataEditDateItem(
                    label: "Date Of Birth", controller: dateTXT),
              ),
              Container(
                margin: EdgeInsets.only(left: 24, right: 24),
                child: DataEditItem(label: "Email", controller: emailTXT),
              ),
              Container(
                margin: EdgeInsets.only(left: 24, right: 24),
                child: DataEditItem(
                  label: "Password",
                  isPassword: true,
                  controller: passwordTXT,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 24, right: 24),
                child: DataEditItem(
                  label: "Repeat Password",
                  isPassword: true,
                  controller: ConPassTXT,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 24, right: 24),
                child: GestureDetector(
                  onTap: () async {
                    if (isLoading) return;
                    if (emailTXT.text == "" ||
                        fullnameTXT.text == "" ||
                        passwordTXT.text == "" ||
                        ConPassTXT.text == "") return;
                    if (passwordTXT.text != ConPassTXT.text) return;
                    setState(() => isLoading = true);
                    await RegisterAccount();
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
                            : Text("Register",
                                style: GoogleFonts.getFont('Lexend Deca',
                                    fontSize: 16, color: Colors.white)),
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
