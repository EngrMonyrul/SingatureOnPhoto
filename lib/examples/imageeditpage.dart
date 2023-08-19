import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:untitled/examples/signaturepad.dart';
import 'package:untitled/provider/imagepathprovider.dart';
import 'draggablesignature.dart';

class ImageEditPage extends StatefulWidget {
  final String imagePath;
  const ImageEditPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<ImageEditPage> createState() => _ImageEditPageState();
}

class _ImageEditPageState extends State<ImageEditPage> {
  Matrix4 _matrix = Matrix4.identity();
  Offset _translation = Offset(0, 0);
  bool showBorder = true;

  void borderArea() {
    setState(() {
      showBorder = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ip = Provider.of<imagepathprovider>(context, listen: false);
    return Scaffold(
      body: Consumer<imagepathprovider>(
        builder: (context, value, chld) {
          return Center(
            child: Stack(
              children: [
                buildImageArea(),
                Positioned(
                  top: 40,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignaturePad()));
                      // setState(() {
                      //   printDecomposedTranslation(x);
                      // });
                    },
                    child: Consumer<imagepathprovider>(
                      builder: (context, property2, child) {
                        return property2.imagepath.isEmpty
                            ? Text('Sign', style: TextStyle(fontSize: 20))
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: MatrixGestureDetector(
                                  onMatrixUpdate: (Matrix4 matrix, Matrix4 translationMatrix, Matrix4 scaleMatrix,
                                      Matrix4 rotationMatrix) {
                                    final decomposedMatrix = MatrixGestureDetector.decomposeToValues(matrix);
                                    setState(() {
                                      _matrix = matrix;
                                      _translation =
                                          Offset(decomposedMatrix.translation.dx, decomposedMatrix.translation.dy);
                                    });
                                  },
                                  child: Transform(
                                    transform: _matrix,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.blue),
                                          ),
                                          child: Image.file(
                                            File(ip.imagepath),
                                          ),
                                        ),
                                        Positioned(
                                          top: -10,
                                          left: -15,
                                          child: CircleAvatar(radius: 20, backgroundColor: Colors.blue),
                                        ),
                                        Positioned(
                                          top: -10,
                                          right: -15,
                                          child: CircleAvatar(radius: 20, backgroundColor: Colors.blue),
                                        ),
                                        Positioned(
                                          bottom: 210,
                                          left: -15,
                                          child: CircleAvatar(radius: 20, backgroundColor: Colors.blue),
                                        ),
                                        Positioned(
                                          bottom: 210,
                                          right: -15,
                                          child: CircleAvatar(radius: 20, backgroundColor: Colors.blue),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
