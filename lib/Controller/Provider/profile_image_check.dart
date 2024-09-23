import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageEditProvider extends ChangeNotifier {
  String? _imagePath;

  String? get imagePath => _imagePath;

  Future<void> selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _imagePath = pickedFile.path;
      notifyListeners();
    }
  }
}
