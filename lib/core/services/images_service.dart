import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    return picked?.path;
  }
}
