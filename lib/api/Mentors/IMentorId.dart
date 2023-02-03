class IMentorId {
  String? id;
  String? userId;
  String? name;
  String? surname;
  String? otchestvo;
  String? about;
  String? job;
  String? web;
  String? insta;
  String? login;
  String? birthday;
  String? pol;
  String? geo;
  String? telephone;
  String? avatar;
  String? courseCount;
  String? ordersCount;
  String? commentsCount;

  IMentorId(
      {this.id,
      this.userId,
      this.name,
      this.surname,
      this.otchestvo,
      this.about,
      this.job,
      this.web,
      this.insta,
      this.login,
      this.birthday,
      this.pol,
      this.geo,
      this.telephone,
      this.avatar,
      this.courseCount,
      this.ordersCount,
      this.commentsCount});

  IMentorId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    surname = json['surname'];
    otchestvo = json['otchestvo'];
    about = json['about'];
    job = json['job'];
    web = json['web'];
    insta = json['insta'];
    login = json['login'];
    birthday = json['birthday'];
    pol = json['pol'];
    geo = json['geo'];
    telephone = json['telephone'];
    avatar = json['avatar'];
    courseCount = json['courseCount'];
    ordersCount = json['ordersCount'];
    commentsCount = json['commentsCount'];
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
    data['web'] = this.web;
    data['insta'] = this.insta;
    data['login'] = this.login;
    data['birthday'] = this.birthday;
    data['pol'] = this.pol;
    data['geo'] = this.geo;
    data['telephone'] = this.telephone;
    data['avatar'] = this.avatar;
    data['courseCount'] = this.courseCount;
    data['ordersCount'] = this.ordersCount;
    data['commentsCount'] = this.commentsCount;
    return data;
  }
}