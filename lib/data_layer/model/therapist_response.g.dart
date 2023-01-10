// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'therapist_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TherapistResponse _$TherapistResponseFromJson(Map<String, dynamic> json) =>
    TherapistResponse(
      json['specialization'] as String,
      json['name'] as String,
      json['mail'] as String,
      json['password'] as String,
      DateTime.parse(json['startDate'] as String),
      DateTime.parse(json['storedAt'] as String),
      json['storedBy'] as String,
      (json['sessions'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => DateTime.parse(e as String))
                .toList()),
      ),
      json['price'] as int,
      json['phone'] as int,
      json['Gender'] as String,
    );

Map<String, dynamic> _$TherapistResponseToJson(TherapistResponse instance) =>
    <String, dynamic>{
      'specialization': instance.specialization,
      'name': instance.name,
      'mail': instance.mail,
      'password': instance.password,
      'startDate': instance.startDate.toIso8601String(),
      'storedAt': instance.storedAt.toIso8601String(),
      'storedBy': instance.storedBy,
      'sessions': instance.sessions.map(
          (k, e) => MapEntry(k, e.map((e) => e.toIso8601String()).toList())),
      'price': instance.price,
      'phone': instance.phone,
      'Gender': instance.gender,
    };
