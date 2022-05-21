import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamz/HelperClasses/alert.dart';
import 'HelperClasses/app_widget.dart';
import 'HelperClasses/display_product.dart';
import 'HelperClasses/languages/my_localization.dart';
import 'HelperClasses/text.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List product = [];
  List _product = [];

  List cat = [];

  String category = 'إظهار الكل';

  bool load = false;

  String userID;

  getUserID() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userID = sp.getString('userID');
  }

  getCat() async {
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("Category").get();
    return qs.docs;
  }

  var ranking = 'ترتيب عشوائي';
  final _ranking = [
    'ترتيب عشوائي',
    'ترتيب السعر من الأعلى إلى الأقل',
    'ترتيب السعر من الأقل إلى الأعلى'
  ];

    var city = 'فلتر حسب المنطقة';
  final _city = [
    'فلتر حسب المنطقة',
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

  getProducts() async {
    setState(() {
      load = true;
    });
    QuerySnapshot qs;
    if(city != 'فلتر حسب المنطقة' && ranking == 'ترتيب عشوائي' && category == 'إظهار الكل') {
      qs = await FirebaseFirestore.instance.collection("Products").where('city', isEqualTo: city).get();
    } else {
    if (ranking == 'ترتيب عشوائي' && category == 'إظهار الكل' && city == 'فلتر حسب المنطقة') {
      qs = await FirebaseFirestore.instance.collection("Products").get();
    } else if (city == 'فلتر حسب المنطقة' && ranking != 'ترتيب عشوائي' && category == 'إظهار الكل') {
      qs = await FirebaseFirestore.instance
          .collection("Products")
          .orderBy('price',
              descending:
                  ranking == 'ترتيب السعر من الأعلى إلى الأقل' ? true : false)
          .get();
    } else if (city == 'فلتر حسب المنطقة' && ranking == 'ترتيب عشوائي' && category != 'إظهار الكل') {
      qs = await FirebaseFirestore.instance
          .collection("Products")
          .where('prodCat', isEqualTo: category)
          .get();
    } else if (city != 'فلتر حسب المنطقة' && ranking == 'ترتيب عشوائي' && category == 'إظهار الكل') {
qs = await FirebaseFirestore.instance.collection("Products").where('city', isEqualTo: city).get();
    }
    else if (city != 'فلتر حسب المنطقة' && ranking != 'ترتيب عشوائي' && category == 'إظهار الكل') {
      qs = await FirebaseFirestore.instance.collection("Products").where('city', isEqualTo: city).orderBy('price',
              descending:
                  ranking == 'ترتيب السعر من الأعلى إلى الأقل' ? true : false).get();
    } else if (city == 'فلتر حسب المنطقة' && ranking != 'ترتيب عشوائي' && category != 'إظهار الكل') {
      qs = await FirebaseFirestore.instance.collection("Products").orderBy('price',
              descending:
                  ranking == 'ترتيب السعر من الأعلى إلى الأقل' ? true : false).get();
    }
    else {
      qs = await FirebaseFirestore.instance
          .collection("Products")
          .where('city', isEqualTo: city)
          .where('prodCat', isEqualTo: category)
          .orderBy('price',
              descending:
                  ranking == 'ترتيب السعر من الأعلى إلى الأقل' ? true : false)
          .get();
    }
    }
    setState(() {
      load = false;
    });
    return qs.docs;
  }

  lisitn() {
    
    FirebaseFirestore.instance.collection("Products").snapshots().listen((_) {
      getProducts().then((value) => setState(() => product = _product = value));
    });
  }


  @override
  void initState() {
    super.initState();
    lisitn();
    getUserID();
    getCat().then((value) => setState(() => cat = value));
  }

  _filterList(value) {
    setState(() {
      product =
          _product.where((name) => name['prodName'].contains(value)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body:  Column(
      children: [
        Stack(
          children: [
            const AppWidget(),
            Padding(
                padding: const EdgeInsets.only(top: 135, left: 15, right: 15),
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 45,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    category = 'إظهار الكل';
                                    lisitn();
                                  });
                                },
                                child: Card(
                                  elevation: 20,
                                  color: category == 'إظهار الكل'
                                      ? Colors.cyan[700]
                                      : Colors.blueGrey[800],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: MyText(
                                      text: 'إظهار الكل',
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 45,
                                child: ListView.builder(
                                    itemCount: cat.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (_, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            category = cat[index]['cat'];
                                            lisitn();
                                          });
                                        },
                                        child: Card(
                                          elevation: 20,
                                          color: category == cat[index]['cat']
                                              ? Colors.cyan[700]
                                              : Colors.blueGrey[800],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            child: MyText(
                                              text: cat[index]['cat'],
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (v) => _filterList(v),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontFamily: 'somar', fontSize: 20),
                                decoration: InputDecoration(
                                  hintText: MyLocalization.of(context).getTranslatedValue('search'),
                                  hintStyle: const TextStyle(
                                      fontFamily: 'somar', fontSize: 20),
                                  contentPadding: EdgeInsets.zero,
                                  prefixIcon: const Icon(Icons.search),
                                  enabledBorder: const OutlineInputBorder(),
                                  focusedBorder: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 300,
                              child: FormField<String>(
                                builder: (FormFieldState<String> state1) {
                                  return InputDecorator(
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(6),
                                        prefixIcon:
                                            Icon(Icons.filter_list_sharp),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white))),
                                    child: DropdownButtonHideUnderline(
                                        child: Center(
                                      child: DropdownButton<String>(
                                        value: ranking,
                                        style: const TextStyle(
                                            fontFamily: 'somar'),
                                        iconSize: 0,
                                        isExpanded: true,
                                        iconEnabledColor: Colors.transparent,
                                        onChanged: (newValue) {
                                          setState(() {
                                            state1.didChange(newValue);
                                            ranking = newValue;
                                            lisitn();
                                          });
                                        },
                                        items: _ranking.map((String value) {
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

                            SizedBox(
                              width: 300,
                              child: FormField<String>(
                                builder: (FormFieldState<String> state1) {
                                  return InputDecorator(
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(6),
                                        prefixIcon:
                                            Icon(Icons.filter_alt_outlined),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white))),
                                    child: DropdownButtonHideUnderline(
                                        child: Center(
                                      child: DropdownButton<String>(
                                        value: city,
                                        style: const TextStyle(
                                            fontFamily: 'somar'),
                                        iconSize: 0,
                                        isExpanded: true,
                                        iconEnabledColor: Colors.transparent,
                                        onChanged: (newValue) {
                                          setState(() {
                                            state1.didChange(newValue);
                                            city = newValue;
                                            lisitn();
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
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ),
        Expanded(
          child: load
              ? SpinKitCubeGrid(color: Colors.blueGrey[900])
              : product.isNotEmpty
                  ? GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 280),
                      padding: const EdgeInsets.only(
                          top: 50, bottom: 50, left: 25, right: 25),
                      itemCount: product.length,
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () {
                            DisplayProduct().show(
                                context,
                                product[index]['image1'],
                                product[index]['image2'],
                                product[index]['image3'],
                                product[index]['prodName'],
                                product[index]['city'],
                                product[index]['detiels'],
                                product[index]['prodCat'],
                                product[index]['price'],
                                product[index]['userID']);
                          },
                          child: Card(
                              elevation: 20,
                              color: Colors.blueGrey,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              child: Column(children: [
                                Card(
                                  margin: const EdgeInsets.all(0),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  child: SizedBox(
                                    child: Stack(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Center(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(30),
                                            child: Image(
                                              image: NetworkImage(
                                                  product[index]['image1']),
                                                  width: double.infinity,
                                                  height: 220,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        Card(
                                          color: Colors.amber,
                                          margin: const EdgeInsets.all(0),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10))),
                                          child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: MyText(
                                                text: product[index]
                                                    ['prodName'],
                                                size: 20,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        MyText(
                                            text:
                                                '${product[index]['price']} ${MyLocalization.of(context).getTranslatedValue('sr')}',
                                            color: Colors.white,
                                            size: 20),
                                        InkWell(
                                          onTap: () async {
                                            SharedPreferences sp = await SharedPreferences.getInstance();
                                            sp.getString('userID') == '' || sp.getString('userID') == null ? Alert().show(context, 'لا يمكنك إضافة المنتج إلى العربة يجب عليك تسجيل الدخول أو إنشاء حساب جديد.') : await FirebaseFirestore.instance
                                                .collection("Cart")
                                                .add({
                                              "userID": userID,
                                              "prodID": product[index]
                                                  ['prodID'],
                                              "prodName": product[index]
                                                  ['prodName'],
                                              "detiels": product[index]
                                                  ['detiels'],
                                              "prodCat": product[index]
                                                  ['prodCat'],
                                              "price": product[index]['price'],
                                             "image1": product[index]['image1'],
                                              "image2": product[index]['image2'],
                                              "image3": product[index]['image3']
                                            });
                                          },
                                          child: const Icon(
                                            Icons.add_shopping_cart,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ])),
                        );
                      })
                  : Center(
                      child: MyText(
                          text: MyLocalization.of(context).getTranslatedValue('noItemHere'),
                          size: 50),
                    ),
        ),
      ],
    ));
  }
}
