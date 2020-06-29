import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enterMessage = '';
  final _messageController = TextEditingController();

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();
    Firestore.instance.collection('chat')
      ..add({
        'text': _enterMessage,
        'createAt': Timestamp.now(),
        'userId': user.uid,
        'username': userData['userId'],
        'userimage': userData['image_url'],
      });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message....',
              ),
              onChanged: (value) {
                setState(() {
                  _enterMessage = value;
                });
              },
            ),
          ),
          FlatButton(
            child: Icon(
              Icons.send,
            ),
            onPressed: _enterMessage.trim().isEmpty ? null : sendMessage,
          ),
        ],
      ),
    );
  }
}
