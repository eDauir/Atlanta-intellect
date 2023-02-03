import 'package:barber/api/Notification/INotification.dart';
import 'package:barber/api/mainApi.dart';
import 'package:barber/pages/Profile/account/vars.dart';

getNotification(String authToken) async {
  List<INotification> data = await Api().getData<INotification>(
    params: {
      'type': 'notify',
      'authToken': authToken,
    },
    fromJson: INotification.fromJson,
  );
  return data;
}
