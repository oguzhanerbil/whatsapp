import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'package:whatsapp/main.dart';
import 'giris.dart';

// Stream<QuerySnapshot> _register =
//     FirebaseFirestore.instance.collection("testCollection").snapshots();
bool goster = true;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final TextEditingController _editingController = TextEditingController();
    final TextEditingController _email = TextEditingController();
    final TextEditingController _Controller = TextEditingController();

    AuthService _authService = AuthService();

    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
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
              Text(
                "Sign Up",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  textfield(
                    size: size,
                    editingController: _editingController,
                    yazi: "Kullanıcı Adı",
                    goz: Padding(
                      padding: const EdgeInsets.all(10.0),
                    ),
                    passwordgoz: false,
                  ),
                  SizedBox(height: 25),
                  textfield(
                    size: size,
                    editingController: _email,
                    yazi: "Email",
                    goz: Padding(
                      padding: const EdgeInsets.all(10.0),
                    ),
                    passwordgoz: false,
                  ),
                  SizedBox(height: 25),
                  textfield(
                    size: size,
                    editingController: _Controller,
                    yazi: "Password",
                    goz: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: InkWell(
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              goster == false ? goster = true : goster = false;
                            });
                          },
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    passwordgoz: goster,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      width: size.width / 1.3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff075e54).withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: FlatButton(
                        color: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          _authService
                              .createPerson(_editingController.text,
                                  _email.text, _Controller.text)
                              .then((value) {
                            return Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => calistir()),
                            );
                          });
                        },
                        child: Text("Kayıt Ol",
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
                            MaterialPageRoute(builder: (context) => calistir()),
                          );
                        },
                        child: Text(
                          "Giriş Yap",
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

class textfield extends StatelessWidget {
  const textfield(
      {Key? key,
      required this.size,
      required TextEditingController editingController,
      required this.yazi,
      required this.goz,
      required this.passwordgoz})
      : _editingController = editingController,
        super(key: key);

  final Size size;
  final TextEditingController _editingController;
  final String yazi;
  final Padding goz;
  final bool passwordgoz;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width / 1.3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 11, right: 11),
              child: TextField(
                obscureText: passwordgoz,
                controller: _editingController,
                decoration: InputDecoration(
                    hintText: "$yazi", border: InputBorder.none),
              ),
            ),
          ),
          goz,
        ],
      ),
    );
  }
}
