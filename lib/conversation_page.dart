import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:bubble/bubble.dart';
import 'package:whatsapp/kontrol/controller.dart';
import 'package:get/get.dart';

class ConversationPage extends StatefulWidget {
  final String conversationId;
  const ConversationPage({Key? key, required this.conversationId})
      : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _editingController = TextEditingController();
  CollectionReference? _ref;
  @override
  void initState() {
    _ref = FirebaseFirestore.instance
        .collection("conversations/${widget.conversationId}/messages");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    KullaniciId isimId = Get.find();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://pp.userapi.com/c836724/v836724266/20b8b/_M9V5Npgiso.jpg"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Oğuzhan Erbil"),
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(onTap: () {}, child: Icon(Icons.camera_alt)),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(onTap: () {}, child: Icon(Icons.phone)),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(onTap: () {}, child: Icon(Icons.more_vert)),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    "https://64.media.tumblr.com/4c7a2a50450c8c525d0b6fe751d14ba1/tumblr_pszjio5jpT1sagxrn_1280.png"))),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: _ref!.orderBy("timeStamp").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return !snapshot.hasData
                        ? CircularProgressIndicator()
                        : ListView(
                            physics: BouncingScrollPhysics(),
                            children: snapshot.data!.docs.map<Widget>(
                              (DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data() as Map<String, dynamic>;
                                return ListTile(
                                  title: Align(
                                    alignment: isimId.isimid.value.toString() !=
                                            document["senderid"]
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    child: isimId.isimid.value.toString() ==
                                            document["senderid"]
                                        ? Bubble(
                                            margin: BubbleEdges.only(top: 10),
                                            nip: BubbleNip.rightTop,
                                            color: Color.fromRGBO(
                                                225, 255, 199, 1.0),
                                            child: Text(document["message"],
                                                textAlign: TextAlign.right),
                                          )
                                        : Bubble(
                                            margin: BubbleEdges.only(top: 10),
                                            nip: BubbleNip.leftTop,
                                            child: Text(
                                              document["message"],
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ).toList(),
                          );
                  }),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(25),
                            right: Radius.circular(25))),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Icon(
                              Icons.tag_faces,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _editingController,
                            decoration: InputDecoration(
                                hintText: "Mesaj yaz",
                                border: InputBorder.none),
                          ),
                        ),
                        InkWell(
                          child: Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () async {
                      await _ref!.add({
                        "senderid": isimId.isimid.value.toString(),
                        "message": _editingController.text,
                        "timeStamp": DateTime.now()
                      });
                      _editingController.text = "";
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
