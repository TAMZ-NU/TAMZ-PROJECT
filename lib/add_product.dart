// ignore_for_file: deprecated_member_use

import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HelperClasses/alert.dart';
import 'HelperClasses/languages/my_localization.dart';
import 'HelperClasses/text.dart';
import 'home.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key key}) : super(key: key);

  @override
  AadPproductState createState() => AadPproductState();
}

class AadPproductState extends State<AddProduct> {
  int id = DateTime.now().microsecondsSinceEpoch;
  bool load = false;
  var cat = 'اختر من القائمة';
  final _cat = [
    'اختر من القائمة',
    'الأجهزة الكهربائية',
    'الأواني المنزلية',
    'الكمبيوترات واللابتوبات',
    'الجوالات والأجهزة اللوحية',
    'الشاشات والتلفزيونات',
    'ألعاب الفيديو',
    'الأجهزة الرياضية',
    'الدراجات الهوائية'
  ];

  var city = 'اختر من القائمة';
  final _city = [
    'اختر من القائمة',
    'الرياض',
    'مكة المكرمة ',
    'المدينة المنورة',
    'القصيم',
    'الشرقية',
    'عسير',
    'تبوك',
    'حائل',
    'الحدود الشمالية',
    'جازان',
    'نجران',
    'الباحة',
    'الجوف'
  ];

  TextEditingController prodName = TextEditingController(),
      price = TextEditingController(),
      detiels = TextEditingController();

  void uploadToStorage(i) {
    setState(() {
      load = true;
    });
    uploadImage(
      onSelected: (file) async {
        try {
          fb
              .storage()
              .refFromURL('gs://tamzshop.appspot.com/')
              .child('${id.toString()}-$i')
              .put(file)
              .future
              .then((value) {
            setState(() {
              downloadUrl(id.toString(), i);
            });
          }).catchError((e) => Alert().show(context, e));
        } catch (e) {
          print(e);
          setState(() {
            load = false;
          });
        }
      },
    );
  }

