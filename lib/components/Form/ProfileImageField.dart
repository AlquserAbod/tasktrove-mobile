// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:tasktrove/providers/theme_provider.dart'; // Required for FileImage

class ProfileImageField extends StatefulWidget {
  final Function(File) onImageSelected;
  String? imageUrl;

  ProfileImageField({
    required this.onImageSelected,
    this.imageUrl
  });

  @override
  _ProfileImageFieldState createState() => _ProfileImageFieldState();
}


class _ProfileImageFieldState extends  State<ProfileImageField> {
  File? _image;
  final picker =  ImagePicker();
  String defaultAvatarImage =  "assets/images/default_avatar.jpg";


  Future resetImage() async {
    setState(() {
      _image = null;
    });
  }

  Future selectOrTakePhoto(ImageSource imageSource) async {
    final pickedFile = await picker.pickImage(source: imageSource);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.onImageSelected(File(pickedFile.path));
      } else
        print('No photo was selected or taken');
    });
  }

  Future _showSelectionDialog() async {
    final l = AppLocalizations.of(context)!;

    await showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
          title:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l.select_photo),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.close),
              )
            ],
          ),

          children: <Widget>[
            SimpleDialogOption(
              child: Text(l.from_gallery),
              onPressed: () {
                selectOrTakePhoto(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: Text(l.from_camera),
              onPressed: () {
                selectOrTakePhoto(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            if (widget.imageUrl == null) 
              SimpleDialogOption(
                child: Text(l.reset_avatar),
                onPressed: () {
                  resetImage();
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.imageUrl);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0), 
      child: Center(
        child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
            MouseRegion(
                child: GestureDetector(
                  onTap: () => _showSelectionDialog(),
                  child: Container(
                    height: 150,
                    width: 150, 
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: Provider.of<ThemeProvider>(context).themeData.dividerColor,
                        width: 2
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: _image == null
                              ?  widget.imageUrl == null ? 
                                Image.asset(defaultAvatarImage,fit: BoxFit.cover) : 
                                Image.network(widget.imageUrl!, fit: BoxFit.cover)
                              : Image.file(_image!,fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: Provider.of<ThemeProvider>(context).themeData.dividerColor,
                                width: 2
                              ),
                            ),
                            child: CircleAvatar(
                              child: Icon(
                                _image != null ?
                                Icons.edit : Icons.add,
                                color: Provider.of<ThemeProvider>(context).themeData.dividerColor,
                              ),
                              backgroundColor: Provider.of<ThemeProvider>(context).themeData.primaryColor,
                            ),
                          )
                        ),
                      ],
                    )
                  )
                )
            ),
           ],
          ),
    )
  );
}
}