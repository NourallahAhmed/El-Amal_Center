// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientResponse _$PatientResponseFromJson(Map<String, dynamic> json) =>
    PatientResponse(
      json['id'] as int,
      json['therapist'] as String,
      json['name'] as String,
      json['age'] as int,
      json['caseName'] as String,
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
      json['Durration'] as int,
      json['price'] as int,
      json['phone'] as int,
      json['Gender'] as String,
    );

Map<String, dynamic> _$PatientResponseToJson(PatientResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'therapist': instance.therapist,
      'name': instance.name,
      'age': instance.age,
      'caseName': instance.caseName,
      'startDate': instance.startDate.toIso8601String(),
      'storedAt': instance.storedAt.toIso8601String(),
      'storedBy': instance.storedBy,
      'sessions': instance.sessions.map(
          (k, e) => MapEntry(k, e.map((e) => e.toIso8601String()).toList())),
      'Durration': instance.Durration,
      'price': instance.price,
      'phone': instance.phone,
      'Gender': instance.gender,
    };
