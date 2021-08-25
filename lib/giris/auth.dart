import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp/kontrol/controller.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // GİRİŞ YAP
  Future<User?> signIn(String email, String password) async {
    var user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    KullaniciId isimId = Get.put(KullaniciId());
    isimId.isimid.value = user.user!.uid;
    print(user.user!.uid);
    return user.user;
  }

  // ÇIKIŞ YAP
  signOut() async {
    return await _auth.signOut();
  }

  // KAYIT OL
  Future<User?> createPerson(String name, String email, String password) async {
    var userr = await _auth
        .createUserWithEmailAndPassword(email: email.trim(), password: password)
        .catchError((e) => print(e));

    User? user = userr.user;
    await user!.updateDisplayName(name);
    await user.reload();
    user = _auth.currentUser;

    print(_auth.currentUser!.uid);
    FirebaseFirestore.instance
        .collection("register")
        .doc(_auth.currentUser!.uid)
        .set({
      "name": name,
      "mail": email,
      "password": password,
      "id": user!.uid
    }).catchError((error) => print(error));

    return userr.user;
  }
}
