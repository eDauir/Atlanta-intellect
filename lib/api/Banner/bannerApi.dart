import 'package:barber/api/Banner/IBanner.dart';
import 'package:barber/api/mainApi.dart';



 getBanner() async {
  List<IBanner> data  = await Api().getData<IBanner>(params: {
    'type': 'banner',
    // 'subType': 'get',
  }, fromJson: IBanner.fromJson);
  return data;
}



