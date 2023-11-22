import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'register_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:whatsapp/kontrol/controller.dart';
import 'package:whatsapp/whatsapp_main.dart';

bool _isHidden = false;

class calistir extends StatefulWidget {
  const calistir({Key? key}) : super(key: key);

  @override
  State<calistir> createState() => _calistirState();
}

class _calistirState extends State<calistir> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final TextEditingController _editingController = TextEditingController();
    final TextEditingController _Controller = TextEditingController();

    AuthService _authService = AuthService();

    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage("assets/image.png"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.darken)),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign In",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Container(
                    width: size.width / 1.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 11, right: 11),
                            child: TextFormField(
                              obscureText: false, //_isHidden ? false : true
                              controller: _editingController,
                              decoration: InputDecoration(
                                  hintText: "Email", border: InputBorder.none),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    width: size.width / 1.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 11, right: 11),
                            child: TextFormField(
                              obscureText: _isHidden ? false : true,
                              controller: _Controller,
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(0.0),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isHidden = !_isHidden;
                                  print(_isHidden);
                                });
                              },
                              icon: _isHidden
                                  ? Icon(Icons.remove_red_eye)
                                  : Icon(Icons.remove_red_eye_outlined)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      width: size.width / 1.3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff075e54).withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: InkWell(
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          if (_editingController.text == "" ||
                              _Controller.text == "") {
                          } else {
                            _authService
                                .signIn(
                                    _editingController.text, _Controller.text)
                                .then((value) {
                              return Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => whatsapp()),
                              );
                            });
                          }
                        },
                        child: Text("Giriş Yap",
                            style: TextStyle(color: Colors.black)),
                      ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Color(0xff075e54),
                      height: 1,
                      width: size.width / 3.2,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                        child: Text(
                          "Kayıt Ol",
                          style: TextStyle(color: Color(0xff075e54)),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      color: Color(0xff075e54),
                      height: 1,
                      width: size.width / 3.2,
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
/*

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp/kontrol/controller.dart';
import 'package:whatsapp/whatsapp_main.dart';

class Giris extends StatelessWidget {
  const Giris({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();
    KullaniciId isimId = Get.put(KullaniciId());
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Giriş Yap",
            style: TextStyle(fontSize: 24, color: Colors.green),
          ),
          TextFormField(
            controller: myController,
          ),
          OutlinedButton(
              onPressed: () {
                isimId.isimid.value = myController.text;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => whatsapp(),
                    ));
              },
              child: Text("Giriş Yap"))
        ],
      ),
    );
  }
}
*/