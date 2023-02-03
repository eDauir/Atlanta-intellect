import 'package:barber/res/style/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../api/profileApi.dart';

activeMail(BuildContext context, TextEditingController mailCode,
    String authToken, bool mailStatError) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: ListTile(
                  title:  Text(
                    'Активировать адрес эл. почты',
                    textScaleFactor: textScale(context),
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
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: mailCode,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  width: 2, color: primary_color),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Введите код',
                            labelStyle: TextStyle(color: Colors.grey[800]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: mailStatError
                            ? Row(
                                children: const [
                                  FaIcon(
                                    FontAwesomeIcons.circleExclamation,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                  Text(
                                    ' Неверный код',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              )
                            : const Text(''),
                      ),
                    )
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
                          child: const Text('Подтвердить'),
                          onPressed: () async {
                            var res = await activeAccQuery(authToken,
                                'activeAcc', 'mailCheck', mailCode.text);
                            if (res == true) {
                              Navigator.pop(context);
                            } else {
                              setState(() {
                                mailStatError = true;
                              });
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
      });
    },
  );
}
