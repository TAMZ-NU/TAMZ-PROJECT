import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'languages/my_localization.dart';
import 'text.dart';

class Alert {
  show(BuildContext context, text) {
    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Container(
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
                    MyText(text: text, size: 30.0),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: double.infinity,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          onPressed: () => Navigator.pop(context),
                          color: Colors.white,
                          child: MyText(
                            text: MyLocalization.of(context)
                                .getTranslatedValue('ok'),
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
