class IHome {
  int? count;
  String? total;
  List<Products>? products;

  IHome({this.count, this.total, this.products});

  IHome.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    total = json['total'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['total'] = this.total;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}

class Products {
  String? countFind;
  String? id;
  String? name;
  String? price;
  String? lessonsCount;
  String? lessonsDuration;
  String? avatar;
  String? userName;
  String? userSurname;
  String? catName;
  String? rating;
  String? ratingCount;
  String? file;

  Products(
      {this.countFind,
      this.id,
      this.name,
      this.price,
      this.lessonsCount,
      this.lessonsDuration,
      this.avatar,
      this.userName,
      this.userSurname,
      this.catName,
      this.rating,
      this.ratingCount,
      this.file});

  Products.fromJson(Map<String, dynamic> json) {
    countFind = json['countFind'];
    id = json['id'];
    name = json['name'];
    price = json['price'];
    lessonsCount = json['lessonsCount'];
    lessonsDuration = json['lessonsDuration'];
    avatar = json['avatar'];
    userName = json['userName'];
    userSurname = json['userSurname'];
    catName = json['catName'];
    rating = json['rating'];
    ratingCount = json['ratingCount'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countFind'] = this.countFind;
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['lessonsCount'] = this.lessonsCount;
    data['lessonsDuration'] = this.lessonsDuration;
    data['avatar'] = this.avatar;
    data['userName'] = this.userName;
    data['userSurname'] = this.userSurname;
    data['catName'] = this.catName;
    data['rating'] = this.rating;
    data['ratingCount'] = this.ratingCount;
    data['file'] = this.file;
    return data;
  }
}
