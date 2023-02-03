import 'package:barber/api/Mentors/IMentor.dart';
import 'package:barber/api/Mentors/IMentorId.dart';
import 'package:barber/api/mainApi.dart';

getMentors({String searchKey = '' , page}) async {
  List<IMentor> data = await Api().getData<IMentor>(
      params: {'type': 'user', 'subType': 'getSearch', 'searchKey': searchKey , 'page' : page},
      fromJson: IMentor.fromJson);
  return data;
}



getMentorId({String searchKey = '' , page , String ? id}) async {
  List<IMentorId> ? data = await Api().getData<IMentorId>(
      params: {'type': 'user', 'subType': 'getInfo', 'id' : id},
      fromJson: IMentorId.fromJson);
  
  return data;
}