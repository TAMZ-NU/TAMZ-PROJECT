import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamz/HelperClasses/app_widget.dart';
import 'package:tamz/HelperClasses/display_product.dart';
import 'package:tamz/HelperClasses/text.dart';

import 'HelperClasses/languages/my_localization.dart';

class Pay extends StatefulWidget {
  const Pay({Key key}) : super(key: key);

  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {


int i = 0;

String id = "669608010101139";
 String iban = "SA1180000669608010101139";
  

  String _myActivity = 'شركة إثمار السعودية للاستشارات المالية';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        const AppWidget(),
        SingleChildScrollView(
          padding: EdgeInsets.only(top: 50),
          child: Container(
            margin: const EdgeInsets.only(top: 100, left: 100, right: 100),
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.payment, size: 50),
                                  MyText(
                                      text: 'طرق الدفع',
                                      size: 50),
                                ],
                              ),
        
                              const SizedBox(height: 20),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                onTap: () => setState(() => i = 0),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 90,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: i == 0 ? Colors.black : Colors.grey,
                                          width: 3
                                        )
                                      ),
                                      padding: const EdgeInsets.all(20),
                                      width: 150,
                                      child: Image.asset('assets/images/mada.png'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 5,bottom: 5),
                                      decoration: BoxDecoration(
                                        color: i == 0 ? Colors.black : Colors.grey,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(100)
                                        )
                                      ),
                                      child: const Icon(Icons.check, color: Colors.white,))
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => i = 1),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 90,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: i == 1 ? Colors.black : Colors.grey,
                                          width: 3
                                        )
                                      ),
                                      padding: const EdgeInsets.all(20),
                                      width: 150,
                                      child: Image.asset('assets/images/visa.png'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 5,bottom: 5),
                                      decoration: BoxDecoration(
                                        color: i == 1 ? Colors.black : Colors.grey,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(100)
                                        )
                                      ),
                                      child: const Icon(Icons.check, color: Colors.white,))
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => i = 2),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 90,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: i == 2 ? Colors.black : Colors.grey,
                                          width: 3
                                        )
                                      ),
                                      padding: const EdgeInsets.all(20),
                                      width: 150,
                                      child: Image.asset('assets/images/pay.svg.png'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 5,bottom: 5),
                                      decoration: BoxDecoration(
                                        color: i == 2 ? Colors.black : Colors.grey,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(100)
                                        )
                                      ),
                                      child: const Icon(Icons.check, color: Colors.white,))
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => i = 3),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 90,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: i == 3 ? Colors.black : Colors.grey,
                                          width: 3
                                        )
                                      ),
                                      padding: const EdgeInsets.all(20),
                                      width: 150,
                                      child: Image.asset('assets/images/bank.png'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 5,bottom: 5),
                                      decoration: BoxDecoration(
                                        color: i == 3 ? Colors.black : Colors.grey,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(100)
                                        )
                                      ),
                                      child: const Icon(Icons.check, color: Colors.white,))
                                  ],
                                ),
                              )
                                ],
                              ),
                              const SizedBox(height: 30),
                             
        DropDownFormField(
                  titleText: 'اختر حساب التاجر',
                  
                  hintText: 'Please choose one',
                  value: _myActivity,
                  onSaved: (value) {
                    setState(() {
                      _myActivity = value;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      _myActivity = value;
                      print(value);
                    });
                  },
                  dataSource: const [
                    {
            "display" : "شركة إثمار السعودية للاستشارات المالية",
            "value" : "شركة إثمار السعودية للاستشارات المالية",
          },
          {
            "display" : "الشركة السعودية للاقتصاد والتنمية للأوراق المالية",
            "value" : "الشركة السعودية للاقتصاد والتنمية للأوراق المالية"
          },
          {
            "display" : "شركة أموال المالية",
            "value" : "شركة أموال المالية"
          },
          {
            "display" : "شركة فالكون للمنتجات البلاستيكية",
            "value" : "شركة فالكون للمنتجات البلاستيكية"
          },
          {
            "display" : "شركة منافع للاستثمار",
            "value" : "شركة منافع للاستثمار"
          },
          {
            "display" : "شركة سويكورب",
            "value" : "شركة سويكورب"
          },
          {
            "display" : "مجموعة كابلات الرياض",
            "value" : "مجموعة كابلات الرياض"
          },
          {
            "display" : "مجموعة رولاكو",
            "value" : "مجموعة رولاكو"
          },
          {
            "display" : "شركة أوجيه تيليكوم",
            "value" : "شركة أوجيه تيليكوم"
          }
                    
                    
                  ],
                  textField: 'display',
                  valueField: 'value',
                ),
        
                const SizedBox(height: 30),
                MyText(text: 'صاحب الحساب', size: 35),
                MyText(text: _myActivity, size: 25),
        
                const SizedBox(height: 10),
                MyText(text: 'رقم الحساب', size: 35),
                MyText(text: id, size: 25),
        
                const SizedBox(height: 10),
                MyText(text: 'رقم الآيبان', size: 35),
                MyText(text: iban, size: 25),
        const SizedBox(height: 50),
        SizedBox(
                        height: 50,
                        child: FlatButton.icon(
                          
                          onPressed: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Colors.blueGrey[900],
                          icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.white,),
                          label: MyText(
                            text: 'إكمال الدفع',
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                            ],
                          )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  getIBAN (value) {
    switch (value) {
      case "شركة إثمار السعودية للاستشارات المالية": {
        setState(() {
          iban = "669608010101139";
          id = "SA1180000" + iban;
        });
      }
        break;

        case "الشركة السعودية للاقتصاد والتنمية للأوراق المالية": {
        setState(() {
          iban = "6623408010101235";
          id = "SA1180000" + iban;
        });
      }
        break;

         case "شركة أموال المالية": {
        setState(() {
          iban = "6621408010104225";
          id = "SA1180000" + iban;
        });
      }
        break;
        


case "شركة فالكون للمنتجات البلاستيكية" : {
        setState(() {
          iban = "6831408010102932";
          id = "SA1180000" + iban;
        });
      }
        break;

        

        case "شركة منافع للاستثمار" : {
        setState(() {
          iban = "6888408010101552";
          id = "SA1180000" + iban;
        });
      }
        break;

        case "شركة سويكورب" : {
        setState(() {
          iban = "68888360101011992";
          id = "SA1180000" + iban;
        });
      }
        break;
        

        case "مجموعة كابلات الرياض" : {
        setState(() {
          iban = "62188360101011122";
          id = "SA1180000" + iban;
        });
      }
        break;

        case "مجموعة رولاكو" : {
        setState(() {
          iban = "7818836013011126";
          id = "SA1180000" + iban;
        });
      }
        break;
        
        case "شركة أوجيه تيليكوم" : {
        setState(() {
          iban = "1628836013011566";
          id = "SA1180000" + iban;
        });
      }
        break;
      default:
    }
  }
}

