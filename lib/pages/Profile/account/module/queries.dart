import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import '../../../../api/profileApi.dart';

queryToDel(String authToken,
    EncryptedSharedPreferences encryptedSharedPreferences) async {
  await profileQuery(authToken, 'delete');
  await encryptedSharedPreferences.clear();
}

queryToFio(String name, String surname, String otch, String authToken) {
  if (name.isNotEmpty && surname.isNotEmpty) {
    changeFioElemQuery(authToken, name, surname, otch);
    return 'true';
  }
}

queryToPol(String authToken, bool manChecked) {
  if (manChecked == true) {
    changeDefElemQuery(authToken, 'users_profile', 'pol', 'Мужской');
  } else {
    changeDefElemQuery(authToken, 'users_profile', 'pol', 'Женский');
  }
}

queryToBirthday(String authToken, DateTime selectedDate) {
  changeDefElemQuery(
      authToken, 'users_profile', 'birthday', selectedDate.toString());
}

queryToLogin(String authToken, String login) async {
  if (login.length > 2) {
    var res = await changeLoginElemQuery(authToken, login);
    if (res == true) {
      return 'true';
    } else {
      return 'false';
    }
  }
}

queryToTele(String authToken, String tele) {
  if (tele.length >= 10) {
    changeDefElemQuery(authToken, 'users_profile', 'telephone',
        int.parse(tele.replaceAll(RegExp('[^0-9]'), '')).toString());
  }
}

queryToAbout(String authToken, String about) {
  changeDefElemQuery(authToken, 'users_profile', 'about', about);
}

queryToGeo(String authToken, String geo) {
  if (geo.length >= 5) {
    changeDefElemQuery(authToken, 'users_profile', 'geo', geo);
  }
}
