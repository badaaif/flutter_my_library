import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void> _takePicture(ImageSource source) async {
    final imageFile = await ImagePicker.pickImage(
      source: source,
      maxHeight: 600,
    );
    if (imageFile == null) {
      return null;
    }
    setState(() {
      _storedImage = imageFile;
    });
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 100,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.camera),
                label: Text('Camera'),
                textColor: Theme.of(context).primaryColor,
                onPressed: () => _takePicture(ImageSource.camera),
              ),
              FlatButton.icon(
                icon: Icon(Icons.photo_album),
                label: Text('Gallery'),
                textColor: Theme.of(context).primaryColor,
                onPressed: () => _takePicture(ImageSource.gallery),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
