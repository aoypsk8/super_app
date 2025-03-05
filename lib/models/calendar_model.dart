class CalendarModel {
  String? imageUrl;
  String? monthFullName;
  List<ListDates>? listDates;
  List<ListSpecial>? listSpecial;
  List<Notes>? notes;

  CalendarModel({this.imageUrl, this.monthFullName, this.listDates, this.listSpecial, this.notes});

  CalendarModel.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    monthFullName = json['monthFullName'];
    if (json['listDates'] != null) {
      listDates = <ListDates>[];
      json['listDates'].forEach((v) {
        listDates!.add(new ListDates.fromJson(v));
      });
    }
    if (json['listSpecial'] != null) {
      listSpecial = <ListSpecial>[];
      json['listSpecial'].forEach((v) {
        listSpecial!.add(new ListSpecial.fromJson(v));
      });
    }
    if (json['notes'] != null) {
      notes = <Notes>[];
      json['notes'].forEach((v) {
        notes!.add(new Notes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageUrl;
    data['monthFullName'] = this.monthFullName;
    if (this.listDates != null) {
      data['listDates'] = this.listDates!.map((v) => v.toJson()).toList();
    }
    if (this.listSpecial != null) {
      data['listSpecial'] = this.listSpecial!.map((v) => v.toJson()).toList();
    }
    if (this.notes != null) {
      data['notes'] = this.notes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListDates {
  String? fullDay;
  String? christDay;
  String? buddhaDay;
  String? strDay;
  String? icon;
  String? color;
  bool? isToday;

  ListDates({this.fullDay, this.christDay, this.buddhaDay, this.strDay, this.icon, this.color, this.isToday});

  ListDates.fromJson(Map<String, dynamic> json) {
    fullDay = json['fullDay'];
    christDay = json['christDay'];
    buddhaDay = json['buddhaDay'];
    strDay = json['strDay'];
    icon = json['icon'];
    color = json['color'];
    isToday = json['isToday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullDay'] = this.fullDay;
    data['christDay'] = this.christDay;
    data['buddhaDay'] = this.buddhaDay;
    data['strDay'] = this.strDay;
    data['icon'] = this.icon;
    data['color'] = this.color;
    data['isToday'] = this.isToday;
    return data;
  }
}

class ListSpecial {
  String? date;
  String? description;

  ListSpecial({this.date, this.description});

  ListSpecial.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['description'] = this.description;
    return data;
  }
}

class Notes {
  int? noteId;
  String? description;
  String? date;
  String? title;
  int? iconId;
  String? iconPath;

  Notes({this.noteId, this.description, this.date, this.title, this.iconId, this.iconPath});

  Notes.fromJson(Map<String, dynamic> json) {
    noteId = json['noteId'];
    description = json['description'];
    date = json['date'];
    title = json['title'];
    iconId = json['iconId'];
    iconPath = json['iconPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['noteId'] = this.noteId;
    data['description'] = this.description;
    data['date'] = this.date;
    data['title'] = this.title;
    data['iconId'] = this.iconId;
    data['iconPath'] = this.iconPath;
    return data;
  }
}
