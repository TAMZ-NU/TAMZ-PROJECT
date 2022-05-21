import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamz/HelperClasses/alert.dart';
import 'package:tamz/chat.dart';

import 'languages/my_localization.dart';
import 'text.dart';

class DisplayProduct {
  show(BuildContext context, image1, image2, image3, prodName, city, detials, prodCat, price, toID) {
    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: SizedBox(
                width: 1000,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.close,
                                size: 30,
                                color: Colors.black,
                              )),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image(
                                    image: NetworkImage(image1),
                                    width: 200,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                            ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                              child: Image(
                                image: NetworkImage(image2),
                                fit: BoxFit.contain,
                                width: 200,
                              ),
                            ),
                            ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                              child: Image(
                                image: NetworkImage(image3),
                                fit: BoxFit.contain,
                                width: 200,
                              ),
                            ),
                              ],
                            ),
                            cards(MyLocalization.of(context).getTranslatedValue('prodName'), prodName),
                            cards(MyLocalization.of(context).getTranslatedValue('city'), city),
                            cards(MyLocalization.of(context).getTranslatedValue('prodInfo'), detials),
                            cards(MyLocalization.of(context).getTranslatedValue('proCat'), prodCat),
                            cards(MyLocalization.of(context).getTranslatedValue('price'), '$price ${MyLocalization.of(context).getTranslatedValue('sr')}'),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FlatButton.icon(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(15))),
                              onPressed: () async {
                                SharedPreferences sp =
                                    await SharedPreferences.getInstance();
                                if (sp.getString("userID") == toID) {
                                  Alert().show(context,
                                      MyLocalization.of(context).getTranslatedValue('cannotChat'));
                                } else if (sp.getString("userID") == '' ||
                                    sp.getString("userID") == null) {
                                  Alert()
                                      .show(context, MyLocalization.of(context).getTranslatedValue('needLogin'));
                                } else {
                                  Navigator.pop(context);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Chat(toID: toID)));
                                }
                              },
                              color: Colors.blueGrey[900],
                              icon: const Icon(Icons.chat, color: Colors.white),
                              label: MyText(
                                text: MyLocalization.of(context).getTranslatedValue('chatSupplayer'),
                                size: 30.0,
                                color: Colors.white,
                              )),
                        ),
                        Expanded(
                          child: FlatButton.icon(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15))),
                              onPressed: () => Navigator.pop(context),
                              color: Colors.cyan[900],
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              label: MyText(
                                text: MyLocalization.of(context).getTranslatedValue('close'),
                                size: 30.0,
                                color: Colors.white,
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  cards(title, value) => Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Align(
              alignment: Alignment.centerRight,
              child: MyText(
                text: title,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            margin: EdgeInsets.zero,
            color: Colors.blueGrey[900],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Center(
                child: MyText(
                  text: value.toString(),
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      );
}
