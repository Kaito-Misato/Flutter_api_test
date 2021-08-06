import 'dart:io';
// import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ChatMessage {
  String messageContent;
  String messageType;
  File? imageContent;
  ChatMessage(
      {required this.messageContent,
      required this.messageType,
      this.imageContent});
}

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

// ChatMessage messages = ChatMessage();

class _ChatViewState extends State<ChatView> {
  TextEditingController inputMessage = TextEditingController();
  // String

  String echolalia = '';
  String echolaliaImage = '';
  bool onTapCustomMenu = false;

  List<ChatMessage> messages = [
    // ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
    // ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
    // ChatMessage(
    //     messageContent: "Hey Kriss, I am doing fine dude. wbu?",
    //     messageType: "sender"),
    // ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    // ChatMessage(
    //     messageContent: "Is there any thing wrong?", messageType: "sender"),
  ];

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

  sendMessage() {
    setState(() {
      closeCustomMenu();
      echolalia = inputMessage.text;
      messages.add(
        ChatMessage(messageContent: inputMessage.text, messageType: "sender"),
      );
      inputMessage.clear();
    });
  }

  sendImage() {
    setState(() {
      echolaliaImage = inputMessage.text;
      messages.add(
        ChatMessage(
            messageContent: inputMessage.text,
            messageType: "sender",
            imageContent: _image),
      );
      _image = null;
      inputMessage.clear();
      closeCustomMenu();
    });
  }

  receiveMessage() {
    setState(() {
      messages.add(
        ChatMessage(messageContent: echolalia, messageType: "receiver"),
      );
    });
  }

  receiveImage() {
    setState(() {
      echolaliaImage = inputMessage.text;
      messages.add(
        ChatMessage(messageContent: inputMessage.text, messageType: "receiver"),
      );
      inputMessage.clear();
    });
  }

  openCustomMenu() {
    setState(() {
      onTapCustomMenu = true;
      FocusScope.of(context).unfocus();
    });
  }

  closeCustomMenu() {
    setState(() {
      onTapCustomMenu = false;
    });
  }

  List<File> _images = [];
  File? _image;
  final picker = ImagePicker();

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile == null) {
        return null;
      } else {
        _image = File(pickedFile.path);
        _images.add(File(pickedFile.path));
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile == null) {
        return null;
      } else {
        _image = File(pickedFile.path);
        _images.add(File(pickedFile.path));
      }
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
      body: Stack(children: <Widget>[
        ListView.builder(
          itemCount: messages.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          // physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              padding:
                  EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
              child: Align(
                alignment: (messages[index].messageType == "receiver" ||
                        messages[index].messageType == "receiver image"
                    ? Alignment.topLeft
                    : Alignment.topRight),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: (messages[index].messageType == "receiver" ||
                            messages[index].messageType == "receiver image"
                        ? Colors.grey.shade200
                        : Colors.blue[200]),
                  ),
                  padding: EdgeInsets.all(16),
                  child: (messages[index].imageContent == null
                      ? Text(
                          messages[index].messageContent,
                          style: TextStyle(fontSize: 15),
                        )
                      : Image.file(
                          messages[index].imageContent!,
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
                              : openCustomMenu();
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
                        onPressed: () {
                          // messages.last.messageType == "sender image"
                          //     ?
                          sendImage();
                          //     :
                          // sendMessage();
                          RegExp regExp = RegExp(r'([0-9]{1,2})');
                          final results = regExp
                              .allMatches(echolalia)
                              .map((match) => match.group(0))
                              .toList();
                          if (results.length != 0) {
                            Future.delayed(Duration(
                                seconds: int.parse(
                              results.first ?? '1',
                            ))).then((_) => receiveMessage());
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
                      ? Image.file(
                          _image!,
                          width: 80,
                          height: 80,
                        )
                      : Container(),
                ],
              )),
        )
      ]),
    );
  }
}
