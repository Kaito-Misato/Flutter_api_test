// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$_$_UserFromJson(Map<String, dynamic> json) {
  return _$_User(
    name: json['name'] == null
        ? null
        : Name.fromJson(json['name'] as Map<String, dynamic>),
    dob: json['dob'] == null
        ? null
        : Birthday.fromJson(json['dob'] as Map<String, dynamic>),
    location: json['location'] == null
        ? null
        : Address.fromJson(json['location'] as Map<String, dynamic>),
    phone: json['phone'] as String?,
    login: json['login'] == null
        ? null
        : Password.fromJson(json['login'] as Map<String, dynamic>),
    picture: json['picture'] == null
        ? null
        : Picture.fromJson(json['picture'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_$_UserToJson(_$_User instance) => <String, dynamic>{
      'name': instance.name,
      'dob': instance.dob,
      'location': instance.location,
      'phone': instance.phone,
      'login': instance.login,
      'picture': instance.picture,
    };
