import 'package:image_picker/image_picker.dart';

//TODO: Funtion type not defined and it should be service function :(

getImage() async {
  XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (file != null) {
    return file.path;
  } else {
    return null;
  }
}
