import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HelperClasses/app_widget.dart';
import 'HelperClasses/languages/my_localization.dart';
import 'HelperClasses/text.dart';
import 'HelperClasses/languages/my_localization.dart';

class Chat extends StatefulWidget {
  final String toID;

  const Chat({Key key, this.toID}) : super(key: key);

  @override
  _ChatState createState() => _ChatState(toID);
}

class _ChatState extends State<Chat> {
  _ChatState(this.toID);
  final String toID;
  bool load = false;

  String chatID, toIDName, fromID, sendByName;

  List chats = [];
  TextEditingController messageEditingController = TextEditingController();

  Widget chatMessages() {
    return ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return MessageTile(
            message: chats[index]["message"],
            sendByMe: fromID == chats[index]["sendBy"],
          );
        });
  }

  getToIDName() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(toID)
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        toIDName = ds['name'];
      });
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(fromID)
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        sendByName = ds['name'];
      });
    });
  }

  addMessage() async {
    if (messageEditingController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("ChatMessage")
          .doc(chatID)
          .collection('chat')
          .add({
        "sendBy": fromID,
        "message": messageEditingController.text,
        "time": DateTime.now().millisecondsSinceEpoch,
      }).catchError((e) {
        // ignore: avoid_print
        print(e.toString());
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection("ChatMessage")
            .doc(chatID)
            .set({
          "sendBy": fromID,
          "sendByName": sendByName,
          "toID": toID,
          "toIDName": toIDName,
          "message": messageEditingController.text,
          "time": DateTime.now().millisecondsSinceEpoch,
        });
      });

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  getChats() async {
    setState(() {
      load = true;
    });
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("ChatMessage")
        .doc(chatID)
        .collection('chat')
        .orderBy('time')
        .get();

    if (qs.docs.isEmpty) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      setState(() {
        chatID = '${toID}_${sp.getString('userID')}';
      });
      qs = await FirebaseFirestore.instance
          .collection("ChatMessage")
          .doc(chatID)
          .collection('chat')
          .orderBy('time')
          .get();
    }
    setState(() {
      load = false;
    });
    return qs.docs;
  }

  listen() {
    FirebaseFirestore.instance
        .collection("ChatMessage")
        .snapshots()
        .listen((event) {
      getChats().then((val) {
        setState(() {
          chats = val;
        });
      });
    });
  }

  getChatID() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      fromID = sp.getString('userID');
      chatID = '${sp.getString('userID')}_$toID';
    });
  }

  @override
  void initState() {
    super.initState();
    getToIDName();
    getChatID();
    listen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        const AppWidget(),
        Container(
          margin: const EdgeInsets.only(top: 100, left: 250, right: 250),
          child: Scaffold(
            appBar: AppBar(
              title: MyText(text: toIDName.toString(), size: 20),
              centerTitle: true,
              backgroundColor: Colors.cyan[900],
            ),
            body: Column(
              children: [
                Expanded(
                  child: Card(
                      margin: EdgeInsets.zero,
                      child: load
                          ? SpinKitThreeBounce(color: Colors.blueGrey[900])
                          : chatMessages()),
                ),
                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.blueGrey[900],
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 60, left: 20, right: 20, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            child: TextField(
                          controller: messageEditingController,
                          cursorColor: Colors.white,
                          textDirection: TextDirection.rtl,
                          onSubmitted: (_) => addMessage(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: 'somar'),
                          decoration: InputDecoration(
                              hintText: MyLocalization.of(context).getTranslatedValue('writeHere'),
                              hintStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontFamily: 'somar'),
                              border: InputBorder.none),
                        )),
                        const SizedBox(
                          width: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            addMessage();
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      colors: [
                                        Color(0x36FFFFFF),
                                        Color(0x0FFFFFFF)
                                      ],
                                      begin: FractionalOffset.topLeft,
                                      end: FractionalOffset.bottomRight),
                                  borderRadius: BorderRadius.circular(40)),
                              padding: const EdgeInsets.all(12),
                              child: Image.asset(
                                "assets/images/send.png",
                                height: 25,
                                width: 25,
                              )),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  const MessageTile({Key key, @required this.message, @required this.sendByMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                  : [Colors.blueGrey, Colors.blueGrey[900]],
            )),
        child: Text(message,
            textAlign: TextAlign.start,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: 'somar',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
