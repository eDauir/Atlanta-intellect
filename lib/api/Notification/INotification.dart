class INotification {
  int? count;
  Map<dynamic, dynamic>? notify;
 String? authToken;

  INotification({this.notify, this.count,});

  INotification.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    notify = json['notify'];
    authToken = json['authToken'];
  }
}
