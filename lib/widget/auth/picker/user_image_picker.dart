import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickedFunction);

  final void Function(File pickedImage) imagePickedFunction;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _image;
  void _pickImage() async {
    final pickedImageFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    setState(() {
      _image = File(pickedImageFile.path);
    });
    widget.imagePickedFunction(File(pickedImageFile.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundImage: _image != null ? FileImage(_image) : null,
        ),
        FlatButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Take a image'),
          textColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
