import 'package:barber/pages/Profile/account/module/queries.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:flutter/material.dart';

editFio(
    BuildContext context,
    String authToken,
    TextEditingController surnameController,
    TextEditingController nameController,
    TextEditingController otchController) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
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
                  'Изменение ФИО',
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
                          if (surnameController.text.isEmpty) {
                            return 'Обьязательно';
                          }
                          if (surnameController.text.length < 2) {
                            return 'Слишком коротко';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: surnameController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  width: 2, color: primary_color)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Фамилия',
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
                          if (nameController.text.isEmpty) {
                            return 'Обьязательно';
                          }
                          if (nameController.text.length < 2) {
                            return 'Слишком коротко';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: nameController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  width: 2, color: primary_color)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Имя',
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
                        controller: otchController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  width: 2, color: primary_color)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Отчество',
                          labelStyle: TextStyle(color: Colors.grey[800]),
                        ),
                      ),
                    ),
                  ),
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
                          queryToFio(nameController.text, surnameController.text,
                              otchController.text, authToken);
                          Navigator.of(context).pop();
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
}
