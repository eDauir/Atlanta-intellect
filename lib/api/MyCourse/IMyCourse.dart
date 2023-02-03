class IMyCourse {
  List<ProductsCourse>? products;
  int? count;

  IMyCourse({this.products, this.count});

  IMyCourse.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <ProductsCourse>[];
      json['products'].forEach((v) {
        products!.add(new ProductsCourse.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class ProductsCourse {
String? id;
  String? name;
  String? price;
  String? status;
  String? payboxLink;
  String? file;
  String? lessonsCount;
  String? progressCount;
  String? progressDuration;


  ProductsCourse(
      {this.id,
      this.name,
      this.price,
      this.status,
      this.payboxLink,
      this.file,
      this.lessonsCount,
      this.progressCount,
      this.progressDuration});

  ProductsCourse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    status = json['status'];
    payboxLink = json['payboxLink'];
    file = json['file'];
    lessonsCount = json['lessonsCount'];
    progressCount = json['progressCount'];
    progressDuration = json['progressDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['status'] = this.status;
    data['payboxLink'] = this.payboxLink;
    data['file'] = this.file;
    data['lessonsCount'] = this.lessonsCount;
    data['progressCount'] = this.progressCount;
    data['progressDuration'] = this.progressDuration;
    return data;
  }
}