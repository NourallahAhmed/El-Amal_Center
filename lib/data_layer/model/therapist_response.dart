import 'package:json_annotation/json_annotation.dart';
part 'therapist_response.g.dart';

@JsonSerializable()
class TherapistResponse {
  @JsonKey(name: "specialization")
  String specialization;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "mail")
  String mail;
  @JsonKey(name: "password")
  String password;
  @JsonKey(name: "startDate")
  DateTime startDate;
  @JsonKey(name: "storedAt")
  DateTime storedAt;
  @JsonKey(name: "storedBy")
  String storedBy;
  @JsonKey(name: "sessions")
  Map<String, List<DateTime>> sessions; //string name of patient
  @JsonKey(name: "price")
  int price;
  @JsonKey(name: "phone")
  int phone;
  @JsonKey(name: "Gender")
  String gender;

  TherapistResponse(
      this.specialization,
      this.name,
      this.mail,
      this.password,
      this.startDate,
      this.storedAt,
      this.storedBy,
      this.sessions,
      this.price,
      this.phone,
      this.gender);

  //fromJson
  factory TherapistResponse.fromJson(Map<String, dynamic> json) => _$TherapistResponseFromJson(json);

  //toJson
  Map<String, dynamic> toJson() => _$TherapistResponseToJson(this);
}
