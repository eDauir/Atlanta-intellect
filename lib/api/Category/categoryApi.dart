import 'package:barber/api/Category/ICategory.dart';
import 'package:barber/api/mainApi.dart';



 getCategory() async {
  List<ICategory> data  = await Api().getData<ICategory>(params: {
    'type': 'category',
    'subType': 'get',
  }, fromJson: ICategory.fromJson);
  return data;
}



