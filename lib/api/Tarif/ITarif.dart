class ITarif {
  String? id;
  String? name;
  String? price;
  String? about;
  String? day;

  ITarif({this.id, this.name, this.price, this.about, this.day});

  ITarif.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    about = json['about'];
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['about'] = this.about;
    data['day'] = this.day;
    return data;
  }
}



class IBoughtTarif {
  String? id;
  String? rateId;
  String? userId;
  String? activeDate;
  String? paymentId;
  String? orderId;
  String? payboxLink;
  String? active;
  String? day;

  IBoughtTarif(
      {this.id,
      this.rateId,
      this.userId,
      this.activeDate,
      this.paymentId,
      this.orderId,
      this.payboxLink,
      this.active,
      this.day});

  IBoughtTarif.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rateId = json['rateId'];
    userId = json['userId'];
    activeDate = json['activeDate'];
    paymentId = json['paymentId'];
    orderId = json['orderId'];
    payboxLink = json['payboxLink'];
    active = json['active'];
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rateId'] = this.rateId;
    data['userId'] = this.userId;
    data['activeDate'] = this.activeDate;
    data['paymentId'] = this.paymentId;
    data['orderId'] = this.orderId;
    data['payboxLink'] = this.payboxLink;
    data['active'] = this.active;
    data['day'] = this.day;
    return data;
  }
}