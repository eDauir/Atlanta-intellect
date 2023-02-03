class IComments {
  List<Comments>? comments;
  int? count;

  IComments({this.comments, this.count});

  IComments.fromJson(Map<String, dynamic> json) {
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class Comments {
  String? id;
  String? userId;
  String? productId;
  String? rating;
  String? text;
  String? date;
  String? name;
  String? surname;
  String? avatar;
  String? likes;

  Comments(
      {this.id,
      this.userId,
      this.productId,
      this.rating,
      this.text,
      this.date,
      this.name,
      this.surname,
      this.avatar,
      this.likes});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    productId = json['productId'];
    rating = json['rating'];
    text = json['text'];
    date = json['date'];
    name = json['name'];
    surname = json['surname'];
    avatar = json['avatar'];
    likes = json['likes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['productId'] = this.productId;
    data['rating'] = this.rating;
    data['text'] = this.text;
    data['date'] = this.date;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['avatar'] = this.avatar;
    data['likes'] = this.likes;
    return data;
  }
}