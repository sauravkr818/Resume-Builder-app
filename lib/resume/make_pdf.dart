// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import './resume_preview.dart';
// import 'dart:typed_data';

// class MyHomePage extends StatelessWidget {
//   final pdf = pw.Document();

//   writeOnPdf() {
//     pdf.addPage(pw.MultiPage(
//       pageFormat: PdfPageFormat.a4,
//       margin: pw.EdgeInsets.all(32),
//       build: (pw.Context context) {
//         return <pw.Widget>[
//           pw.Header(
//               level: 0,
//               child: pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   children: <pw.Widget>[
//                     pw.Text('Geeksforgeeks', textScaleFactor: 2),
//                   ])),
//           pw.Header(level: 1, text: 'What is Lorem Ipsum?'),

//           // Write All the paragraph in one line.
//           // For clear understanding
//           // here there are line breaks.
//           pw.Paragraph(
//               text:
//                   'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod'),
//           pw.Paragraph(
//               text:
//                   'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod'),
//           pw.Header(level: 1, text: 'This is Header'),
//           pw.Paragraph(
//               text:
//                   'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod'),
//           pw.Paragraph(
//               text:
//                   'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod'),
//           pw.Padding(padding: const pw.EdgeInsets.all(10)),
//           pw.Table.fromTextArray(context: context, data: const <List<String>>[
//             <String>['Year', 'Sample'],
//             <String>['SN0', 'GFG1'],
//             <String>['SN1', 'GFG2'],
//             <String>['SN2', 'GFG3'],
//             <String>['SN3', 'GFG4'],
//           ]),
//         ];
//       },
//     ));
//   }

//   Future savePdf() async {
//     //Directory documentDirectory = await getApplicationDocumentsDirectory();
//     //String documentPath = documentDirectory.path;
//     File file = File("example.pdf");
//     pw.Document pdf = pw.Document();
//     file.writeAsBytesSync(List.from(await pdf.save()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Geeksforgeeks"),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(10),
//         child: Column(
//           children: <Widget>[
//             SizedBox(
//               width: double.infinity,
//               child: RaisedButton(
//                 color: Colors.blueGrey,
//                 child: Text(
//                   'Preview PDF',
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: Colors.white),
//                 ),
//                 onPressed: () async {
//                   writeOnPdf();
//                   await savePdf();

//                   // Directory documentDirectory =
//                   //     await getApplicationDocumentsDirectory();

//                   // String documentPath = documentDirectory.path;

//                   String fullPath = "example.pdf";
//                   print(fullPath);

//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => PdfPreviewScreen(
//                                 path: fullPath,
//                               )));
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
