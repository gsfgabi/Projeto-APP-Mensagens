import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

Future<Uint8List?> pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print("Nenhuma imagem selecionada");
  return null;
}
