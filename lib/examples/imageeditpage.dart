import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:untitled/provider/imagepathprovider.dart';

class ImageEditPage extends StatefulWidget {
  final String imagePath;
  const ImageEditPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<ImageEditPage> createState() => _ImageEditPageState();
}

class _ImageEditPageState extends State<ImageEditPage> {
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

  showSignArea() {
    showModalBottomSheet(
      backgroundColor: Colors.white.withOpacity(0.3),
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Consumer<imagepathprovider>(builder: (context, property, child) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: Divider(
                  color: Colors.white,
                  thickness: 3,
                ),
              ),
              const Text('Add Signature', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
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
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<imagepathprovider>(builder: (context, value, chld) {
        return Center(
          child: Stack(
            children: [
              buildImageArea(),
              Consumer<imagepathprovider>(builder: (context, property2, child) {
                return Positioned(
                  top: position.dy,
                  left: position.dx,
                  child: GestureDetector(
                      child: Transform.scale(
                          scale: scale,
                          child: Transform.rotate(
                            angle: degree * pi / 180,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                if (property2.imagepath.isEmpty)
                                  Draggable(
                                    feedback: Container(
                                      decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
                                      child: Text(
                                        'Add Sign',
                                        style: TextStyle(fontSize: 20, decoration: TextDecoration.none),
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showSignArea();
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
                                        child: Text('Add Sign'),
                                      ),
                                    ),
                                    onDraggableCanceled: (Velocity velocity, Offset offset) {
                                      setState(() {
                                        position = offset;
                                      });
                                    },
                                  ),
                                if (property2.imagepath.isNotEmpty)
                                  Draggable(
                                    feedback: Container(
                                        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
                                        child: Image.file(File(property2.imagepath), height: 100, width: 100)),
                                    child: Container(
                                        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
                                        child: Image.file(File(property2.imagepath), height: 100, width: 100)),
                                    onDraggableCanceled: (Velocity velocity, Offset offset) {
                                      setState(() {
                                        position = offset;
                                      });
                                    },
                                  ),
                                Positioned(
                                  top: -18,
                                  right: -18,
                                  child: GestureDetector(
                                    onPanUpdate: (_) {
                                      setState(() {
                                        scale -= 0.1;
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: -18,
                                  left: -18,
                                  child: GestureDetector(
                                    onPanUpdate: (_) {
                                      degree += 0.1;
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.rotate_left,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -18,
                                  left: -18,
                                  child: GestureDetector(
                                    onPanUpdate: (_) {
                                      setState(() {
                                        scale -= 0.1;
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -18,
                                  right: -18,
                                  child: GestureDetector(
                                    onPanUpdate: (_) {
                                      setState(() {
                                        scale += 0.1;
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Container buildImageArea() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: FileImage(File(widget.imagePath)),
        fit: BoxFit.fill,
      )),
    );
  }
}
