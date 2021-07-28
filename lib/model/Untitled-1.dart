// class User {
//   late Name name;
//   //late String bithday;
//   //late String address;
//   late String phone;
//   late String password;
//   // late Picture picture;

//   User({
//     required this.name,
//     // required this.bithday,
//     // required this.address,
//     required this.phone,
//     required this.password,
//     // required this.picture,
//   });

//   User.fromJson(Map<String, dynamic> json) {
//     name = json['user_name'];
//     // bithday = json['dob']['date'];
//     // address = json['city'];
//     phone = json['phone'];
//     password = json['password'];
//     // picture  = json['picture']['large'];
//   }

//   Map toJson() {
//     final Map data = new Map();
//     data['name'] = this.name;
//     // data['dob']['date'] = this.bithday;
//     // data['city'] = this.address;
//     data['phone'] = this.phone;
//     data['password'] = this.password;
//     // data['picture'] = this.picture;
//     return data;
//   }
// }

// class Name {
//   // String title;
//   late String first;
//   late String last;

// // this.title,
//   Name({required this.first, required this.last});

//   Name.fromJson(Map json) {
//     // title = json['title'];
//     first = json['first'];
//     last = json['last'];
//   }

//   Map toJson() {
//     final Map data = new Map();
//     // data['title'] = this.title;
//     data['first'] = this.first;
//     data['last'] = this.last;
//     return data;
//   }
// }

class Picture {
  late String large;
  late String medium;
  late String thumbnail;

  Picture({required this.large, required this.medium, required this.thumbnail});

  Picture.fromJson(Map json) {
    large = json['large'];
    medium = json['medium'];
    thumbnail = json['thumbnail'];
  }

  Map toJson() {
    final Map data = new Map();
    data['large'] = this.large;
    data['medium'] = this.medium;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}
