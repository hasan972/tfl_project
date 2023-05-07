// import 'package:flutter/material.dart';

// class TextDemoBody extends StatelessWidget {
//   const TextDemoBody(
//       {required this.start,
//       required this.filepath,
//       required this.lastLineNo,
//       required this.submitData,
//       required this.exitApp});

//   final String start;
//   final String filepath;
//   final String lastLineNo;
//   final Function submitData;
//   final Function exitApp;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           flex: 3,
//           child: Container(
//             color: Colors.grey[200],
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 16.0),
//                 SizedBox(
//                   width: 150,
//                   height: 40,
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       _SubmitData();
//                     },
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all<Color>(
//                           Colors.blueGrey), // set your desired color here
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Text(
//                           'Start',
//                           textAlign: TextAlign.center,
//                         ),
//                         SizedBox(width: 8.0),
//                         Icon(
//                           Icons.play_arrow,
//                           color: Colors.green, // set the color of the Icon
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: 150,
//                   height: 40,
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       _exitApp();
//                     },
//                     style: ButtonStyle(
//                       backgroundColor:
//                           MaterialStateProperty.all<Color>(Colors.blueGrey),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Text(
//                           'End',
//                           textAlign: TextAlign.center,
//                         ),
//                         SizedBox(width: 8.0),
//                         Icon(
//                           Icons.stop,
//                           color: Colors.red, // set the color of the Icon
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const VerticalDivider(),
//         Expanded(
//           flex: 9,
//           child: Container(
//             color: Colors.cyan[50],
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 start == 'config'
//                     ? Center(
//                         child: Text(
//                           '$filepath = $lastLineNo',
//                           style: const TextStyle(fontSize: 18),
//                         ),
//                       )
//                     : start != '' && start != 'config'
//                         ? Center(
//                             child: Text(
//                             start,
//                             style: TextStyle(fontSize: 21),
//                           ))
//                         : Container(),

//                 //CircularProgressIndicator(),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
