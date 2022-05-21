import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamz/HelperClasses/app_widget.dart';
import 'package:tamz/HelperClasses/display_product.dart';
import 'package:tamz/HelperClasses/text.dart';
import 'package:tamz/pay.dart';

import 'HelperClasses/languages/my_localization.dart';

class Cart extends StatefulWidget {
  const Cart({Key key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List product = [];
  bool load = false, delete = false;
  String userID;

  int price = 0;
  getUserID() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userID = sp.getString('userID');
  }

  getProducts() async {
    setState(() {
      load = true;
    });
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Cart")
        .where('userID', isEqualTo: userID)
        .get();
    setState(() {
      price = 0;
    });
    for (DocumentSnapshot ds in qs.docs) {
      setState(() {
        price += ds['price'];
      });
    }

    setState(() {
      load = false;
    });
    return qs.docs;
  }

  lisitn() {
    FirebaseFirestore.instance
        .collection("Cart")
        .where('userID', isEqualTo: userID)
        .snapshots()
        .listen((_) {
      getProducts().then((value) => setState(() => product = value));
    });
  }

  @override
  void initState() {
    super.initState();
    getUserID();
    lisitn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        const AppWidget(),
        Container(
          margin: const EdgeInsets.only(top: 150, left: 100, right: 100),
          child: Column(
            children: [
              Expanded(
                child: Card(
                  margin: EdgeInsets.zero,
                  child: product.isNotEmpty
                      ? ListView.builder(
                          itemCount: product.length,
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 30, bottom: 30),
                          itemBuilder: (_, index) {
                            price += product[index]['price'];

                            return SizedBox(
                              height: 200,
                              width: 350,
                              child: InkWell(
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
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image(
                                          image: NetworkImage(
                                              product[index]['image1']),
                                          fit: BoxFit.contain,
                                          width: 200,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      SizedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            MyText(
                                                text:
                                                    '${MyLocalization.of(context).getTranslatedValue('prodName')}: ${product[index]['prodName']}',
                                                size: 40),
                                            MyText(
                                                text:
                                                    '${MyLocalization.of(context).getTranslatedValue('prodInfo')}: ${product[index]['detiels']}',
                                                size: 20),
                                            MyText(
                                                text:
                                                    '${MyLocalization.of(context).getTranslatedValue('proCat')}: ${product[index]['prodCat']}',
                                                size: 20),
                                            MyText(
                                                text:
                                                    '${MyLocalization.of(context).getTranslatedValue('price')}: ${product[index]['price']} ريال'
                                                        .toString(),
                                                size: 20),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () async {
                                          setState(() {
                                            delete = true;
                                          });
                                          await FirebaseFirestore.instance
                                              .collection('Cart')
                                              .where('prodID',
                                                  isEqualTo: product[index]
                                                      ['prodID'])
                                              .get()
                                              .then((snapshot) async {
                                            for (DocumentSnapshot ds
                                                in snapshot.docs) {
                                              await ds.reference.delete();
                                              setState(() {
                                                lisitn();
                                              });
                                            }
                                          });
                                          setState(() {
                                            delete = false;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.red[900],
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(15),
                                                      bottomLeft:
                                                          Radius.circular(15))),
                                          height: double.infinity,
                                          width: 70,
                                          child: Center(
                                              child: delete
                                                  ? const SpinKitDualRing(
                                                      color: Colors.white,
                                                      size: 20,
                                                    )
                                                  : const Icon(
                                                      Icons.delete,
                                                      size: 50,
                                                      color: Colors.white,
                                                    )),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                      : Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.shopping_cart, size: 80),
                            const SizedBox(height: 20),
                            MyText(
                                text: MyLocalization.of(context).getTranslatedValue('noItem'),
                                size: 50),
                          ],
                        )),
                ),
              ),
              Card(
                margin: EdgeInsets.zero,
                color: Colors.blueGrey[900],
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60, top: 20, left: 20, right: 20),
                  child: Row(
                    children: [
                      MyText(
                          text: '${MyLocalization.of(context).getTranslatedValue('total')}: $price ${MyLocalization.of(context).getTranslatedValue('sr')}',
                          size: 30,
                          color: Colors.white),
                          Spacer(),
                      SizedBox(
                        height: 50,
                        child: FlatButton.icon(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Pay())),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Colors.white,
                          icon: const Icon(Icons.money),
                          label: MyText(
                            text: MyLocalization.of(context).getTranslatedValue('next'),
                            size: 25,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }
}
