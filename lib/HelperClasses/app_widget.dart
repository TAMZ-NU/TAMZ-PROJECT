import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamz/add_product.dart';
import 'package:tamz/cart.dart';
import 'package:tamz/settings.dart';
import '../chat_room.dart';
import '../home.dart';
import '../login.dart';
import 'languages/languages.dart';
import 'languages/my_localization.dart';
import 'languages/utils.dart';
import 'text.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  bool loggedIn = false;

  List lang = ['العربية', 'English'];
  var _lang = 'العربية';

  getLoggedIn() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    if (sp.getString("userID") == '' || sp.getString("userID") == null) {
      setState(() {
        loggedIn = false;
      });
    } else {
      setState(() {
        loggedIn = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[900],
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.only(right: 20, top: 20, left: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(width: 10),
              Column(
                children: [
                  MyText(text: 'TAMZ', size: 43, color: Colors.white),
                  MyText(text: 'ONLINE SHOP', size: 17, color: Colors.white),
                  MyText(
                      text:
                          MyLocalization.of(context).getTranslatedValue('shop'),
                      size: 15,
                      color: Colors.white),
                ],
              ),
            ],
          ),
          const Spacer(),
          btn(MyLocalization.of(context).getTranslatedValue('homePage'),
              Icons.home, toHome, true),
          SizedBox(width: loggedIn ? 20 : 0),
          btn(MyLocalization.of(context).getTranslatedValue('chats'),
              Icons.chat, toChat, loggedIn ? true : false),
          SizedBox(width: loggedIn ? 20 : 0),
          btn(MyLocalization.of(context).getTranslatedValue('addProduct'),
              Icons.post_add, addProduct, loggedIn ? true : false),
          SizedBox(width: loggedIn ? 20 : 0),
          btn(MyLocalization.of(context).getTranslatedValue('cart'),
              Icons.shopping_cart, toCart, loggedIn ? true : false),
          SizedBox(width: loggedIn ? 20 : 0),
          btn(MyLocalization.of(context).getTranslatedValue('settings'),
              Icons.settings, toSettings, loggedIn ? true : false),
          const SizedBox(width: 20),
          btn(
              loggedIn
                  ? MyLocalization.of(context).getTranslatedValue('logout')
                  : MyLocalization.of(context).getTranslatedValue('login'),
              loggedIn ? Icons.logout : Icons.login,
              logout,
              true),
          const SizedBox(width: 20),
          btn(MyLocalization.of(context).getTranslatedValue('change_language'),
              Icons.language, setLang, true),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  toHome() => Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (contex) => const Home()), (route) => false);
  toChat() => Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (contex) => const ChatRoom()),
      (route) => false);

  addProduct() => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const AddProduct()));

  toCart() => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const Cart()));

  toSettings() => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const Settings()));

  logout() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("userID", '').then((value) => Navigator.of(context)
        .pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false));
  }

  setLang() {
    setState(() {
      MyLocalization.of(context).getTranslatedValue('change_language') == 'EN'
          ? Utils.changeLanguages(
              Languages(1, 'عربي', 'ar'),
              context,
            )
          : Utils.changeLanguages(
              Languages(0, 'English', 'en'),
              context,
            );
    });
  }

  btn(text, icon, fun, vis) => Visibility(
        visible: vis,
        child: InkWell(
          onTap: () => fun(),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
              MyText(
                text: text,
                size: 25,
                color: Colors.white,
              )
            ],
          ),
        ),
      );
}
