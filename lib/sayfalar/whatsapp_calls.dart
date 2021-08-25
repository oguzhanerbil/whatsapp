import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/kontrol/controller.dart';
import 'package:get/get.dart';

class CallsPage extends StatefulWidget {
  CallsPage({Key? key}) : super(key: key);

  @override
  State<CallsPage> createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage> {
  TextEditingController editingController = TextEditingController();

  CollectionReference? _ref;

  @override
  void initState() {
    _ref = FirebaseFirestore.instance.collection("register/");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    KullaniciId isimId = Get.find();
    Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('conversations')
        .where("members", arrayContains: isimId.isimid.value.toString())
        .snapshots();
    return Scaffold(body: Container());
  }
}
