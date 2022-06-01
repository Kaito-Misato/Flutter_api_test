// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class ChatMessage {
//   int? id;
//   int? conversationId;
//   String? messageContent;
//   File? imageContent;
//   int userId;
//   String contentType;

//   ChatMessage({
//     this.id,
//     this.conversationId,
//     this.messageContent,
//     this.imageContent,
//     required this.userId,
//     required this.contentType,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'conversationId': conversationId,
//       'messageContent': messageContent,
//       'imageContent': imageContent,
//       'userId': userId,
//       'contentType': contentType,
//     };
//   }

//   @override
//   String toString() {
//     return 'ChatMessage{id: $id, conversationId: $conversationId, messageContent: $messageContent, imageContent: $imageContent, userId: $userId, contentType: $contentType,}';
//   }

//   static Future<Database> get database async {
//     final Future<Database> _database = openDatabase(
//       join(await getDatabasesPath(), 'chatdata.db'),
//       onCreate: (db, version) async {
//         await db.execute(
//           'CREATE TABLE chats(id INTEGER PRIMARY KEY AUTOINCREMENT, conversation_id INTEGER, message_content TEXT, image_content BLOB, user_id INTEGER, content_type TEXT)',
//         );
//         await db.execute(
//           'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, icon TEXT, last_message TEXT)',
//         );
//         await db.execute(
//           'CREATE TABLE conversations(id INTEGER PRIMARY KEY, user_id INTEGER, user_name TEXT, user_icon TEXT)',
//         );
//         await db.execute(
//           'CREATE TABLE current(id INTEGER)',
//         );
//         await db.rawInsert(
//           'INSERT INTO current(id)VALUES(?)',
//           [1],
//         );
//       },
//       version: 1,
//     );
//     return _database;
//   }

//   static Future<List<ChatMessage>> getChatMessages(int conversationId) async {
//     final Database db = await database;
//     List<Map<String, dynamic>> messages = await db.rawQuery(
//       'SELECT * FROM chats WHERE conversation_id = ?',
//       [conversationId],
//     );
//     return List.generate(messages.length, (i) {
//       return ChatMessage(
//         id: messages[i]['id'],
//         conversationId: messages[i]['conversation_id'],
//         messageContent: messages[i]['message_content'],
//         imageContent: messages[i]['image_content'],
//         userId: messages[i]['user_id'],
//         contentType: messages[i]['content_type'],
//       );
//     });
//   }

//   Future<void> insertChat(chat) async {
//     final Database db = await database;
//     await db.rawInsert(
//       'INSERT INTO chats(conversation_id, message_content, image_content, user_id, content_type)VALUES(?, ?, ?, ?, ?)',
//       [
//         chat.conversationId,
//         chat.messageContent,
//         chat.imageContent,
//         chat.userId,
//         chat.contentType,
//       ],
//     );
//   }
// }

// class ChatView extends StatefulWidget {
//   int conversationId;
//   int currentId;
//   ChatView(this.conversationId, this.currentId);

//   @override
//   _ChatViewState createState() => _ChatViewState(conversationId, currentId);
// }

// class _ChatViewState extends State<ChatView> {
//   _ChatViewState(this.conversationId, this.currentId) {
//     ChatMessage.database;
//   }
//   TextEditingController inputMessage = TextEditingController();
//   ScrollController chatController = ScrollController();

//   final int senderUserId = 1;
//   final int receiverUserId = 2;
//   String echolaliaMessage = '';
//   bool onTapCustomMenu = false;
//   bool messageContentCheck = true;
//   List<ChatMessage> chats = [];
//   List<File> _images = [];
//   File? _image;
//   final picker = ImagePicker();
//   int conversationId;
//   int currentId;

//   Future<void> initializeChatMessages() async {
//     chats = await ChatMessage.getChatMessages(conversationId);
//     scrollToBottom();
//   }

//   static Future get localPath async {
//     final directory = await getApplicationDocumentsDirectory();
//     return directory.path;
//   }

//   static Future LocalImagesave(File image) async {
//     final path = await localPath;
//     final imagePath = '$path/image.png';
//     File imageFile = File(imagePath);
//     var savedFile = await imageFile.writeAsBytes(await image.readAsBytesSync());
//     return savedFile;
//   }

//   sendImage() {
//     setState(() async {
//       echolaliaMessage = inputMessage.text;
//       for (int index = 0; index < _images.length; index++) {
//         var chat = ChatMessage(
//           conversationId: 1,
//           imageContent: _images[index],
//           userId: senderUserId,
//           contentType: "image",
//         );
//         await chat.insertChat(chat);
//       }
//       _images.clear();
//       _image = null;
//       inputMessage.clear();
//       closeCustomMenu();
//       messageContentCheck = true;
//     });
//   }

//   sendMessage() {
//     setState(() async {
//       echolaliaMessage = inputMessage.text;
//       var chat = ChatMessage(
//         conversationId: conversationId,
//         messageContent: inputMessage.text,
//         userId: senderUserId,
//         contentType: 'text',
//       );
//       await chat.insertChat(chat);
//       _image = null;
//       inputMessage.clear();
//       closeCustomMenu();
//       messageContentCheck = true;
//     });
//   }

//   openCustomMenu() {}

//   closeCustomMenu() {
//     setState(() {
//       onTapCustomMenu = false;
//     });
//   }

//   void chatMessageInput(String message) {
//     if (message.isEmpty) {
//       setState(() {
//         messageContentCheck = true;
//       });
//     } else {
//       setState(() {
//         messageContentCheck = false;
//       });
//     }
//   }

