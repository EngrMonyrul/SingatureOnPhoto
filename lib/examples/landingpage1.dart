import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/examples/imageeditpage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<String> imagePath = [];

  Future<void> ImagePickerSystem(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    setState(() {
      imagePath.add(pickedImage!.path);
    });
  }

  void deletImage(index){
    setState(() {
      imagePath.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          children: [
            if (imagePath.isEmpty) buildEmptyPreset(context),
            if (imagePath.isNotEmpty) buildImagePreview(screensize),
            const Spacer(),
            buildImagePickerButton(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Container buildEmptyPreset(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
      child: Column(
        children: [
          Image.asset('assets/images/unorganized.png', height: 100, width: 100),
          const Text('No Image | Please Pick An Image', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  SizedBox buildImagePreview(Size screensize) {
    return SizedBox(
      height: screensize.height * 0.85,
      width: screensize.width,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: imagePath.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ImageEditPage(imagePath: imagePath[index])));
                },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        image: FileImage(File(imagePath[index])),
                      )),
                ),
              ),
              Positioned(
                top: -15,
                right: -8,
                child: CupertinoButton(
                  onPressed: () {
                    deletImage(index);
                  },
                  child: const SizedBox(
                    child: Icon(Icons.delete, color: Colors.red),
                  ),
                ),
              ),
              Positioned(
                top: -15,
                left: -8,
                child: CupertinoButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ImageEditPage(imagePath: imagePath[index])));
                  },
                  child: const SizedBox(
                    child: Icon(Icons.edit, color: Colors.red),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildImagePickerButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoButton(
            onPressed: () async {
              await ImagePickerSystem(ImageSource.camera);
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: const Text('Take Photo', style: TextStyle(color: Colors.white)),
            ),
          ),
          CupertinoButton(
            onPressed: () async {
              await ImagePickerSystem(ImageSource.gallery);
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: const Text('Choose Photo', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
