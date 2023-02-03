import 'dart:convert';
import 'dart:typed_data';
import 'package:cropperx/cropperx.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../provider/globalData.dart';
import '../module/editImage.dart';

editAvatar(res, BuildContext context, OverlayType overlayType,
    int rotationTurns, String authToken, Uint8List? croppedImage, loadAvatar) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: SingleChildScrollView(
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  title: ListTile(
                    title:  Text(
                      'Изменение Аватара',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  content: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height:
                                context.read<GlobalData>().isDevice == 1 ? 500 : 250,
                            child: Cropper(
                              cropperKey: context.read<GlobalData>().getGlobalKey,
                              overlayType: overlayType,
                              rotationTurns: rotationTurns,
                              image: Image.memory(res),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() => rotationTurns--);
                                },
                                icon: const Icon(Icons.rotate_left),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() => rotationTurns++);
                                },
                                icon: const Icon(Icons.rotate_right),
                              ),
                            ],
                          ),
                          Flex(
                            direction: context.read<GlobalData>().isDevice == 1
                                ? Axis.horizontal
                                : Axis.vertical,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 150,
                                height: 50,
                                child: ElevatedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: const Text('Отмена'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  width: 150,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: const Text('Сохранить'),
                                    onPressed: () async {
                                      final imageBytes = await Cropper.crop(
                                        cropperKey:
                                            context.read<GlobalData>().getGlobalKey,
                                      );
              
                                      if (imageBytes != null) {
                                        setState(() {
                                          croppedImage = imageBytes;
                                        });
                                        var localEncode = base64Encode(croppedImage!);
                                        await loadImage(authToken, localEncode);
                                        loadAvatar(localEncode);
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
