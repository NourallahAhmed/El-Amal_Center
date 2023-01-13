import 'package:json_annotation/json_annotation.dart';
part 'patient_response.g.dart';

@JsonSerializable(explicitToJson: true)
class PatientResponse {
  @JsonKey(name: "id")
  int id;

  @JsonKey(name: "therapist")
  String therapist;

  @JsonKey(name: "name")
  String name;

  @JsonKey(name: "age")
  int age;

  @JsonKey(name: "caseName")
  String caseName;

  @JsonKey(name: "startDate")
  DateTime startDate;

  @JsonKey(name: "storedAt")
  DateTime storedAt;

  @JsonKey(name: "storedBy")
  String storedBy;

  @JsonKey(name: "sessions")
  Map<String, List<DateTime>> sessions;

  @JsonKey(name: "Durration")
  int Durration;

  @JsonKey(name: "price")
  int price;
  @JsonKey(name: "phone")
  int phone;
  @JsonKey(name: "Gender")
  String gender;

  PatientResponse(
      this.id,
      this.therapist,
      this.name,
      this.age,
      this.caseName,
      this.startDate,
      this.storedAt,
      this.storedBy,
      this.sessions,
      this.Durration,
      this.price,
      this.phone,
      this.gender);


  //fromJson
  factory PatientResponse.fromJson(Map<String, dynamic> json) => _$PatientResponseFromJson(json);

  //toJson
  Map<String, dynamic> toJson() => _$PatientResponseToJson(this);
}
