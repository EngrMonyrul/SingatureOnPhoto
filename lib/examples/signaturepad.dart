import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../provider/imagepathprovider.dart';

class SignaturePad extends StatefulWidget {
  const SignaturePad({super.key});

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  GlobalKey<SfSignaturePadState> _signGlobalKey = GlobalKey();
  Color penColor = Colors.black;
  int counter = 0;
  String signImg = '';
  Offset position = Offset(100, 100);
  double scale = 1.0;
  Offset newPosition = Offset(0, 0);
  double degree = 0;

  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.white,
    Colors.black,
    Colors.yellow,
    Colors.pinkAccent,
    Colors.lightBlue,
    Colors.deepPurple,
  ];

  setPencolor(Color color) {
    setState(() {
      penColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white60,
        child: Consumer<imagepathprovider>(builder: (context, property, child) {
          return Column(
            children: [
              const Text('Add Signature', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20, decoration: TextDecoration.none)),
              const SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: SfSignaturePad(
                  backgroundColor: Colors.transparent,
                  strokeColor: penColor,
                  key: _signGlobalKey,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: colors.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CupertinoButton(
                      onPressed: () {
                        setPencolor(colors[index]);
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.05,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          shape: BoxShape.circle,
                          color: colors[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                    onPressed: () async {
                      _signGlobalKey.currentState?.clear();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: const Text('Clear', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () async {
                      final simage = await _signGlobalKey.currentState!.toImage();
                      final byteImage = await simage.toByteData(format: ImageByteFormat.png);
                      final dir = await getApplicationDocumentsDirectory();
                      final name = 'sign.png';
                      final file = File('${dir.path}/$name');
                      Uint8List signimage = byteImage!.buffer.asUint8List();
                      await file.writeAsBytes(signimage.toList());
                      property.setImagePath(file.path);
                      // setState(() {
                      //   signImg = file.path;
                      // });
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: const Text('Add', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
