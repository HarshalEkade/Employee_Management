import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickAndSaveImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'emp_${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}';
    final savedPath = p.join(appDir.path, fileName);

    final savedImage = await File(picked.path).copy(savedPath);
    return savedImage.path;
  }
}

