import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../conversation_page.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/kontrol/controller.dart';
import 'package:get/get.dart';

//final String userid = "2HAOkyX80ffumc7iuYyzadECRcC3";

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    KullaniciId isimId = Get.find();
    print(isimId.isimid.value.toString());
    Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('conversations')
        .where("members", arrayContains: isimId.isimid.value.toString())
        .snapshots();
    return StreamBuilder(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text(
            "Error: ${snapshot.hasError}",
            style: TextStyle(color: Colors.green, fontSize: 24),
          ));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }
        return ListView(
          physics: BouncingScrollPhysics(),
          children: snapshot.data!.docs.map((DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return ListTile(
              title: Text("Oğuzhan"),
              subtitle: Text(data["displayMessage"]),
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage("http://placekitten.com/g/200/300"),
              ),
              trailing: Column(
                children: [
                  Text("19:30"),
                  Container(
                    width: 20,
                    height: 20,
                    margin: EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).accentColor),
                    child: Center(
                      child: Text(
                        "16",
                        textScaleFactor: 0.8,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              onTap: () {
                print(doc.id);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConversationPage(
                              conversationId: doc.id,
                            )));
              },
            );
          }).toList(),
        );
      },
    );
  }
}
