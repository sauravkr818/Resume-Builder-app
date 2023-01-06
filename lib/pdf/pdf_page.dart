import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import './util.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PdfPage extends StatefulWidget {
  final String user;
  const PdfPage({Key? key, required this.user}) : super(key: key);

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  PrintingInfo? printingInfo;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("resume : " + widget.user);

    pw.RichText.debug = true;
    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        PdfPreviewAction(icon: Icon(Icons.save), onPressed: saveAsFile)
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text("Pdf Viewer"),
        ),
        body: PdfPreview(
          maxPageWidth: 700,
          actions: actions,
          onPrinted: showPrintedToast,
          onShared: showSharedToast,
          build: generatePdf,
        ));
  }
}
