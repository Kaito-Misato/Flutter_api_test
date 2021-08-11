import 'dart:io';
// import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ChatMessage {
  int id;
  String? messageContent;
  File? imageContent;
  int userId;
  String contentType;

  ChatMessage({
    required this.id,
    this.messageContent,
    this.imageContent,
    required this.userId,
    required this.contentType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'messageContent': messageContent,
      'imageContent': imageContent,
      'userId': userId,
      'contentType': contentType,
    };
  }

  @override
  String toString() {
    // id: $id,
    return 'ChatMessage{messageContent: $messageContent, imageContent: $imageContent, userId: $userId, contentType: $contentType,}';
  }

  static Future<Database> get database async {
    final Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'chatdata.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE chats(id INTEGER PRIMARY KEY, message_content TEXT, image_content TEXT, user_id INTEGER, content_type TEXT)',
        );
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT)',
        );
      },
      version: 1,
    );
    return _database;
  }
}

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

// ChatMessage messages = ChatMessage();

class _ChatViewState extends State<ChatView> {
  _ChatViewState() {
    ChatMessage.database;
  }
  TextEditingController inputMessage = TextEditingController();
  // String
  int contentGlobalId = 1;
  String echolaliaMessage = '';
  String echolaliaImage = '';
  bool onTapCustomMenu = false;
  bool messageContentCheck = true;
  List<ChatMessage> chats = [];
  List<File> _images = [];
  File? _image;
  final picker = ImagePicker();

  Future<List<ChatMessage>> getChatMessage(Database db) async {
    List<Map> messages = await db.query("chats");
    return messages.map((Map m) {
      int id = m["id"];
      String messageContent = m["message_content"];
      File imageContent = m["image_content"];
      int userId = m["user_id"];
      String contentType = m["content_type"];
      return ChatMessage(
        id: id,
        messageContent: messageContent,
        imageContent: imageContent,
        userId: userId,
        contentType: contentType,
      );
    }).toList();
  }

  static Future get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future saveLocalImage(File image) async {
    final path = await localPath;
    final imagePath = '$path/image.png';
    File imageFile = File(imagePath);
    var savedFile = await imageFile.writeAsBytes(await image.readAsBytesSync());
    return savedFile;
  }

  // sendMessage() {
  //   setState(() {
  //     closeCustomMenu();
  //     echolalia = inputMessage.text;
  //     messages.add(
  //       ChatMessage(messageContent: inputMessage.text, messageType: "sender"),
  //     );
  //     inputMessage.clear();
  //   });
  // }

  sendImage() {
    setState(() {
      echolaliaMessage = inputMessage.text;
      for (int index = 0; index < _images.length; index++) {
        contentGlobalId++;
        chats.add(
          ChatMessage(
            id: contentGlobalId,
            // messageContent: inputMessage.text,
            imageContent: _images[index],
            userId: 1,
            contentType: "image",
          ),
        );
      }
      _images.clear();
      _image = null;
      inputMessage.clear();
      closeCustomMenu();
      messageContentCheck = true;
    });
  }

  sendMessage() {
    setState(() {
      contentGlobalId++;
      echolaliaMessage = inputMessage.text;
      chats.add(
        ChatMessage(
          id: contentGlobalId,
          messageContent: inputMessage.text,
          // imageContent: _image,
          userId: 1,
          contentType: "text",
        ),
      );
      _image = null;
      inputMessage.clear();
      closeCustomMenu();
      messageContentCheck = true;
    });
  }

  receiveMessage() {
    setState(() {
      contentGlobalId++;
      chats.add(
        ChatMessage(
          id: contentGlobalId,
          messageContent: echolaliaMessage,
          userId: 2,
          contentType: "text",
        ),
      );
    });
  }

  // receiveImage() {
  //   setState(() {
  //     echolaliaImage = inputMessage.text;
  //     messages.add(
  //       ChatMessage(messageContent: inputMessage.text, messageType: "receiver"),
  //     );
  //     inputMessage.clear();
  //   });
  // }

  openCustomMenu() {}

  closeCustomMenu() {
    setState(() {
      onTapCustomMenu = false;
    });
  }

  void chatMessageInput(String message) {
    if (message.isEmpty) {
      setState(() {
        messageContentCheck = true;
      });
    } else {
      setState(() {
        messageContentCheck = false;
      });
    }
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile == null) {
        return null;
      } else {
        _image = File(pickedFile.path);
        _images.add(File(pickedFile.path));
      }
      messageContentCheck = false;
    });
  }

  Future getImageFromGallery() async {
    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final pickedFile = await picker.pickMultiImage();

    setState(() {
      if (pickedFile == null) {
        return null;
      } else {
        _image = File(pickedFile.first.path);
        for (int index = 0; index < pickedFile.length; index++) {
          _images.add(File(pickedFile[index].path));
        }
      }
      messageContentCheck = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/men/6.jpg"),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Kriss Benwat",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: chats.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            // physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (chats[index].userId == 2
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (chats[index].userId == 2
                          ? Colors.grey.shade200
                          : Colors.blue[200]),
                    ),
                    padding: EdgeInsets.all(16),
                    child: (chats[index].imageContent == null
                        ? Text(
                            chats[index].messageContent.toString(),
                            style: TextStyle(fontSize: 15),
                          )
                        : Image.file(
                            chats[index].imageContent!,
                            width: 150,
                            height: 150,
                          )),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: (onTapCustomMenu) ? 300 : 80,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          (onTapCustomMenu)
                              ? closeCustomMenu()
                              : setState(() {
                                  onTapCustomMenu = true;
                                  FocusScope.of(context).unfocus();
                                });
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            (onTapCustomMenu) ? Icons.arrow_back : Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: TextField(
                          controller: inputMessage,
                          onChanged: chatMessageInput,
                          decoration: InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      FloatingActionButton(
                        onPressed: messageContentCheck
                            ? null
                            : () {
                                if (_images.isEmpty) {
                                  sendMessage();
                                } else {
                                  sendImage();
                                }
                                // messages.last.messageType == "sender image"
                                //     ?

                                //     :
                                // sendMessage();
                                RegExp regExp = RegExp(r'([0-9]{1,2})');
                                final results = regExp
                                    .allMatches(echolaliaMessage)
                                    .map((match) => match.group(0))
                                    .toList();
                                if (results.length != 0) {
                                  Future.delayed(Duration(
                                      seconds: int.parse(
                                    results.first ?? '1',
                                  ))).then((_) => receiveMessage());
                                } else if (echolaliaMessage.isEmpty) {
                                  return;
                                } else {
                                  Future.delayed(
                                    Duration(seconds: 1),
                                  ).then((_) => receiveMessage());
                                }
                              },
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        backgroundColor: Colors.blue,
                        elevation: 0,
                      ),
                    ],
                  ),
                  (onTapCustomMenu)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              padding: EdgeInsets.only(top: 60),
                              iconSize: 75,
                              onPressed: getImageFromCamera,
                              icon: Icon(
                                Icons.add_a_photo,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.only(top: 60),
                              iconSize: 75,
                              onPressed: getImageFromGallery,
                              icon: Icon(
                                Icons.add_photo_alternate,
                              ),
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                  _image != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            for (int i = 0; i < _images.length; i++)
                              Image.file(
                                _images[i],
                                width: 80,
                                height: 80,
                              ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
