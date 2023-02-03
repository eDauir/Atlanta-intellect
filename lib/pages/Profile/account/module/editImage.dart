import 'package:image_picker/image_picker.dart';
import '../../../../api/profileApi.dart';

loadImage(String login, String image) async {
  await changeAvatarElemQuery(login, image);
}

final ImagePicker _picker = ImagePicker();
 pickerImage() async {
  var picked = await _picker.pickImage(source: ImageSource.gallery);
  if (picked != null) {
    final fileBytes = await picked.readAsBytes();
    return fileBytes;
  }
}

pickerPostImages() async {
  var picked = await _picker.pickMultiImage();
  if (picked != null) {
    List filesInBytes = [];

    for (var item in picked) {
      var file = await item.readAsBytes();
      filesInBytes.add(file);
    }

    return filesInBytes;
  }
}
