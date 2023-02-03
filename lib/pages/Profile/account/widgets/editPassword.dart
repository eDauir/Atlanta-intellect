import 'package:barber/res/style/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../api/profileApi.dart';

changePassword(
    String newPass, String reNewPass, String oldPass, String authToken) async {
  if (newPass.isNotEmpty && reNewPass.isNotEmpty && (newPass == reNewPass)) {
    var res = await changePasswordQuery(authToken, 'checkPass', oldPass);
    if (res == true) {
      var res2 = await changePasswordQuery(authToken, 'changePass', newPass);
      if (res2 == true) {
        return 'true';
      } else {
        return 'false';
      }
    } else {
      return 'false';
    }
  } else {
    return 'false';
  }
}

editPassword(
    BuildContext context,
    String authToken,
    TextEditingController oldPasswordController,
    TextEditingController newPasswordController,
    TextEditingController reNewPasswordController,
    bool passwordVisible1,
    bool passwordVisible2,
    bool passwordVisible3,
    bool passError) {
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
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: ListTile(
                  title: const Text(
                    'Сменить пароль',
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
                          validator: (value) {
                            if (oldPasswordController.text.isEmpty) {
                              return 'Обьязательно';
                            }
                            if (oldPasswordController.text.length < 6) {
                              return 'Слишком коротко';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: oldPasswordController,
                          obscureText: !passwordVisible1,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordVisible1
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: primary_color,
                              ),
                              onPressed: () {
                                setState(() {
                                  passwordVisible1 = !passwordVisible1;
                                });
                              },
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  width: 2, color: primary_color),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Введите текущий пароль',
                            labelStyle: TextStyle(color: Colors.grey[800]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          validator: (value) {
                            if (newPasswordController.text.isEmpty) {
                              return 'Обьязательно';
                            }
                            if (newPasswordController.text.length < 6) {
                              return 'Слишком коротко';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: newPasswordController,
                          obscureText: !passwordVisible2,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordVisible2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: primary_color,
                              ),
                              onPressed: () {
                                setState(() {
                                  passwordVisible2 = !passwordVisible2;
                                });
                              },
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  width: 2, color: primary_color ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Введите новый пароль',
                            labelStyle: TextStyle(color: Colors.grey[800]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          validator: (value) {
                            if (reNewPasswordController.text !=
                                newPasswordController.text) {
                              return 'Пароль не совпадает';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: reNewPasswordController,
                          obscureText: !passwordVisible3,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordVisible3
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: primary_color,
                              ),
                              onPressed: () {
                                setState(() {
                                  passwordVisible3 = !passwordVisible3;
                                });
                              },
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  width: 2, color: primary_color),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Подтвердите новый пароль',
                            labelStyle: TextStyle(color: Colors.grey[800]),
                          ),
                        ),
                      ),
                    ),
                    passError
                        ? SizedBox(
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: const [
                                  FaIcon(
                                    FontAwesomeIcons.circleExclamation,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                  Text(
                                    ' Произошла ошибка',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const Text(''),
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
                            var res = await changePassword(
                                newPasswordController.text,
                                reNewPasswordController.text,
                                oldPasswordController.text,
                                authToken);
                            if (res == 'false') {
                              setState(() {
                                passError = true;
                              });
                            } else {
                              Navigator.of(context).pop();
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
