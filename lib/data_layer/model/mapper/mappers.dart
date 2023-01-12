import 'package:ElAmlCenter/data_layer/model/patient_response.dart';
import 'package:ElAmlCenter/data_layer/model/therapist_response.dart';
import 'package:ElAmlCenter/domain_layer/Model/TherapistModel.dart';
import 'package:ElAmlCenter/domain_layer/Model/patient.dart';

extension patientResponseExtension on PatientResponse {
  Patient toDomain() => Patient(id,
      therapist: therapist,
      name: name,
      storedAt: storedAt,
      storedBy: storedBy,
      startDate: startDate,
      sessions: sessions,
      phone: phone);
}

extension therapistResponseExtension on TherapistResponse {
  Therapist toDomain() => Therapist(
      specialization: specialization,
      name: name,
      storedAt: storedAt,
      storedBy: storedBy,
      startDate: startDate,
      mail: mail,
      password: password,
      sessions: sessions,
      phone: phone);
}
