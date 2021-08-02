// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Search Items',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const SearchPage(),
//     );
//   }
// }

// class SearchPage extends StatefulWidget {
//   const SearchPage({Key key}) : super(key: key);

//   @override
//   _SearchPageState createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   TextEditingController controller;
//   bool isCaseSensitive = false;

//   final List<String> searchTargets =
//       List.generate(10, (index) => 'Something ${index + 1}');

//   List<String> searchResults = [];

//   void search(String query, {bool isCaseSensitive = false}) {
//     if (query.isEmpty) {
//       setState(() {
//         searchResults.clear();
//       });
//       return;
//     }

//     final List<String> hitItems = searchTargets.where((element) {
//       if (isCaseSensitive) {
//         return element.contains(query);
//       }
//       return element.toLowerCase().contains(query.toLowerCase());
//     }).toList();

//     setState(() {
//       searchResults = hitItems;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     controller = TextEditingController();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     controller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Search Items'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             SwitchListTile(
//               title: const Text('Case Sensitive'),
//               value: isCaseSensitive,
//               onChanged: (bool newVal) {
//                 setState(() {
//                   isCaseSensitive = newVal;
//                 });
//                 search(controller.text, isCaseSensitive: newVal);
//               },
//             ),
//             TextField(
//               controller: controller,
//               decoration: InputDecoration(hintText: 'Enter keyword'),
//               onChanged: (String val) {
//                 search(val, isCaseSensitive: isCaseSensitive);
//               },
//             ),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: searchResults.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return ListTile(
//                   title: HighlightedText(
//                     wholeString: searchResults[index],
//                     highlightedString: controller.text,
//                     isCaseSensitive: isCaseSensitive,
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class HighlightedText extends StatelessWidget {
//   HighlightedText({
//     @required this.wholeString,
//     @required this.highlightedString,
//     this.defaultStyle = const TextStyle(color: Colors.black),
//     this.highlightStyle = const TextStyle(color: Colors.blue),
//     this.isCaseSensitive = false,
//   });

//   final String wholeString;
//   final String highlightedString;
//   final TextStyle defaultStyle;
//   final TextStyle highlightStyle;
//   final bool isCaseSensitive;

//   int get _highlightStart {
//     if (isCaseSensitive) {
//       return wholeString.indexOf(highlightedString);
//     }
//     return wholeString.toLowerCase().indexOf(highlightedString.toLowerCase());
//   }

//   int get _highlightEnd => _highlightStart + highlightedString.length;

//   @override
//   Widget build(BuildContext context) {
//     if (_highlightStart == -1) {
//       return Text(wholeString, style: defaultStyle);
//     }
//     return RichText(
//       text: TextSpan(
//         style: defaultStyle,
//         children: [
//           TextSpan(text: wholeString.substring(0, _highlightStart)),
//           TextSpan(
//             text: wholeString.substring(_highlightStart, _highlightEnd),
//             style: highlightStyle,
//           ),
//           TextSpan(text: wholeString.substring(_highlightEnd))
//         ],
//       ),
//     );
//   }
// }
