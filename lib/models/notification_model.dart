class MessageList {
  int? id;
  String? title;
  String? phone;
  String? body;
  bool? isRead;
  String? imgUrl;
  String? url;
  String? browserStatus;
  String? typeName;
  String? createAt;
  String? updateAt;

  MessageList(
      {this.id,
      this.title,
      this.phone,
      this.body,
      this.isRead,
      this.imgUrl,
      this.url,
      this.browserStatus,
      this.typeName,
      this.createAt,
      this.updateAt});

  MessageList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    phone = json['phone'];
    body = json['body'];
    isRead = json['isRead'];
    imgUrl = json['imgUrl'];
    url = json['url'];
    browserStatus = json['BrowserStatus'];
    typeName = json['typeName'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['phone'] = phone;
    data['body'] = body;
    data['isRead'] = isRead;
    data['imgUrl'] = imgUrl;
    data['url'] = url;
    data['BrowserStatus'] = browserStatus;
    data['typeName'] = typeName;
    data['createAt'] = createAt;
    data['updateAt'] = updateAt;
    return data;
  }
}

class TopicList {
  List<Topics>? topics;

  TopicList({this.topics});

  TopicList.fromJson(Map<String, dynamic> json) {
    if (json['topics'] != null) {
      topics = <Topics>[];
      json['topics'].forEach((v) {
        topics!.add(Topics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (topics != null) {
      data['topics'] = topics!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Topics {
  int? id;
  String? name;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  bool? isShow;

  Topics(
      {this.id,
      this.name,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.isShow});

  Topics.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isShow = json['isShow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['isShow'] = isShow;
    return data;
  }
}
