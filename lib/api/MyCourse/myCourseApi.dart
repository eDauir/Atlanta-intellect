import 'package:barber/api/MyCourse/IMyCourse.dart';
import 'package:barber/api/mainApi.dart';



getMyCourse({String? login}) async {
  List<IMyCourse> ? data = await Api().getData<IMyCourse>(params: {
    'type': 'orders',
    'subType': 'getMy',
    'authToken' : login,
  }, fromJson: IMyCourse.fromJson);
  return data ?? [];
}



// https://zheruiyq.com/digway/backend/main.php?type=orders&subType=getMy&authToken=4M9U6NYH902MTIK62AXLB8E36II1TX1R