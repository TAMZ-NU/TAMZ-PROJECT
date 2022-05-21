import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamz/HelperClasses/alert.dart';
import 'package:tamz/HelperClasses/text.dart';
import 'package:tamz/home.dart';
import 'package:tamz/signup.dart';

import 'HelperClasses/languages/my_localization.dart';

class RestPassword extends StatefulWidget {
  const RestPassword({Key key}) : super(key: key);

  @override
  _RestPasswordState createState() => _RestPasswordState();
}

class _RestPasswordState extends State<RestPassword> {
  TextEditingController email = TextEditingController();
  bool load = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Card(
          color: Colors.blueGrey[900],
          margin: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(100),
            bottomRight: Radius.circular(100),
          )),
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            width: double.infinity,
            padding: const EdgeInsets.only(right: 20, top: 20, left: 20),
            child: Row(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: (() => toHome()),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/logo.jpg',
                              width: 55,
                            ),
                          ),
                        ),
                      ),
                    ),
                    MyText(text: 'TAMZ', size: 40, color: Colors.white),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 20),
                  child: Column(
                    children: [
                      MyText(
                          text: 'ONLINE SHOP', size: 40, color: Colors.white),
                      MyText(
                          text: MyLocalization.of(context)
                              .getTranslatedValue('shop'),
                          size: 35,
                          color: Colors.white),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 100),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(
                    text:
                        MyLocalization.of(context).getTranslatedValue('login'),
                    size: 50,
                    color: Colors.white),
                const SizedBox(height: 10),
                Card(
                  elevation: 30,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 50, right: 50, bottom: 60, top: 30),
                    child: Column(
                      children: [
                        field(
                            MyLocalization.of(context)
                                .getTranslatedValue('email'),
                            Icons.email,
                            MyLocalization.of(context)
                                .getTranslatedValue('enterEmail'),
                            email),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Column(
                  children: [
                    SizedBox(
                      width: 420,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                          onPressed: () => rest(),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Colors.blueGrey[900],
                          child: load
                              ? const SpinKitThreeBounce(color: Colors.white)
                              : MyText(
                                  text: MyLocalization.of(context)
                                      .getTranslatedValue('rest'),
                                  size: 40,
                                  color: Colors.white)),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 420,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                          onPressed: () => Navigator.pop(context),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Colors.blueGrey[600],
                          child: MyText(
                              text: MyLocalization.of(context)
                                  .getTranslatedValue('back'),
                              size: 40,
                              color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Center(
                    child: MyText(
                  text: MyLocalization.of(context).getTranslatedValue('7q'),
                ))
              ],
            ),
          ),
        )
      ],
    ));
  }

  field(title, icon, hint, controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          MyText(
            text: title,
            size: 30,
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 350,
            child: TextField(
              controller: controller,
              style: const TextStyle(fontFamily: 'somar'),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(fontFamily: 'somar', fontSize: 20),
                  prefixIcon: Icon(icon),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
          ),
        ],
      );

  rest() async {
    setState(() {
      load = true;
    });
    email.text.isEmpty
        ? Alert().show(
            context, MyLocalization.of(context).getTranslatedValue('enterData'))
        : await FirebaseAuth.instance
            .sendPasswordResetEmail(email: email.text)
            .then((value) async {
            Alert().show(context,
                MyLocalization.of(context).getTranslatedValue('rest_email'));
            email.clear();
          }).catchError((e) {
            Alert().show(context, e.toString());
            setState(() {
              load = false;
            });
          });
    setState(() {
      load = false;
    });
  }

  toHome() => Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (contex) => const Home()), (route) => false);
}
