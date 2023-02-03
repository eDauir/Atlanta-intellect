import 'dart:typed_data';

import 'package:flutter/material.dart';
 String authToken='';
bool manChecked = false;
bool womanChecked = false;
bool homeContact = false;
bool homeSecure = false;
bool profileDetected = false;
bool mailStatus = false;
bool mailStatError = false;

final mailCode = TextEditingController();

late DateTime selectedDate;
Uint8List? changeAvatar;
String? avatar;
String? loaderavatar;

late String pol;
final surnameController = TextEditingController();
final aboutController = TextEditingController();
final nameController = TextEditingController();
final otchController = TextEditingController();
final loginController = TextEditingController();
String constMail = '';
String id = '';
bool isEditor = false;
bool loginError = false;

late String mainMail;
final teleController = TextEditingController();
final addressController = TextEditingController();

final oldPasswordController = TextEditingController();
final newPasswordController = TextEditingController();
final reNewPasswordController = TextEditingController();
bool passwordVisible1 = false;
bool passwordVisible2 = false;
bool passwordVisible3 = false;
bool passError = false;
