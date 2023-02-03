class IMentor {
  List<Workers>? workers;
  int? count;
  String? total;

  IMentor({this.workers, this.count, this.total});

  IMentor.fromJson(Map<String, dynamic> json) {
    if (json['workers'] != null) {
      workers = <Workers>[];
      json['workers'].forEach((v) {
        workers!.add(new Workers.fromJson(v));
      });
    }
    count = json['count'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.workers != null) {
      data['workers'] = this.workers!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['total'] = this.total;
    return data;
  }
}

class Workers {
  String? id;
  String? userId;
  String? name;
  String? surname;
  String? otchestvo;
  String? about;
  String? job;
  String? login;
  String? birthday;
  String? pol;
  String? geo;
  String? telephone;
  String? avatar;
  String? editor;

  Workers(
      {this.id,
      this.userId,
      this.name,
      this.surname,
      this.otchestvo,
      this.about,
      this.job,
      this.login,
      this.birthday,
      this.pol,
      this.geo,
      this.telephone,
      this.avatar,
      this.editor});

  Workers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    surname = json['surname'];
    otchestvo = json['otchestvo'];
    about = json['about'];
    job = json['job'];
    login = json['login'];
    birthday = json['birthday'];
    pol = json['pol'];
    geo = json['geo'];
    telephone = json['telephone'];
    avatar = json['avatar'];
    editor = json['editor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['otchestvo'] = this.otchestvo;
    data['about'] = this.about;
    data['job'] = this.job;
    data['login'] = this.login;
    data['birthday'] = this.birthday;
    data['pol'] = this.pol;
    data['geo'] = this.geo;
    data['telephone'] = this.telephone;
    data['avatar'] = this.avatar;
    data['editor'] = this.editor;
    return data;
  }
}
