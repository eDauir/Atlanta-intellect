import 'package:barber/res/style/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../module/queries.dart';

var maskFormatter = new MaskTextInputFormatter(
    mask: '+# (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

editDefault(BuildContext context, String authToken,
    TextEditingController textController, String name, String type) {
  bool error = false;

  textController.text.isEmpty || textController.text == 'Не введено'
      ? textController.text = ''
      : textController.text = textController.text;
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
                    title: Text(
                      name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
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
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            inputFormatters: [
                              (type == 'tele')
                                  ? maskFormatter
                                  : FilteringTextInputFormatter.deny('  '),
                            ],
                            maxLines: (type == 'about') ? 10 : 1,
                            maxLength: (type == 'tele')
                                ? 18
                                : (type == 'about')
                                    ? 1000
                                    : 50,
                            keyboardType: (type == 'tele')
                                ? TextInputType.phone
                                : TextInputType.text,
                            validator: (value) {
                              if (type == 'tele' &&
                                  textController.text.length < 18) {
                                return 'Неверный формат';
                              }
                              if (textController.text.isEmpty) {
                                if (type == 'about') return null;
                                return 'Обьязательно';
                              }
                              if (textController.text.length < 2) {
                                return 'Слишком коротко';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: textController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      width: 2, color: primary_color)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: type == 'about' ? null : name,
                              labelStyle: TextStyle(color: Colors.grey[800]),
                            ),
                          ),
                        ),
                      ),
                      if (error == true)
                        const Text('Такой логин уже существует!'),
                    ],
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Center(
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
                              switch (type) {
                                case 'login':
                                  var res = await queryToLogin(
                                      authToken, textController.text);
                                  if (res == 'true') {
                                    Navigator.of(context).pop();
                                  } else {
                                    setState(() {
                                      error = true;
                                    });
                                  }
                                  break;
                                case 'tele':
                                  queryToTele(authToken, textController.text);
                                  Navigator.of(context).pop();
                                  break;
                                case 'about':
                                  queryToAbout(authToken, textController.text);
                                  Navigator.of(context).pop();
                                  break;
                                case 'geo':
                                  queryToGeo(authToken, textController.text);
                                  Navigator.of(context).pop();
                                  break;
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