//   Future getImageFromCamera() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);

//     setState(() {
//       if (pickedFile == null) {
//         return null;
//       } else {
//         _image = File(pickedFile.path);
//         _images.add(File(pickedFile.path));
//       }
//       messageContentCheck = false;
//     });
//   }

//   Future getImageFromGallery() async {
//     final pickedFile = await picker.pickMultiImage();

//     setState(() {
//       if (pickedFile == null) {
//         return null;
//       } else {
//         _image = File(pickedFile.first.path);
//         for (int index = 0; index < pickedFile.length; index++) {
//           _images.add(File(pickedFile[index].path));
//         }
//       }
//       messageContentCheck = false;
//     });
//   }

//   scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       chatController.jumpTo(
//         chatController.position.maxScrollExtent,
//       );
//     });
//     return () {
//       chatController.dispose();
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         flexibleSpace: SafeArea(
//           child: Container(
//             padding: EdgeInsets.only(right: 16),
//             child: Row(
//               children: <Widget>[
//                 IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: Icon(
//                     Icons.arrow_back_ios,
//                     color: Colors.black,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 2,
//                 ),
//                 CircleAvatar(
//                   backgroundImage: NetworkImage(
//                       "https://randomuser.me/api/portraits/men/6.jpg"),
//                   maxRadius: 20,
//                 ),
//                 SizedBox(
//                   width: 12,
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         "Kriss Benwat",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w600),
//                       ),
//                       SizedBox(
//                         height: 6,
//                       ),
//                       Text(
//                         "Online",
//                         style: TextStyle(
//                             color: Colors.grey.shade600, fontSize: 13),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(
//                   Icons.settings,
//                   color: Colors.black54,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: <Widget>[
//           FutureBuilder(
//               future: initializeChatMessages(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//                 return Expanded(
//                   child: ListView.builder(
//                     controller: chatController,
//                     itemCount: chats.length,
//                     shrinkWrap: true,
//                     padding: EdgeInsets.only(top: 10, bottom: 10),
//                     itemBuilder: (context, index) {
//                       return Container(
//                         padding: EdgeInsets.only(
//                             left: 14, right: 14, top: 10, bottom: 10),
//                         child: Align(
//                           alignment: (chats[index].userId != currentId
//                               ? Alignment.topLeft
//                               : Alignment.topRight),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               color: (chats[index].userId != currentId
//                                   ? Colors.grey.shade200
//                                   : Colors.blue[200]),
//                             ),
//                             padding: EdgeInsets.all(16),
//                             child: (chats[index].imageContent == null
//                                 ? Text(
//                                     chats[index].messageContent.toString(),
//                                     style: TextStyle(fontSize: 15),
//                                   )
//                                 : Image.file(
//                                     chats[index].imageContent!,
//                                     width: 150,
//                                     height: 150,
//                                   )),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               }),
//           Align(
//             alignment: Alignment.bottomLeft,
//             child: Container(
//               padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
//               height: (onTapCustomMenu) ? 300 : 80,
//               width: double.infinity,
//               color: Colors.white,
//               child: Column(
//                 children: <Widget>[
//                   Row(
//                     children: <Widget>[
//                       GestureDetector(
//                         onTap: () {
//                           (onTapCustomMenu)
//                               ? closeCustomMenu()
//                               : setState(() {
//                                   onTapCustomMenu = true;
//                                   FocusScope.of(context).unfocus();
//                                 });
//                         },
//                         child: Container(
//                           height: 30,
//                           width: 30,
//                           decoration: BoxDecoration(
//                             color: Colors.lightBlue,
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           child: Icon(
//                             (onTapCustomMenu) ? Icons.arrow_back : Icons.add,
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 15),
//                       Expanded(
//                         child: TextField(
//                           controller: inputMessage,
//                           onChanged: chatMessageInput,
//                           decoration: InputDecoration(
//                               hintText: "Write message...",
//                               hintStyle: TextStyle(color: Colors.black54),
//                               border: InputBorder.none),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 15,
//                       ),
//                       FloatingActionButton(
//                         onPressed: messageContentCheck
//                             ? null
//                             : () {
//                                 if (_images.isEmpty) {
//                                   setState(() {
//                                     sendMessage();
//                                     FocusScope.of(context).unfocus();
//                                     if (chatController.hasClients) {
//                                       chatController.jumpTo(chatController
//                                           .position.maxScrollExtent);
//                                     }
//                                   });
//                                 } else {
//                                   sendImage();
//                                 }
//                               },
//                         child: Icon(
//                           Icons.send,
//                           color: Colors.white,
//                           size: 18,
//                         ),
//                         backgroundColor: Colors.blue,
//                         elevation: 0,
//                       ),
//                     ],
//                   ),
//                   (onTapCustomMenu)
//                       ? Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             IconButton(
//                               padding: EdgeInsets.only(top: 60),
//                               iconSize: 75,
//                               onPressed: getImageFromCamera,
//                               icon: Icon(
//                                 Icons.add_a_photo,
//                               ),
//                             ),
//                             IconButton(
//                               padding: EdgeInsets.only(top: 60),
//                               iconSize: 75,
//                               onPressed: getImageFromGallery,
//                               icon: Icon(
//                                 Icons.add_photo_alternate,
//                               ),
//                             ),
//                           ],
//                         )
//                       : SizedBox.shrink(),
//                   _image != null
//                       ? Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             for (int i = 0; i < _images.length; i++)
//                               Image.file(
//                                 _images[i],
//                                 width: 80,
//                                 height: 80,
//                               ),
//                           ],
//                         )
//                       : Container(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
