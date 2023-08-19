import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:provider/provider.dart';
import 'package:untitled/provider/imagepathprovider.dart';

class DraggableResizableRotatablePhoto extends StatefulWidget {
  @override
  _DraggableResizableRotatablePhotoState createState() => _DraggableResizableRotatablePhotoState();
}

class _DraggableResizableRotatablePhotoState extends State<DraggableResizableRotatablePhoto> {
  Matrix4 _matrix = Matrix4.identity();
  Offset _translation = Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    final ip = Provider.of<imagepathprovider>(context);
    return Container(
      color: Colors.grey[300],
      width: double.infinity,
      height: double.infinity,
      child: MatrixGestureDetector(
        onMatrixUpdate: (Matrix4 matrix, Matrix4 translationMatrix, Matrix4 scaleMatrix, Matrix4 rotationMatrix) {
          final decomposedMatrix = MatrixGestureDetector.decomposeToValues(matrix);
          setState(() {
            _matrix = matrix;
            _translation = Offset(decomposedMatrix.translation.dx, decomposedMatrix.translation.dy);
          });
        },
        child: Transform(
          transform: _matrix,
          alignment: FractionalOffset.center,
          child: Image.asset(ip.imagepath),
        ),
      ),
    );
  }
}
