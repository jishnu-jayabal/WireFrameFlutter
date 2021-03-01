import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';


class PdfViewerScreen extends StatefulWidget {
  PdfViewerScreen({Key key}) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
 
  File pdfFile;
  PDFDocument pdfDocument;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(30),
        child:   OutlineButton(
              onPressed: () {
                _pickPdf();
              },
              child: Text("Normal PDF Viewe"),
            )
      ),
      body: Container(
        child: pdfDocument != null?Container(
              child:PDFViewer(document: this.pdfDocument)
            ):SizedBox(),
      ),
    );
  }

  void _pickPdf() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    this.pdfFile = File(result.files.first.path);
    this.pdfDocument = await PDFDocument.fromFile(this.pdfFile);
    await this.pdfDocument.get(page: 1);
    setState(() {
      
    });
  
  }
}

