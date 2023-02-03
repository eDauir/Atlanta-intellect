class IFaq {
  List<Faq>? faq;
  int? count;

  IFaq({this.faq, this.count});

  IFaq.fromJson(Map<String, dynamic> json) {
    if (json['faq'] != null) {
      faq = <Faq>[];
      json['faq'].forEach((v) {
        faq!.add(new Faq.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.faq != null) {
      data['faq'] = this.faq!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class Faq {
  String? id;
  String? question;
  String? answer;
  String? date;

  Faq({this.id, this.question, this.answer, this.date});

  Faq.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['date'] = this.date;
    return data;
  }
}