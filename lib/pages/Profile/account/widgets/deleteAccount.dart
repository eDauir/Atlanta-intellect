import 'package:barber/res/style/my_theme.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../module/queries.dart';

deleteAccount(BuildContext context, String authToken,
    EncryptedSharedPreferences encryptedSharedPreferences) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Вы уверены?',
              textScaleFactor: textScale(context),
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(
              height: marginScale(context, 15),
            ),
            Text(
              'Ваш аккаунт будет удален',
              textScaleFactor: textScale(context),
              style: headLine5Med,
            ),
            SizedBox(
              height: marginScale(context, 20),
            ),
            Row(
              children: [
                Container(
                  width: marginScale(context, 100),
                  height: marginScale(context, 40),
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Отмена',
                      )),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: marginScale(context, 100),
                  height: marginScale(context, 40),
                  child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () async {
                        queryToDel(authToken, encryptedSharedPreferences);
                        Navigator.of(context).pop();
                        context.go('/auth');
                      },
                      child: Text('Удалить')),
                )
              ],
            )
          ],
        ),

      );
    },
  );
}
