import 'dart:async';
import 'dart:io';

import 'package:barber/pages/Profile/account/vars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_pdfview/flutter_pdfview.dart';

class BookReader extends StatefulWidget {
  String pdf;
  bool isLoad;
  BookReader({Key? key, required this.pdf, required this.isLoad})
      : super(key: key);

  @override
  State<BookReader> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  bool isReady = false;
  int? currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.isLoad
            ? Container(
                child: Stack(
                  children: [
                    PDFView(
                      enableSwipe: true,
                      swipeHorizontal: true,
                      pageFling: false,
                      filePath: widget.pdf,
                      onRender: (_pages) {
                        setState(() {
                          pages = _pages;
                          isReady = true;
                        });
                      },
                      onError: (error) {
                        print(error.toString());
                      },
                      onPageError: (page, error) {
                        print('$page: ${error.toString()}');
                      },
                      onViewCreated: (PDFViewController pdfViewController) {
                        _controller.complete(pdfViewController);
                      },
                      onPageChanged: (int? page, int? total) {
                        print('page change: $page/$total');
                        setState(() {
                          currentPage = page;
                        });
                      },
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            )),
                      ),
                    ),
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }
}
