
//id, fullname, country, isCompleted, date, gender, email, areaofwork, empstatus, phone, graduationclass

class Account {
  int? id;
  String? fullname;
  String? country;
  int? isCompleted;
  String? date;
  // String? startTime;
  // String? endTime;
  int? color;
  // int? remind;
  // String? repeat;
  String? gender;
  String? email;
  String? areaofwork;
  String? empstatus;
  String? phone;
  String? graduationclass;
  Account({
    this.id,
    this.fullname,
    this.country,
    this.isCompleted,
    this.date,
    this.gender,
    this.email,
    this.areaofwork,
    this.empstatus,
    this.phone,
    this.graduationclass,
    // this.startTime,
    // this.endTime,
    // this.color,
    // this.remind,
    // this.repeat,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'country': country,
      'isCompleted': isCompleted,
      'date': date,
      'gender': gender,
      'email': email,
      'areaofwork':areaofwork,
      'empstatus':empstatus,
      'phone':phone,
      'graduationclass':graduationclass,
      // 'startTime': startTime,
      // 'endTime': endTime,
      // 'color': color,
      // 'remind': remind,
      // 'repeat': repeat,
    };
  }

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    country = json['country'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    gender =json['gender'];
    email = json['email'];
    areaofwork = json['areaofwork'];
    empstatus = json['empstatus'];
    phone = json['phone'];
    graduationclass = json['graduationclass'];
    // startTime = json['startTime'];
    // endTime = json['endTime'];
    // color = json['color'];
    // remind = json['remind'];
    // repeat = json['repeat'];
  }
}