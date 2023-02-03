

import 'dart:math';

startCountFormat(String num) {
  return (double.parse(num)).toStringAsFixed(1);
}

hourFormat(String num) {
  return '${(double.parse(num) / 60).toStringAsFixed(1)}ч';
}



const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890'; 
Random _rnd = Random(); 
 
String getRandomString(int length) => String.fromCharCodes(Iterable.generate( 
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));