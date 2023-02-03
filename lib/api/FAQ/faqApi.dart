



 import 'package:barber/api/FAQ/IFaq.dart';
import 'package:barber/api/mainApi.dart';

getFAQ({String page = '1'}) async {
  List<IFaq>? data  = await Api().getData<IFaq>(params: {
    'type': 'faq',
    'page': page,
  }, fromJson: IFaq.fromJson);
  return data ?? [];
}



