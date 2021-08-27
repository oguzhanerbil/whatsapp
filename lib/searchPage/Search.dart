import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/kontrol/controller.dart';
import 'package:get/get.dart';

bool isLoading = false;
final TextEditingController _search = TextEditingController();
Map<String, dynamic>? userMap;

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isFollowing = false;
  int followerCount = 0;
  int followingCount = 0;
  KullaniciId controller = Get.put(KullaniciId());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
    // getProfilePosts();
    // getFollowers();
    // getFollowing();
    // checkIfFollowing();
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await followersRef
        .doc(controller.isimid.value.toString())
        .collection('userFollowers')
        .doc(controller.profileId.value.toString())
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  getFollowers() async {
    QuerySnapshot snapshot = await followersRef
        .doc(controller.isimid.value.toString())
        .collection('userFollowers')
        .get();
    setState(() {
      followerCount = snapshot.docs.length;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .doc(controller.isimid.value.toString())
        .collection('userFollowing')
        .get();
    setState(() {
      followingCount = snapshot.docs.length;
    });
  }

/*
  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postsRef
        .document(widget.profileId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    setState(() {
      isLoading = false;
      postCount = snapshot.documents.length;
      posts = snapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
    });
  }
*/
  void setStatus(String status) async {
    await _firestore.collection('register').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });
    try {
      await firestore
          .collection("register")
          .where("name", isEqualTo: _search.text)
          .get()
          .then((value) => {
                setState(() {
                  userMap = value.docs[0].data();
                  isLoading = false;
                }),
                print(userMap)
              });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  handleUnFollowUser() {
    setState(() {
      isFollowing = false;
    });
    // delete data
    followersRef
        .doc(controller.profileId.value.toString())
        .collection("userFallowers")
        .doc(controller.isimid.value.toString())
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // delete data
    followingRef
        .doc(controller.isimid.value.toString())
        .collection("userFollowing")
        .doc(controller.profileId.value.toString())
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    activityFeedRef
        .doc(controller.profileId.value.toString())
        .collection('feedItems')
        .doc(controller.isimid.value.toString())
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  final followersRef = FirebaseFirestore.instance.collection("followers");
  final followingRef = FirebaseFirestore.instance.collection("following");
  final activityFeedRef = FirebaseFirestore.instance.collection("feed");
  handleFollowUser() {
    setState(() {
      isFollowing = true;
    });
    // Bu kullanıcının auth kullanıcısını takipçisi yap (THIR takipçi koleksiyonunu güncelle)
    followersRef
        .doc(controller.profileId.value.toString())
        .collection("userFallowers")
        .doc(controller.isimid.value.toString())
        .set({});
    // Bu kullanıcıyı aşağıdaki koleksiyonunuza koyun (aşağıdaki koleksiyonunuzu güncelleyin)
    followingRef
        .doc(controller.isimid.value.toString())
        .collection("userFollowing")
        .doc(controller.profileId.value.toString())
        .set({});

    activityFeedRef
        .doc(controller.profileId.value.toString())
        .collection('feedItems')
        .doc(controller.isimid.value.toString())
        .set({
      "type": "follow",
      "ownerId": controller.isimid.value.toString(),
      "username": controller.username.value.toString(),
      "userId": controller.isimid.value.toString(),
      "timestamp": DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print("Id " + controller.isimid.value.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kullanıcı Ara",
        ),
        actions: [
          IconButton(onPressed: onSearch, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: size.height / 20,
                    ),
                    Container(
                      height: size.height / 14,
                      width: size.width,
                      alignment: Alignment.center,
                      child: Container(
                        height: size.height / 14,
                        width: size.width / 1.15,
                        child: TextField(
                          controller: _search,
                          decoration: InputDecoration(
                            hintText: "Search",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 50,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        try {
                          onSearch();
                        } catch (e) {}
                      },
                      child: Text("Search"),
                    ),
                    SizedBox(
                      height: size.height / 30,
                    ),
                    userMap != null
                        ? ListTile(
                            /*
                            onTap: () {
                              String roomId = chatRoomId(
                                  _auth.currentUser!.displayName!,
                                  userMap!['name']);

                                Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ChatRoom(
                                    chatRoomId: roomId,
                                    userMap: userMap!,
                                  ),
                                ),
                              );
                            },*/
                            leading:
                                Icon(Icons.account_box, color: Colors.black),
                            title: Text(
                              userMap!['name'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(userMap!['mail']),
                            trailing: OutlinedButton(
                              onPressed: () {
                                controller.profileId.value = userMap!["id"];
                                controller.username.value = userMap!["name"];
                                handleFollowUser();
                              },
                              child: Text(
                                "Takip Et",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          )
                        : Container()
                    /*
                        : ListTile(
                            /*
                            onTap: () {
                              String roomId = chatRoomId(
                                  _auth.currentUser!.displayName!,
                                  userMap!['name']);

                                Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ChatRoom(
                                    chatRoomId: roomId,
                                    userMap: userMap!,
                                  ),
                                ),
                              );
                            },*/
                            leading:
                                Icon(Icons.account_box, color: Colors.black),
                            title: Text(
                              userMap!['name'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(userMap!['mail']),
                            trailing: Row(
                              children: [
                                OutlinedButton(
                                    onPressed: () {
                                      controller.profileId.value =
                                          userMap!["id"];
                                      controller.username.value =
                                          userMap!["name"];
                                      handleUnFollowUser();
                                    },
                                    child: Text("Takibi Bırak")),
                                OutlinedButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Mesaj At",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),*/
                  ],
                ),
        ],
      ),
    );
  }
}
