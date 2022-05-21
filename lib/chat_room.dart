import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamz/chat.dart';

import 'HelperClasses/app_widget.dart';
import 'HelperClasses/languages/my_localization.dart';
import 'HelperClasses/text.dart';

class ChatRoom extends StatefulWidget {
  final String chatRoomId;

  const ChatRoom({Key key, this.chatRoomId}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  bool load = false;

  List chats = [];

  String userID;

  Widget chatMessages() {
    return chats.isEmpty
        ? Center(
            child: MyText(
              text: MyLocalization.of(context).getTranslatedValue('noChat'),
              size: 30,
            ),
          )
        : ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Chat(
                        toID: userID != chats[index]['sendBy']
                            ? chats[index]['sendBy']
                            : chats[index]['toID']))),
                child: Card(
                  color: Colors.blueGrey[900],
                  margin: const EdgeInsets.all(10),
                  elevation: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Image.asset('assets/images/avatar.png', width: 50),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text: userID != chats[index]['sendBy']
                                    ? chats[index]['sendByName']
                                    : chats[index]['toIDName'],
                                color: Colors.white,
                                size: 30,
                              ),
                              MyText(
                                text: chats[index]['message'],
                                color: Colors.grey[200],
                              )
                            ],
                          ),
                        ),
                        MyText(
                            color: Colors.white,
                            text: DateFormat.Hm()
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    chats[index]['time']))
                                .toString())
                      ],
                    ),
                  ),
                ),
              );
            });
  }

  getChats() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    setState(() {
      userID = sp.getString("userID");
      load = true;
    });
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("ChatMessage")
        .where("sendBy", isEqualTo: userID)
        .orderBy('time', descending: true)
        .get();

    if (qs.docs.isEmpty) {
      qs = await FirebaseFirestore.instance
          .collection("ChatMessage")
          .where("toID", isEqualTo: userID)
          .orderBy('time', descending: true)
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

  @override
  void initState() {
    listen();
    super.initState();
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
              title: MyText(text: MyLocalization.of(context).getTranslatedValue('chatList').toString(), size: 20),
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
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
