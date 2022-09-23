import 'package:image_picker/image_picker.dart';

Future<String?> getImage() async {
  XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (file != null) {
    return file.path;
  } else {
    return null;
  }
}
