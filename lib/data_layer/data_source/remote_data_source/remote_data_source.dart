import 'dart:ffi';

import 'package:ElAmlCenter/data_layer/data_source/network/failure.dart';
import 'package:ElAmlCenter/data_layer/data_source/network/network_checker.dart';
import 'package:ElAmlCenter/data_layer/data_source/network/network_client.dart';
import 'package:ElAmlCenter/data_layer/model/patient_response.dart';
import 'package:ElAmlCenter/data_layer/model/therapist_response.dart';
import 'package:dartz/dartz.dart';

abstract class BaseRemoteDataSource {
  ///add client _ therapist
  Future<Either<Failure, PatientResponse>> addPatient(
      PatientResponse patientResponse, TherapistResponse therapistResponse);

  Future<Either<Failure, TherapistResponse>> addTherapist(
      TherapistResponse therapistResponse);

  /// edit client _ therapist
  Future<Either<Failure, PatientResponse>> editPatient(
      PatientResponse patientResponse);

  Future<Either<Failure, TherapistResponse>> editTherapist(
      TherapistResponse therapistResponse , PatientResponse patientResponse);

  /// delete client _ therapist
  Future<Either<Failure, PatientResponse>> deletePatient(
      PatientResponse patientResponse);

  Future<Either<Failure, TherapistResponse>> deleteTherapist(
      TherapistResponse therapistResponse);

  /// fetch client _ therapist
  /// MARK: see in your implementation you need to pass which params
  Future<Either<Failure, PatientResponse>> fetchPatient(
      PatientResponse patientResponse);

  Future<Either<Failure, TherapistResponse>> fetchTherapist(
      TherapistResponse therapistResponse);

  Future<Either<Failure, List<PatientResponse>>> fetchAllPatients();

  Future<Either<Failure, List<TherapistResponse>>> fetchAllTherapists();

  /// send notification
  Future sendNotification(
      String patientName, String therapistEmail);
}

class RemoteDataSource extends BaseRemoteDataSource {
  final NetworkChecker _networkChecker;
  final NetworkClient _networkClient;

  RemoteDataSource(this._networkChecker, this._networkClient);

  @override
  Future sendNotification(   String patientName, String therapistEmail) async {
    if (await _networkChecker.isConnected) {
      await _networkClient.sendNotification(
          therapistEmail, patientName);
    }
  }

  @override
  Future<Either<Failure, PatientResponse>> addPatient(
      PatientResponse patientResponse,
      TherapistResponse therapistResponse) async {
    if (await _networkChecker.isConnected) {
      Failure? failure;
      var result =
          await _networkClient.addPatient(patientResponse, therapistResponse);

      result.isLeft() ? result.fold((l) => failure = l, (r) => null) : null;

      return result.isRight() ? Right(patientResponse) : Left(failure!);
    } else {
      return Left(Failure(0, "No internet Connection"));
    }
  }

  @override
  Future<Either<Failure, TherapistResponse>> addTherapist(
      TherapistResponse therapistResponse) async {
    if (await _networkChecker.isConnected) {
      Failure? failure;
      var result = await _networkClient.addTherapist(therapistResponse);

      result.isLeft() ? result.fold((l) => failure = l, (r) => null) : null;

      return result.isRight() ? Right(therapistResponse) : Left(failure!);
    } else {
      return Left(Failure(0, "No internet Connection"));
    }
  }

  // TODO: implement deletePatient

  @override
  Future<Either<Failure, PatientResponse>> deletePatient(
      PatientResponse patientResponse) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, TherapistResponse>> deleteTherapist(
      TherapistResponse therapistResponse) async {
    if (await _networkChecker.isConnected) {
      Failure? failure;
      var result = await _networkClient.deleteTherapist(therapistResponse);

      result.isLeft() ? result.fold((l) => failure = l, (r) => null) : null;

      return result.isRight() ? Right(therapistResponse) : Left(failure!);
    } else {
      return Left(Failure(0, "No internet Connection"));
    }
  }

  // TODO: implement editPatient
  @override
  Future<Either<Failure, PatientResponse>> editPatient(
      PatientResponse patientResponse) {
    throw UnimplementedError();
  }


  @override
  Future<Either<Failure, TherapistResponse>> editTherapist(
      TherapistResponse therapistResponse , PatientResponse patientResponse) async {
    if (await _networkChecker.isConnected) {
      Failure? failure;
      var result = await _networkClient.updateTherapist(patientResponse,therapistResponse);

      result.isLeft() ? result.fold((l) => failure = l, (r) => null) : null;

      return result.isRight() ? Right(therapistResponse) : Left(failure!);
    } else {
      return Left(Failure(0, "No internet Connection"));
    }
  }


  // TODO: implement fetchPatient

  @override
  Future<Either<Failure, PatientResponse>> fetchPatient(
      PatientResponse patientResponse) {
    throw UnimplementedError();
  }

  // TODO: implement fetchTherapist
  @override
  Future<Either<Failure, TherapistResponse>> fetchTherapist(
      TherapistResponse therapistResponse) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<PatientResponse>>> fetchAllPatients() async{
    if (await _networkChecker.isConnected) {
      Failure? failure;
      List<PatientResponse> listOfPatients = [];
      var result = await _networkClient.fetchPatients();

      result.fold((l) => failure = l, (r) => r.map((patient) => listOfPatients.add(patient)));
      result.isLeft() ? result.fold((l) => failure = l, (r) => null) : null;

      return result.isRight() ? Right(listOfPatients) : Left(failure!);
    } else {
      return Left(Failure(0, "No internet Connection"));
    }
  }

  @override
  Future<Either<Failure, List<TherapistResponse>>> fetchAllTherapists() async {
    if (await _networkChecker.isConnected) {
      Failure? failure;
      List<TherapistResponse> listOfTherapists = [];
      var result = await _networkClient.fetchTherapists();

      result.fold((l) => failure = l, (r) => r.map((therapist) => listOfTherapists.add(therapist)));
      result.isLeft() ? result.fold((l) => failure = l, (r) => null) : null;

      return result.isRight() ? Right(listOfTherapists) : Left(failure!);
    } else {
      return Left(Failure(0, "No internet Connection"));
    }
  }
}
