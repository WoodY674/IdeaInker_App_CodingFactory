/// Retourne la liste des avis
class Notices {
  List<AllNotices>? allNotices;
  String? average;

  Notices({this.allNotices, this.average});

  Notices.fromJson(Map<String, dynamic> json) {
    if (json['all_notices'] != null) {
      allNotices = <AllNotices>[];
      json['all_notices'].forEach((v) {
        allNotices!.add(new AllNotices.fromJson(v));
      });
    }
    average = json['average'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.allNotices != null) {
      data['all_notices'] = this.allNotices!.map((v) => v.toJson()).toList();
    }
    data['average'] = this.average;
    return data;
  }
}

class AllNotices {
  int? noticeId;
  int? stars;
  String? comment;

  AllNotices({this.noticeId, this.stars, this.comment});

  AllNotices.fromJson(Map<String, dynamic> json) {
    noticeId = json['notice_id'];
    stars = json['stars'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notice_id'] = this.noticeId;
    data['stars'] = this.stars;
    data['comment'] = this.comment;
    return data;
  }
}