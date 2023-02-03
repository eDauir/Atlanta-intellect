class IProductId {
  int? lessonsCount;
  List<UserInfo>? userInfo;
  List<Product>? product;
  List<Sections>? sections;
  int? allDuration;

  IProductId(
      {this.lessonsCount,
      this.userInfo,
      this.product,
      this.sections,
      this.allDuration});

  IProductId.fromJson(Map<String, dynamic> json) {
    lessonsCount = json['lessonsCount'];
    if (json['userInfo'] != null) {
      userInfo = <UserInfo>[];
      json['userInfo'].forEach((v) {
        userInfo!.add(new UserInfo.fromJson(v));
      });
    }
    if (json['product'] != null) {
      product = <Product>[];
      json['product'].forEach((v) {
        product!.add(new Product.fromJson(v));
      });
    }
    if (json['sections'] != null) {
      sections = <Sections>[];
      json['sections'].forEach((v) {
        sections!.add(new Sections.fromJson(v));
      });
    }
    allDuration = json['allDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lessonsCount'] = this.lessonsCount;
    if (this.userInfo != null) {
      data['userInfo'] = this.userInfo!.map((v) => v.toJson()).toList();
    }
    if (this.product != null) {
      data['product'] = this.product!.map((v) => v.toJson()).toList();
    }
    if (this.sections != null) {
      data['sections'] = this.sections!.map((v) => v.toJson()).toList();
    }
    data['allDuration'] = this.allDuration;
    return data;
  }
}

class UserInfo {
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

  UserInfo(
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
      this.avatar});

  UserInfo.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}


class Product {
  String? id;
  String? name;
  String? about;
  String? price;
  String? level;
  String? userId;
  String? categoryId;
  String? intro;
  String? date;
  String? active;
  String? online;
  String? rating;
  String? ratingCount;
  String? catName;
  String? orderCount;
  String? file;

  Product(
      {this.id,
      this.name,
      this.about,
      this.price,
      this.level,
      this.userId,
      this.categoryId,
      this.intro,
      this.date,
      this.active,
      this.online,
      this.rating,
      this.ratingCount,
      this.catName,
      this.orderCount,
      this.file});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    about = json['about'];
    price = json['price'];
    level = json['level'];
    userId = json['userId'];
    categoryId = json['categoryId'];
    intro = json['intro'];
    date = json['date'];
    active = json['active'];
    online = json['online'];
    rating = json['rating'];
    ratingCount = json['ratingCount'];
    catName = json['catName'];
    orderCount = json['orderCount'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['about'] = this.about;
    data['price'] = this.price;
    data['level'] = this.level;
    data['userId'] = this.userId;
    data['categoryId'] = this.categoryId;
    data['intro'] = this.intro;
    data['date'] = this.date;
    data['active'] = this.active;
    data['online'] = this.online;
    data['rating'] = this.rating;
    data['ratingCount'] = this.ratingCount;
    data['catName'] = this.catName;
    data['orderCount'] = this.orderCount;
    data['file'] = this.file;
    return data;
  }
}

class Sections {
  String? id;
  String? productId;
  String? name;
  List<Lessons>? lessons;

  Sections({this.id, this.productId, this.name, this.lessons});

  Sections.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    name = json['name'];
    if (json['lessons'] != null) {
      lessons = <Lessons>[];
      json['lessons'].forEach((v) {
        lessons!.add(new Lessons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productId'] = this.productId;
    data['name'] = this.name;
    if (this.lessons != null) {
      data['lessons'] = this.lessons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Lessons {
  String? id;
  String? name;
  String? productId;
  String? sectionId;
  String? elemType;
  String? elemLink;
  String? elemDuration;

  Lessons(
      {this.id,
      this.name,
      this.productId,
      this.sectionId,
      this.elemType,
      this.elemLink,
      this.elemDuration});

  Lessons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productId = json['productId'];
    sectionId = json['sectionId'];
    elemType = json['elemType'];
    elemLink = json['elemLink'];
    elemDuration = json['elemDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['productId'] = this.productId;
    data['sectionId'] = this.sectionId;
    data['elemType'] = this.elemType;
    data['elemLink'] = this.elemLink;
    data['elemDuration'] = this.elemDuration;
    return data;
  }
}





class IProductProgress {
  String? id;
  String? userId;
  String? productId;
  String? lastId;
  String? lastType;

  IProductProgress(
      {this.id, this.userId, this.productId, this.lastId, this.lastType});

  IProductProgress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    productId = json['productId'];
    lastId = json['lastId'];
    lastType = json['lastType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['productId'] = this.productId;
    data['lastId'] = this.lastId;
    data['lastType'] = this.lastType;
    return data;
  }
}





class ITest {
  List<Questions>? questions;

  ITest({this.questions});

  ITest.fromJson(Map<String, dynamic> json) {
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  String? id;
  String? testId;
  String? title;
  List<Answer>? answer;

  Questions({this.id, this.testId, this.title, this.answer});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    testId = json['testId'];
    title = json['title'];
    if (json['answer'] != null) {
      answer = <Answer>[];
      json['answer'].forEach((v) {
        answer!.add(new Answer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['testId'] = this.testId;
    data['title'] = this.title;
    if (this.answer != null) {
      data['answer'] = this.answer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Answer {
  String? id;
  String? questionId;
  String? title;
  String? isTrue;

  Answer({this.id, this.questionId, this.title, this.isTrue});

  Answer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionId = json['questionId'];
    title = json['title'];
    isTrue = json['isTrue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['questionId'] = this.questionId;
    data['title'] = this.title;
    data['isTrue'] = this.isTrue;
    return data;
  }
}







// ? BUY COURSE FOR PAYBOX
