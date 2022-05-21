import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamz/HelperClasses/alert.dart';
import 'HelperClasses/app_widget.dart';
import 'HelperClasses/languages/my_localization.dart';
import 'HelperClasses/text.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String username, state;
  TextEditingController name = TextEditingController(),
      email = TextEditingController(),
      birthDateText = TextEditingController(),
      phoneNumber = TextEditingController();
  DateTime birthDate = DateTime.now();
  bool load = false;
  getDate() async {
    setState(() {
      load = true;
    });
    SharedPreferences sp = await SharedPreferences.getInstance();
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(sp.getString("userID"))
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        username = ds['username'];
        name.text = ds['name'];
        birthDate = DateTime.parse(ds['birthDate'].toDate().toString());
        birthDateText.text =
            '${birthDate.year} . ${birthDate.month} . ${birthDate.day}';
        email.text = ds['email'];
        phoneNumber.text = ds['phoneNumber'];
        state = ds['state'];
      });
    });
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        const AppWidget(),
        Card(
          margin: const EdgeInsets.only(
              top: 100, left: 250, right: 250, bottom: 30),
          elevation: 20,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                field(MyLocalization.of(context).getTranslatedValue('username'), username, Icons.person_pin_circle_rounded,
                    Icons.where_to_vote_rounded),
                field(MyLocalization.of(context).getTranslatedValue('name'), name.text, Icons.person, Icons.edit),
                field(MyLocalization.of(context).getTranslatedValue('birthDate'), birthDateText.text, Icons.date_range,
                    Icons.edit),
                field(MyLocalization.of(context).getTranslatedValue('email'), email.text, Icons.email, Icons.edit),
                field(MyLocalization.of(context).getTranslatedValue('phoneNumber'), phoneNumber.text, Icons.phone_android,
                    Icons.edit),
                field(MyLocalization.of(context).getTranslatedValue('userState'), state, Icons.accessibility,
                    Icons.where_to_vote_rounded),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  field(title, value, icon, secondIcon) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: double.infinity,
        child: Card(
          elevation: 8,
          color: Colors.blueGrey[900],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
            child: Row(
              children: [
                SizedBox(
                    width: 50,
                    child: Icon(icon, size: 40, color: Colors.white)),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          title.toString(),
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              color: Colors.cyan,
                              fontSize: 30,
                              fontFamily: 'somar',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 5),
                      load
                          ? const SpinKitThreeBounce(
                              color: Colors.white, size: 30)
                          : Text(
                              value.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'somar',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                    ],
                  ),
                ),
                SizedBox(
                    width: 50,
                    child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          if (title == MyLocalization.of(context).getTranslatedValue('birthDate')) {
                            setData(title, birthDateText);
                          } else if (title == MyLocalization.of(context).getTranslatedValue('name')) {
                            setData(title, name);
                          } else if (title == MyLocalization.of(context).getTranslatedValue('phoneNumber')) {
                            setData(title, phoneNumber);
                          } else if (title == MyLocalization.of(context).getTranslatedValue('email')) {
                            setData(title, email);
                          }
                        },
                        child: Icon(
                          secondIcon,
                          size: 30,
                          color: Colors.orange[300],
                        ))),
              ],
            ),
          ),
        ),
      );

  showGregorianCalendar(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: birthDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (picked != null && picked.isBefore(DateTime.now())) {
      setState(() {
        birthDate = picked;
        birthDateText.text =
            '${birthDate.year} . ${birthDate.month} . ${birthDate.day}';
      });
    }
  }

  setData(title, controller) {
    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              backgroundColor: Colors.blueGrey[900],
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Container(
                width: 500,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.close,
                              size: 30,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    MyText(text: title, size: 30.0, color: Colors.white),
                    const SizedBox(height: 50),
                    title == MyLocalization.of(context).getTranslatedValue('birthDate')
                        ? InkWell(
                            child: TextField(
                              controller: birthDateText,
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'somar',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              enabled: false,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.date_range,
                                    color: Colors.transparent),
                                prefixIcon:
                                    Icon(Icons.date_range, color: Colors.white),
                                contentPadding: EdgeInsets.only(right: 10),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.white)),
                              ),
                            ),
                            onTap: () => showGregorianCalendar(context),
                          )
                        : TextField(
                            style: const TextStyle(
                                fontSize: 25,
                                fontFamily: 'somar',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            controller: controller,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.date_range,
                                    color: Colors.transparent),
                                prefixIcon:
                                    Icon(Icons.date_range, color: Colors.white),
                                contentPadding: EdgeInsets.only(right: 10),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.white)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.white))),
                          ),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: double.infinity,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          onPressed: () async {
                            if (controller.text.isEmpty) {
                              Alert().show(
                                  context, MyLocalization.of(context).getTranslatedValue('enterData'));
                            } else {
                              SharedPreferences sp =
                                  await SharedPreferences.getInstance();
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(sp.getString('userID'))
                                  .update({
                                "birthDate": birthDate,
                                "name": name.text,
                                "phoneNumber": phoneNumber.text,
                                "email": email.text
                              }).then((value) => getDate());
                              Navigator.pop(context);
                            }
                          },
                          color: Colors.white,
                          child: MyText(
                            text: MyLocalization.of(context).getTranslatedValue('edit'),
                            size: 30.0,
                            color: Colors.black,
                          )),
                    )
                  ],
                ),
              ),
            ));
  }
}
