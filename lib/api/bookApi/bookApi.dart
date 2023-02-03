import 'package:barber/api/mainApi.dart';

class Books {
  List<IBook>? books;
  int? count;

  Books({this.books, this.count});

  Books.fromJson(Map<String, dynamic> json) {
    if (json['books'] != null) {
      books = <IBook>[];
      json['books'].forEach((v) {
        books!.add(new IBook.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.books != null) {
      data['books'] = this.books!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;

    return data;
  }
}


class IBook {
  String? id;
  String? name;
  String? surname;
  String? img;
  String? title;
  String? info;
  String? price;
  String? userId;
  String? catName;
  String? category;
  String? date;
  String? file;
  String? author;
  String? publish;
  String? year;
  String? genre;
  String? bookPage;
  String? age;
  String? language;

  IBook(
      {this.id,
      this.name,
      this.img,
      this.catName,
      this.info,
      this.price,
      this.surname,
      this.title,
      this.userId,
      this.category,
      this.date,
      this.file,
      this.age,
      this.author,
      this.bookPage,
      this.genre,
      this.language,
      this.publish,
      this.year});

  IBook.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    img = json['img'];
    title = json['title'];
    info = json['info'];
    price = json['price'];
    userId = json['userId'];
    catName = json['catName'];
    category = json['category'];
    date = json['date'];
    file = json['file'];
    age = json['age'];
    author = json['author'];
    bookPage = json['pages'];
    genre = json['genre'];
    language = json['lang'];
    publish = json['publish'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['img'] = this.img;
    data['surname'] = this.surname;
    data['title'] = this.title;
    data['info'] = this.info;
    data['price'] = this.price;
    data['userId'] = this.userId;
    data['catName'] = this.catName;
    data['category'] = this.category;
    data['date'] = this.date;
    data['file'] = this.file;
    data['age'] = this.age;
    data['author'] = this.author;
    data['pages'] = this.bookPage;
    data['genre'] = this.genre;
    data['lang'] = this.language;
    data['publish'] = this.publish;
    data['year'] = this.year;
    return data;
  }
}

getBook({String? searchKey, String? page, String? catName}) async {
  List<Books> data = await Api().getData<Books>(params: {
    'type': 'books',
    'subType': 'get',
    'searchKey': searchKey,
    'page': page,
    'categoryKey':catName,
  }, fromJson: Books.fromJson);
  return data ?? [];
}

myBook({required String authToken}) async {
  List<IBook> data = await Api().getData<IBook>(
      params: {'type': 'books', 'subType': 'getMy', 'authToken': authToken},
      fromJson: IBook.fromJson);
  return data ?? [];
}
