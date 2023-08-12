import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey repainKey = GlobalKey();
  void ShareImage() async {
    //1.Fetch Raw Data From RepaintBountry Key
    RenderRepaintBoundary res =
        repainKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    //2.Convert Raw Data to Image Data.....
    var image = await res.toImage(pixelRatio: 2);
    log("=====================");
    log("${image}");
    log("=====================");

    //3.convert Image data into BytesData.....
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    log("=====================");
    log("${byteData}");
    log("=====================");

    //4.Convert BytesData into Uint8List......Image Created
    Uint8List uList = await byteData!.buffer.asUint8List();

    log("=====================");
    print("${uList}");
    log("=====================");

    //5.Get Image Path from Mobile With Path_Provider Package
    Directory directory = await getApplicationSupportDirectory();
    log("=====================");
    print("${directory}");
    log("=====================");

    //6.Convert Uint8List into File and Merge directory path or Save to Device
    File file = await File("${directory.path}.png");
    await file.writeAsBytes(uList);
    log("=====================");
    print("${file}");
    log("=====================");

    //7.Share Image with Share_extend package
    await ShareExtend.share(file.path, "image");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Share Image"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RepaintBoundary(
              key: repainKey,
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://yt3.googleusercontent.com/ytc/AOPolaSyNUjVLD1DJQmrIvGJH2JHSoLDcnTN-ehTtB_B=s900-c-k-c0x00ffffff-no-rj",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ShareImage();
              },
              child: Text("Share Image"),
            ),
          ],
        ),
      ),
    );
  }
}
