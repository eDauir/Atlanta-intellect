class IWallet {
  List<Main>? main;
  int? count;
  List<History>? history;

  IWallet({this.main, this.count, this.history});

  IWallet.fromJson(Map<String, dynamic> json) {
    if (json['main'] != null) {
      main = <Main>[];
      json['main'].forEach((v) {
        main!.add(new Main.fromJson(v));
      });
    }
    count = json['count'];
    if (json['history'] != null) {
      history = <History>[];
      json['history'].forEach((v) {
        history!.add(new History.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.main != null) {
      data['main'] = this.main!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    if (this.history != null) {
      data['history'] = this.history!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Main {
  String? id;
  String? userId;
  String? amount;
  String? unitValue;

  Main({this.id, this.userId, this.amount, this.unitValue});

  Main.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    amount = json['amount'];
    unitValue = json['unitValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['amount'] = this.amount;
    data['unitValue'] = this.unitValue;
    return data;
  }
}

class History {
  String? id;
  String? userId;
  String? toUser;
  String? type;
  String? amount;
  String? date;
  String? fromName;
  String? toName;

  History(
      {this.id,
      this.userId,
      this.toUser,
      this.type,
      this.amount,
      this.date,
      this.fromName,
      this.toName});

  History.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    toUser = json['toUser'];
    type = json['type'];
    amount = json['amount'];
    date = json['date'];
    fromName = json['fromName'];
    toName = json['toName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['toUser'] = this.toUser;
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['date'] = this.date;
    data['fromName'] = this.fromName;
    data['toName'] = this.toName;
    return data;
  }
}




class IBoughtUnit {
  String? sum;

  IBoughtUnit({this.sum});

  IBoughtUnit.fromJson(Map<String, dynamic> json) {
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sum'] = this.sum;
    return data;
  }
}