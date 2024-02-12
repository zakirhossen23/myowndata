// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names, unnecessary_new, sized_box_for_whitespace, prefer_const_constructors

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter/material.dart';
import 'package:myowndata/providers/feeling_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myowndata/components/data_edit_item.dart';
import 'package:myowndata/components/data_edit_dropdown.dart';
import 'package:myowndata/screens/main_screen.dart';
import 'package:myowndata/model/airtable_api.dart';
import 'package:http/http.dart' as http;

class ConnectDataScreen extends ConsumerStatefulWidget {
  const ConnectDataScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConnectDataScreen> createState() => _ConnectDataScreenState();
}

class _ConnectDataScreenState extends ConsumerState<ConnectDataScreen> {
  TextEditingController GivenNameTXT = new TextEditingController();
  TextEditingController FamilyNameTXT = new TextEditingController();
  TextEditingController SexTXT = new TextEditingController(text: null);
  TextEditingController PhoneTXT = new TextEditingController();
  TextEditingController DiseaseTXT = new TextEditingController();
  TextEditingController ImageTXT = new TextEditingController(text: "");

  bool isLoading = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    var feelingViewmodel = ref.watch(feelingProvider);

    Future<void> UpdateData() async {
      setState(() => isLoading = true);

      final prefs = await SharedPreferences.getInstance();
      var userid = prefs.getString("userid");
      try {
        final UsersDataTable = base('users_data');

        await UsersDataTable.create({
          "user_id": userid,
          "givenname": GivenNameTXT.text,
          "familyname": FamilyNameTXT.text,
          "gender": SexTXT.text,
          "phone": PhoneTXT.text,
          "about": DiseaseTXT.text
        });
        final UsersTable = base('users');
        await UsersTable.update(userid!, {"image": ImageTXT.text});
      } catch (e) {}
      setState(() => isLoading = false);
      feelingViewmodel.updateIndex(1);
      return;
    }

    void FinishWork() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ),
      );
    }

    void UpdateImage() async {
      setState(() {
        ImageTXT.text = ImageTXT.text;
      });
      Navigator.pop(context);
    }

    imagePickerOption(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Image url'),
              content: TextField(
                controller: ImageTXT,
                decoration: const InputDecoration(
                    hintText: "https://image.com/example.png"),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('SUBMIT'),
                  onPressed: UpdateImage,
                )
              ],
            );
          });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              IndexedStack(index: feelingViewmodel.selectedIndex, children: [
                Column(
                  children: [
                    Container(
                      //width: 400,

                      margin:
                          const EdgeInsets.only(top: 24, left: 24, bottom: 24),
                      child: Text('Fill your personal details',
                          style: GoogleFonts.getFont('Lexend Deca',
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                    ),
                    Container(
                      height: 150,
                      width: 150,
                      padding: EdgeInsets.all(12),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200.0),
                          color: Colors.white),
                      child: Stack(
                        children: [
                          Container(
                            child: Wrap(
                              children: [
                                Image.network(
                                    ImageTXT.text == ""
                                        ? "https://i.postimg.cc/SsxGw5cZ/person.jpg"
                                        : ImageTXT.text,
                                    width: size.width,
                                    fit: BoxFit.fill)
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: GestureDetector(
                                onTap: () {
                                  imagePickerOption(context);
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Color(0xFFF06129),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Color(0xFFF06129),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 24, right: 24),
                      child: DataEditItem(
                          label: "Given Name", controller: GivenNameTXT),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 24, right: 24),
                      child: DataEditItem(
                          label: "Family Name", controller: FamilyNameTXT),
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 24, right: 24),
                        child: DataEditDropdown(
                          controller: SexTXT,
                          items: ["Male", "Female"],
                          label: "Sex",
                        )),
                    Container(
                      margin: const EdgeInsets.only(left: 24, right: 24),
                      child: DataEditItem(label: "Phone", controller: PhoneTXT),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 24, right: 24),
                      child: DataEditItem(
                          label: "About",
                          controller: DiseaseTXT,
                          isFilled: true),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(top: 0, left: 24, right: 24),
                      child: GestureDetector(
                        onTap: () async {
                          if (isLoading) return;

                          setState(() => isLoading = true);
                          await UpdateData();
                        },
                        child: Material(
                            borderRadius: BorderRadius.circular(8),
                            elevation: 0,
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
                                      : Text("Update",
                                          style: GoogleFonts.getFont(
                                              'Lexend Deca',
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500))),
                            )),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: size.height / 8,
                    ),
                    Center(
                      child: Image.asset(
                        "assets/images/welldone.gif",
                        width: 200,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 40),
                      child: Text(
                          "You have filled your personal information. You can now explore your dashboard",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont('Lexend Deca',
                              color: Color(0xFF423838),
                              fontSize: 24,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      GestureDetector(
                        onTap: () async {
                          FinishWork();
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(8),
                          elevation: 2,
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 0, left: 10, right: 10, bottom: 0),
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xFFF06129),
                            ),
                            child: Center(
                              child: Text(
                                "Finish",
                                style: GoogleFonts.getFont('Lexend Deca',
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ],
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
