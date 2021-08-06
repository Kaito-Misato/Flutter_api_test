import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_test/chat_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

TextEditingController myController = TextEditingController();

class _ChatState extends State<Chat> {
  List<ChatUsers> chatUsers = [
    ChatUsers(
        text: "Jane Russel",
        secondaryText: "Awesome Setup",
        image: "https://randomuser.me/api/portraits/men/6.jpg",
        time: "Now"),
    ChatUsers(
        text: "Glady's Murphy",
        secondaryText: "That's Great",
        image: "https://randomuser.me/api/portraits/men/6.jpg",
        time: "Yesterday"),
    ChatUsers(
        text: "Jorge Henry",
        secondaryText: "Hey where are you?",
        image: "https://randomuser.me/api/portraits/men/6.jpg",
        time: "31 Mar"),
    ChatUsers(
        text: "Philip Fox",
        secondaryText: "Busy! Call me in 20 mins",
        image: "https://randomuser.me/api/portraits/men/6.jpg",
        time: "28 Mar"),
    ChatUsers(
        text: "Debra Hawkins",
        secondaryText: "Thankyou, It's awesome",
        image: "https://randomuser.me/api/portraits/men/6.jpg",
        time: "23 Mar"),
    ChatUsers(
        text: "Jacob Pena",
        secondaryText: "will update you in evening",
        image: "https://randomuser.me/api/portraits/men/6.jpg",
        time: "17 Mar"),
    ChatUsers(
        text: "Andrey Jones",
        secondaryText: "Can you please share the file?",
        image: "https://randomuser.me/api/portraits/men/6.jpg",
        time: "24 Feb"),
    ChatUsers(
        text: "John Wick",
        secondaryText: "How are you?",
        image: "https://randomuser.me/api/portraits/men/6.jpg",
        time: "18 Feb"),
    // ChatUsers(
    //     text: "unknown",
    //     secondaryText: "removed message",
    //     image: "https://randomuser.me/api/portraits/men/6.jpg",
    //     time: "1 jan"),
  ];

  List<ChatUsers> searchResults = [];

  @override
  void initState() {
    searchResults.addAll(chatUsers);
    super.initState();
  }

  void search(String query) {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
        searchResults.addAll(chatUsers);
      });
      return;
    }

    final List<ChatUsers> hitItems = chatUsers.where((element) {
      return element.text.toLowerCase().contains(query.toLowerCase());
    }).toList();

    searchResults.clear();

    setState(() {
      searchResults = hitItems;
    });
  }

  void _onrefresh() {}

  // @override
  // void dispose() {
  //   myController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Conversations",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50],
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            color: Colors.pink,
                            size: 20,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "Add New",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                controller: myController,
                onChanged: search,
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.red.shade100)),
                ),
              ),
            ),
            RefreshIndicator(
              onRefresh: () async {},
              child: ListView.builder(
                itemCount: searchResults.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 16),
                // physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _ConversationListState(
                    text: searchResults[index].text,
                    secondaryText: searchResults[index].secondaryText,
                    image: searchResults[index].image,
                    time: searchResults[index].time,
                    isMessageRead: (index >= 0 && index <= 1) ? true : false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HighlightedText extends StatelessWidget {
  HighlightedText({
    required this.wholeString,
    required this.highlightedString,
    this.defaultStyle = const TextStyle(color: Colors.black),
    this.highlightStyle = const TextStyle(color: Colors.blue),
  });

  final String wholeString;
  final String highlightedString;
  final TextStyle defaultStyle;
  final TextStyle highlightStyle;

  int get _highlightStart {
    return wholeString.toLowerCase().indexOf(highlightedString.toLowerCase());
  }

  int get _highlightEnd => _highlightStart + highlightedString.length;

  @override
  Widget build(BuildContext context) {
    if (_highlightStart == -1) {
      return Text(wholeString, style: defaultStyle);
    }
    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: [
          TextSpan(
            text: wholeString.substring(
              0,
              _highlightStart,
            ),
          ),
          TextSpan(
            text: wholeString.substring(_highlightStart, _highlightEnd),
            style: highlightStyle,
          ),
          TextSpan(
            text: wholeString.substring(_highlightEnd),
          ),
        ],
      ),
    );
  }
}

class ChatUsers {
  String text;
  String secondaryText;
  String image;
  String time;
  ChatUsers({
    required this.text,
    required this.secondaryText,
    required this.image,
    required this.time,
  });
}

// class ConversationList extends StatefulWidget {
//   String text;
//   String secondaryText;
//   String image;
//   String time;
//   bool isMessageRead;
//   ConversationList(
//       {required this.text,
//       required this.secondaryText,
//       required this.image,
//       required this.time,
//       required this.isMessageRead});
//   @override
//   _ConversationListState createState() => _ConversationListState();
// }

class _ConversationListState extends HookWidget {
  String text;
  String secondaryText;
  String image;
  String time;
  bool isMessageRead;
  _ConversationListState(
      {required this.text,
      required this.secondaryText,
      required this.image,
      required this.time,
      required this.isMessageRead});

  @override
  Widget build(BuildContext context) {
    // _ChatState myController = _ChatState();

    // final useQueryState = useProvider(queryState);

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatView();
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(image),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          HighlightedText(
                            wholeString: text,
                            highlightedString: myController.text,
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            secondaryText,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: isMessageRead
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      isMessageRead ? FontWeight.bold : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
