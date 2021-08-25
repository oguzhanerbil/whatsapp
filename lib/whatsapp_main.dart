import 'package:flutter/material.dart';
import 'package:whatsapp/searchPage/Search.dart';
import 'sayfalar/whatsapp_camera.dart';
import 'sayfalar/whatsapp_chats.dart';
import 'sayfalar/whatsapp_status.dart';
import 'sayfalar/whatsapp_calls.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class whatsapp extends StatefulWidget {
  const whatsapp({Key? key}) : super(key: key);

  @override
  _whatsappState createState() => _whatsappState();
}

class _whatsappState extends State<whatsapp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showMessage = true;
  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      _showMessage = _tabController.index != 0;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  //backgroundColor: Color(0xff075e54),
                  title: Text("Oğuzname"),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContactsPage()));
                        },
                        icon: Icon(Icons.search)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
                  ],
                )
              ];
            },
            body: Column(
              children: [
                TabBar(
                    isScrollable: true,
                    physics: BouncingScrollPhysics(),
                    controller: _tabController,
                    indicatorColor: Colors.white,
                    labelPadding: EdgeInsets.symmetric(horizontal: 23.0),
                    tabs: [
                      Tab(
                        icon: Icon(Icons.camera_alt),
                      ),
                      Tab(
                        text: "SOHBETLER",
                      ),
                      Tab(
                        text: "DURUM",
                      ),
                      Tab(
                        text: "ARAMALAR",
                      ),
                    ]),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: TabBarView(
                      controller: _tabController,
                      physics: BouncingScrollPhysics(),
                      children: [
                        CameraPage(),
                        ChatsPage(),
                        StatusPage(),
                        CallsPage(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _showMessage == true
          ? FloatingActionButton(
              onPressed: () {},
              child: Icon(
                Icons.message,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
