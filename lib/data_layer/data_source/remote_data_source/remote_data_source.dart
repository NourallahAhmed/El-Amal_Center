import 'dart:ffi';

import 'package:ElAmlCenter/data_layer/model/patient_response.dart';
import 'package:ElAmlCenter/data_layer/model/therapist_response.dart';

abstract class BaseRemoteDataSource {
  ///add client _ therapist
  Future<PatientResponse> addPatient(PatientResponse patientResponse);

  Future<TherapistResponse> addTherapist(TherapistResponse therapistResponse);

  /// edit client _ therapist
  Future<PatientResponse> editPatient(PatientResponse patientResponse);

  Future<TherapistResponse> editTherapist(TherapistResponse therapistResponse);

  /// delete client _ therapist
  Future<PatientResponse> deletePatient(PatientResponse patientResponse);

  Future<TherapistResponse> deleteTherapist(
      TherapistResponse therapistResponse);

  /// fetch client _ therapist
  /// MARK: see in your implementation you need to pass which params
  Future<PatientResponse> fetchPatient(PatientResponse patientResponse);

  Future<TherapistResponse> fetchTherapist(TherapistResponse therapistResponse);

  /// send notification
  Future<Void> sendNotification();
}

class RemoteDataSource extends BaseRemoteDataSource {

  //instance form network client


  @override
  Future<PatientResponse> addPatient(PatientResponse patientResponse) {
    // TODO: implement addPatient
    throw UnimplementedError();
  }

  @override
  Future<TherapistResponse> addTherapist(TherapistResponse therapistResponse) {
    // TODO: implement addTherapist
    throw UnimplementedError();
  }

  @override
  Future<PatientResponse> deletePatient(PatientResponse patientResponse) {
    // TODO: implement deletePatient
    throw UnimplementedError();
  }

  @override
  Future<TherapistResponse> deleteTherapist(
      TherapistResponse therapistResponse) {
    // TODO: implement deleteTherapist
    throw UnimplementedError();
  }

  @override
  Future<PatientResponse> editPatient(PatientResponse patientResponse) {
    // TODO: implement editPatient
    throw UnimplementedError();
  }

  @override
  Future<TherapistResponse> editTherapist(TherapistResponse therapistResponse) {
    // TODO: implement editTherapist
    throw UnimplementedError();
  }

  @override
  Future<PatientResponse> fetchPatient(PatientResponse patientResponse) {
    // TODO: implement fetchPatient
    throw UnimplementedError();
  }

  @override
  Future<TherapistResponse> fetchTherapist(
      TherapistResponse therapistResponse) {
    // TODO: implement fetchTherapist
    throw UnimplementedError();
  }

  @override
  Future<Void> sendNotification() {
    // TODO: implement sendNotification
    throw UnimplementedError();
  }
}
