import 'package:ElAmlCenter/data_layer/data_source/network/failure.dart';
import 'package:ElAmlCenter/data_layer/model/mapper/mappers.dart';
import 'package:ElAmlCenter/data_layer/model/patient_response.dart';
import 'package:ElAmlCenter/data_layer/model/therapist_response.dart';
import 'package:ElAmlCenter/domain_layer/Model/patient.dart';
import 'package:ElAmlCenter/domain_layer/Model/TherapistModel.dart';
import 'package:ElAmlCenter/domain_layer/repository/base_repository.dart';
import 'package:dartz/dartz.dart';
import '../data_source/network/network_checker.dart';
import '../data_source/remote_data_source/remote_data_source.dart';

class Repository implements BaseRepository {
  final BaseRemoteDataSource _baseRemoteDataSource;

  final NetworkChecker _networkChecker;

  Repository(this._baseRemoteDataSource, this._networkChecker);

  @override
  Future<Either<Failure, Patient>> addPatient(PatientResponse patientResponse,
      TherapistResponse therapistResponse) async {
    if (await _networkChecker.isConnected) {
      Failure? failure;
      Patient? patient;
      var result =
          await _baseRemoteDataSource
              .addPatient(patientResponse, therapistResponse);
      result.fold((l) => failure = l, (r) => patient = r.toDomain());

      if (result.isLeft()) {
        return Left(failure!);
      } else {
        return Right(patient!);
      }
    } else {
      return Left(Failure(404, "no Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, Therapist>> addTherapist(
      TherapistResponse therapistResponse) async {
    if (await _networkChecker.isConnected) {
      Failure? failure;
      Therapist? patient;
      var result = await _baseRemoteDataSource
          .addTherapist(therapistResponse);
      result.fold((l) => failure = l, (r) => patient = r.toDomain());

      if (result.isLeft()) {
        return Left(failure!);
      } else {
        return Right(patient!);
      }
    } else {
      return Left(Failure(404, "no Internet Connection"));
    }
  }


  // TODO: implement deletePatient

  @override
  Future<Either<Failure, Patient>> deletePatient() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Therapist>> deleteTherapist(
      TherapistResponse therapistResponse) async {
    if (await _networkChecker.isConnected) {
      Failure? failure;
      Therapist? patient;
      var result = await _baseRemoteDataSource
          .addTherapist(therapistResponse);
      result.fold((l) => failure = l, (r) => patient = r.toDomain());

      if (result.isLeft()) {
        return Left(failure!);
      } else {
        return Right(patient!);
      }
    } else {
      return Left(Failure(404, "no Internet Connection"));
    }
  }

  // TODO: implement editPatient

  @override
  Future<Either<Failure, Patient>> editPatient() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Therapist>> editTherapist(
      TherapistResponse therapistResponse) async {
    if (await _networkChecker.isConnected) {
      Failure? failure;
      Therapist? patient;
      var result = await _baseRemoteDataSource
          .addTherapist(therapistResponse);
      result.fold((l) => failure = l, (r) => patient = r.toDomain());

      if (result.isLeft()) {
        return Left(failure!);
      } else {
        return Right(patient!);
      }
    } else {
      return Left(Failure(404, "no Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, List<Patient>>> fetchAllPatients() async {
    if (await _networkChecker.isConnected) {
      Failure? failure;
      List<Patient> allPatients = [];
      var result = await _baseRemoteDataSource
          .fetchAllPatients();
      result.fold((l) => failure = l,
          (r) => r.map((patient) => allPatients.add(patient.toDomain())));

      if (result.isLeft()) {
        return Left(failure!);
      } else {
        return Right(allPatients);
      }
    } else {
      return Left(Failure(404, "no Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, List<Therapist>>> fetchAllTherapists() async {
    if (await _networkChecker.isConnected) {
      Failure? failure;
      List<Therapist> allTherapists = [];
      var result = await _baseRemoteDataSource
          .fetchAllTherapists();
      result.fold((l) => failure = l,
              (r) => r.map((therapist) => allTherapists.add(therapist.toDomain())));

      if (result.isLeft()) {
        return Left(failure!);
      } else {
        return Right(allTherapists);
      }
    } else {
      return Left(Failure(404, "no Internet Connection"));
    }
  }

  // TODO: implement fetchPatient
  @override
  Future<Either<Failure, Patient>> fetchPatient() {
    throw UnimplementedError();
  }

  // TODO: implement fetchTherapist
  @override
  Future<Either<Failure, Therapist>> fetchTherapist() {
    throw UnimplementedError();
  }

  @override
  Future sendNotification(String patientName , String therapistEmail) async {
    if (await _networkChecker.isConnected) {
       await _baseRemoteDataSource
          .sendNotification(therapistEmail, patientName);
    } else{

    }
  }
}