  void uploadImage({@required Function(File file) onSelected}) {
    InputElement uploadInput = FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
      });
    });
  }

  var url1, url2, url3;
  downloadUrl(id, i) async {
    var storage = await fb
        .storage()
        .refFromURL('gs://tamzshop.appspot.com/')
        .child('${id.toString()}-$i')
        .getDownloadURL();
    setState(() {
      if (i == 1) {
        url1 = storage;
      } else if (i == 2) {
        url2 = storage;
      } else {
        url3 = storage;
      }
      load = false;
    });
  }

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
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 100),
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(top: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                      text: MyLocalization.of(context)
                          .getTranslatedValue('addProd'),
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
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Icon(
                                Icons.image,
                                size: 30,
                              ),
                              MyText(
                                  text: MyLocalization.of(context)
                                      .getTranslatedValue('prodImage'),
                                  size: 35),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Card(
                                    elevation: 20,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: url1 == null
                                        ? SizedBox(
                                            width: 250,
                                            height: 250,
                                            child: Center(
                                              child: FlatButton(
                                                  onPressed: () =>
                                                      uploadToStorage(1),
                                                  child: MyText(
                                                    text: MyLocalization.of(
                                                            context)
                                                        .getTranslatedValue(
                                                            'clickToAddImage'),
                                                    size: 20,
                                                  )),
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image(
                                                fit: BoxFit.cover,
                                                width: 200,
                                                image: NetworkImage(
                                                    url1.toString())),
                                          )),
                                Card(
                                    elevation: 20,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: url2 == null
                                        ? SizedBox(
                                            width: 250,
                                            height: 250,
                                            child: Center(
                                              child: FlatButton(
                                                  onPressed: () =>
                                                      uploadToStorage(2),
                                                  child: MyText(
                                                    text: MyLocalization.of(
                                                            context)
                                                        .getTranslatedValue(
                                                            'clickToAddImage'),
                                                    size: 20,
                                                  )),
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image(
                                                fit: BoxFit.cover,
                                                width: 200,
                                                image: NetworkImage(
                                                    url2.toString())),
                                          )),
                                Card(
                                    elevation: 20,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: url3 == null
                                        ? SizedBox(
                                            width: 250,
                                            height: 250,
                                            child: Center(
                                              child: FlatButton(
                                                  onPressed: () =>
                                                      uploadToStorage(3),
                                                  child: MyText(
                                                    text: MyLocalization.of(
                                                            context)
                                                        .getTranslatedValue(
                                                            'clickToAddImage'),
                                                    size: 20,
                                                  )),
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image(
                                                fit: BoxFit.cover,
                                                width: 200,
                                                image: NetworkImage(
                                                    url3.toString())),
                                          )),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              idField(
                                  MyLocalization.of(context)
                                      .getTranslatedValue('id'),
                                  Icons.production_quantity_limits),
                              const Spacer(),
                              field(
                                  MyLocalization.of(context)
                                      .getTranslatedValue('prodName'),
                                  Icons.shop_2_sharp,
                                  MyLocalization.of(context)
                                      .getTranslatedValue('enterProdName'),
                                  prodName)
                            ],
                          ),
                          const SizedBox(height: 20),
                          cityField(
                              MyLocalization.of(context)
                                  .getTranslatedValue('city'),
                              Icons.location_city),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: MyText(
                              text: MyLocalization.of(context)
                                  .getTranslatedValue('prodInfo'),
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: double.infinity,
                            child: TextField(
                              textAlign: TextAlign.center,
                              maxLines: 5,
                              controller: detiels,
                              style: const TextStyle(
                                  fontFamily: 'somar', fontSize: 20),
                              decoration: InputDecoration(
                                  hintText: MyLocalization.of(context)
                                      .getTranslatedValue('enterProdData'),
                                  hintStyle: const TextStyle(
                                      fontFamily: 'somar', fontSize: 20),
                                  prefixIcon: const Icon(Icons.description),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15))),
                            ),
                          ),
                          Row(
                            children: [
                              catField(
                                  MyLocalization.of(context)
                                      .getTranslatedValue('proCat'),
                                  Icons.category_sharp),
                              const Spacer(),
                              field(
                                  MyLocalization.of(context)
                                      .getTranslatedValue('price'),
                                  Icons.price_change,
                                  MyLocalization.of(context)
                                      .getTranslatedValue('enterProdPrice'),
                                  price),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 350,
                      child: FlatButton(
                          onPressed: () => addNewProduct(),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Colors.blueGrey[900],
                          child: load
                              ? const SpinKitThreeBounce(color: Colors.white)
                              : MyText(
                                  text: MyLocalization.of(context)
                                      .getTranslatedValue('addProd1'),
                                  size: 40,
                                  color: Colors.white)),
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
              decoration: InputDecoration(
                  hintText: 'P$id',
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
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'somar', fontSize: 20),
              decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(fontFamily: 'somar', fontSize: 20),
                  prefixIcon: Icon(icon),
                  suffixText: title ==
                          MyLocalization.of(context).getTranslatedValue('price')
                      ? MyLocalization.of(context).getTranslatedValue('sr')
                      : '',
                  suffixStyle:
                      const TextStyle(fontFamily: 'somar', fontSize: 20),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
          ),
        ],
      );

  catField(title, icon) => Column(
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
              builder: (FormFieldState<String> state) {
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
                      value: cat,
                      style: const TextStyle(fontFamily: 'somar'),
                      iconSize: 0,
                      isExpanded: true,
                      iconEnabledColor: Colors.transparent,
                      onChanged: (newValue) {
                        setState(() {
                          state.didChange(newValue);
                          cat = newValue;
                        });
                      },
                      items: _cat.map((String value) {
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

  cityField(title, icon) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          MyText(
            text: title,
            size: 30,
          ),
          const SizedBox(height: 5),
          SizedBox(
            child: FormField<String>(
              builder: (FormFieldState<String> state) {
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
                      value: city,
                      style: const TextStyle(fontFamily: 'somar'),
                      iconSize: 0,
                      isExpanded: true,
                      iconEnabledColor: Colors.transparent,
                      onChanged: (newValue) {
                        setState(() {
                          state.didChange(newValue);
                          city = newValue;
                        });
                      },
                      items: _city.map((String value) {
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

  addNewProduct() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    setState(() {
      load = true;
    });
    url1 == null ||
            prodName.text.isEmpty ||
            detiels.text.isEmpty ||
            cat == 'اختر من القائمة' ||
            price.text.isEmpty
        ? Alert().show(
            context, MyLocalization.of(context).getTranslatedValue('enterData'))
        : await FirebaseFirestore.instance.collection("Products").add({
            "prodID": id,
            "prodName": prodName.text,
            "detiels": detiels.text,
            "prodCat": cat,
            "price": int.parse(price.text),
            "image1": url1.toString(),
            "image2": url2.toString(),
            "image3": url3.toString(),
            "city": city,
            "userID": sp.getString("userID")
          }).catchError((e) {
            Alert().show(context, e.message);
            setState(() {
              load = false;
            });
          }).then((value) => Navigator.pop(context));
    setState(() {
      load = false;
    });
  }

  toHome() => Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (contex) => const Home()), (route) => false);
}
