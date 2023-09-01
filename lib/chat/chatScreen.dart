import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../backgrounds.dart';

class ChatPage extends StatefulWidget {
  static const String routename = 'chat';
  final DocumentSnapshot selectedUser;

  ChatPage({required this.selectedUser});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String uid;
  late String chatId;

  @override
  void initState() {
    super.initState();
    uid = auth.currentUser!.uid;
    chatId = _getChatId(uid, widget.selectedUser['uid']);
  }

  String _getChatId(String currentUserUid, String selectedUserUid) {
    // Check that the UIDs are not null or empty
    if (currentUserUid == null || currentUserUid.isEmpty) {
      throw ArgumentError('currentUserUid cannot be null or empty');
    }

    if (selectedUserUid == null || selectedUserUid.isEmpty) {
      throw ArgumentError('selectedUserUid cannot be null or empty');
    }

    // Sort the UIDs to ensure that the chat ID is consistent
    // regardless of the order in which the UIDs are provided
    List<String> uids = [currentUserUid, selectedUserUid]..sort();
    String chatId = '${uids[0]}_${uids[1]}';
    uid = FirebaseAuth.instance.currentUser!.uid;

    // Print out debugging information
    print('currentUserUid: $currentUserUid');
    print('selectedUserUid: $selectedUserUid');
    print('chatId: $chatId');
    print('Selected user UID: ${widget.selectedUser.id}');
    print('Selected user ID: ${widget.selectedUser.id}');
    print('Selected user first name: ${widget.selectedUser['firstname']}');
    print('Selected user last name: ${widget.selectedUser['lastname']}');

    return chatId;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Background('assets/images/BG1.png'),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(widget.selectedUser['firstname'] +
                ' ' +
                widget.selectedUser['lastname']),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('chats')
                      .doc(chatId)
                      .collection('messages')
                      .orderBy('timestamp')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    List<QueryDocumentSnapshot> documents =
                        snapshot.data!.docs.reversed.toList();
                    return ListView.builder(
                      reverse: true,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot document = documents[index];
                        bool isSentByCurrentUser = document['sender'] ==
                            widget.selectedUser['firstname'] +
                                ' ' +
                                widget.selectedUser['lastname'];
                        return Align(
                          alignment: isSentByCurrentUser
                              ? Alignment.topRight
                              : Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Material(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                                elevation: 4,
                                color: isSentByCurrentUser
                                    ? Colors.blueGrey
                                    : Colors.grey[300],
                                child: Container(
                                  padding: EdgeInsets.all(18),
                                  child: Text(
                                    document['text'],
                                    style: TextStyle(
                                        color: isSentByCurrentUser
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                )),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(height: 2.0),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: TextField(
                          controller: _textEditingController,
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send_rounded, color: Colors.blueGrey),
                      onPressed: () async {
                        String text = _textEditingController.text.trim();
                        if (text.isNotEmpty) {
                          await firestore
                              .collection('chats')
                              .doc(chatId)
                              .collection('messages')
                              .add({
                            'text': text,
                            'sender': widget.selectedUser['firstname'] +
                                ' ' +
                                widget.selectedUser['lastname'],
                            'timestamp': FieldValue.serverTimestamp(),
                          });
                          _textEditingController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
