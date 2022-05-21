import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamz/HelperClasses/alert.dart';
import 'package:tamz/HelperClasses/text.dart';
import 'package:tamz/login.dart';

import 'HelperClasses/languages/my_localization.dart';
import 'home.dart';

class Signup extends StatefulWidget {
  const Signup({Key key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  int id = 1;
  var state = 'اختر من القائمة';
  final _state = ['اختر من القائمة', 'عميل', 'مسؤول'];
  bool load = false;

  TextEditingController name = TextEditingController(),
      username = TextEditingController(),
      email = TextEditingController(),
      phoneNumber = TextEditingController(),
      password = TextEditingController();

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
            child: Center(
              child: SizedBox(
                width: 800,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                        text: MyLocalization.of(context)
                            .getTranslatedValue('newAccount'),
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
                            left: 20, right: 20, bottom: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                idField(
                                    MyLocalization.of(context)
                                        .getTranslatedValue('userId'),
                                    Icons.person_pin_rounded),
                                const Spacer(),
                                field(
                                    MyLocalization.of(context)
                                        .getTranslatedValue('name'),
                                    Icons.person,
                                    MyLocalization.of(context)
                                        .getTranslatedValue('enterName'),
                                    name)
                              ],
                            ),
                            Row(
                              children: [
                                field(
                                    MyLocalization.of(context)
                                        .getTranslatedValue('email'),
                                    Icons.email,
                                    MyLocalization.of(context)
                                        .getTranslatedValue('enterEmail'),
                                    email),
                                const Spacer(),
                                dateField(
                                    MyLocalization.of(context)
                                        .getTranslatedValue('birthDate'),
                                    Icons.date_range)
                              ],
                            ),
                            Row(
                              children: [
                                field(
                                    MyLocalization.of(context)
                                        .getTranslatedValue('username'),
                                    Icons.person_pin_circle_rounded,
                                    MyLocalization.of(context)
                                        .getTranslatedValue('enterUsername'),
                                    username),
                                const Spacer(),
                                field(
                                    MyLocalization.of(context)
                                        .getTranslatedValue('phoneNumber'),
                                    Icons.phone_android,
                                    MyLocalization.of(context)
                                        .getTranslatedValue('enterPhoneNumber'),
                                    phoneNumber),
                              ],
                            ),
                            Row(
                              children: [
                                stateField(
                                    MyLocalization.of(context)
                                        .getTranslatedValue('userState'),
                                    Icons.accessibility),
                                const Spacer(),
                                field(
                                    MyLocalization.of(context)
                                        .getTranslatedValue('password'),
                                    Icons.password,
                                    MyLocalization.of(context)
                                        .getTranslatedValue('enterPassword'),
                                    password),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 350,
                            // ignore: deprecated_member_use
                            child: FlatButton(
                                onPressed: () => signup(),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                color: Colors.blueGrey[900],
                                child: load
                                    ? const SpinKitThreeBounce(
                                        color: Colors.white)
                                    : MyText(
                                        text: MyLocalization.of(context)
                                            .getTranslatedValue('newAccount'),
                                        size: 40,
                                        color: Colors.white)),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: MyText(
                                text: MyLocalization.of(context)
                                    .getTranslatedValue('haveAccount'),
                                size: 20),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                        child: MyText(
                      text: MyLocalization.of(context).getTranslatedValue('7q'),
                    ))
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }

  idField(title, icon) => Column(
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
              enabled: false,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'somar'),
              decoration: InputDecoration(
                  hintText: id.toString(),
                  hintStyle: const TextStyle(fontFamily: 'somar', fontSize: 20),
                  prefixIcon: Icon(icon),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
          ),
        ],
      );

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

  dateField(title, icon) => Column(
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
            child: GestureDetector(
              onTap: () => chooseDate(context),
              child: TextField(
                style: const TextStyle(fontFamily: 'somar'),
                enabled: false,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: !choose
                        ? MyLocalization.of(context)
                            .getTranslatedValue('chooseBirthDate')
                        : '${date.year} . ${date.month} . ${date.day}',
                    hintStyle: const TextStyle(
                      fontFamily: 'somar',
                      color: Colors.black54,
                      fontSize: 20,
                    ),
                    prefixIcon: Icon(icon),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
            ),
          ),
        ],
      );

  stateField(title, icon) => Column(
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
            child: FormField<String>(
              builder: (FormFieldState<String> state1) {
                return InputDecorator(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(6),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    prefixIcon: Icon(icon),
                  ),
                  child: DropdownButtonHideUnderline(
                      child: Center(
                    child: DropdownButton<String>(
                      value: state,
                      style: const TextStyle(fontFamily: 'somar'),
                      iconSize: 0,
                      isExpanded: true,
                      iconEnabledColor: Colors.transparent,
                      onChanged: (newValue) {
                        setState(() {
                          state1.didChange(newValue);
                          state = newValue;
                        });
                      },
                      items: _state.map((String value) {
                        return DropdownMenuItem<String>(
                            value: value,
                            child: SizedBox(
                              width: double.infinity,
                              child: Center(
                                  child: MyText(
                                text: value,
                                size: 20,
                                color: Colors.grey[600],
                              )),
                            ));
                      }).toList(),
                    ),
                  )),
                );
              },
            ),
          ),
        ],
      );

  DateTime date = DateTime(2000, 1, 1);
  bool choose = false;

  chooseDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        date = picked;
        choose = true;
      });
    }
  }

  signup() {
    setState(() {
      load = true;
    });

    name.text.isEmpty ||
            email.text.isEmpty ||
            phoneNumber.text.isEmpty ||
            username.text.isEmpty ||
            password.text.isEmpty ||
            !choose ||
            state ==
                MyLocalization.of(context).getTranslatedValue('chooseFromList')
        ? Alert().show(
            context, MyLocalization.of(context).getTranslatedValue('enterData'))
        : FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.text, password: password.text)
            .then((value) async {
            value.user.sendEmailVerification();
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(value.user.uid)
                .set({
              "userID": value.user.uid,
              "name": name.text,
              "email": email.text,
              "birthDate": date,
              "phoneNumber": phoneNumber.text,
              "username": username.text,
              "password": password.text,
              "state": state
            }).then((value) async {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false);
            }).catchError((e) => Alert().show(context, e.toString()));
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
