import 'package:ElAmlCenter/data_layer/data_source/network/failure.dart';
import 'package:ElAmlCenter/data_layer/data_source/network/network_client.dart';
import 'package:ElAmlCenter/domain_layer/Model/Client.dart';
import 'package:ElAmlCenter/domain_layer/Model/TherapistData.dart';
import 'package:ElAmlCenter/domain_layer/repository/base_repository.dart';
import 'package:dartz/dartz.dart';

class Repository implements BaseRepository{

  final BaseNetworkClient _NetworkClient;

  Repository(this._NetworkClient);

  @override
  Future<Either<Failure, Patient>> addClient() {
    // TODO: implement addClient
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, TherapistData>> addTherapist() {
    // TODO: implement addTherapist
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Patient>> deleteClient() {
    // TODO: implement deleteClient
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, TherapistData>> deleteTherapist() {
    // TODO: implement deleteTherapist
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Patient>> editClient() {
    // TODO: implement editClient
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, TherapistData>> editTherapist() {
    // TODO: implement editTherapist
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Patient>>> fetchAllClients() {
    // TODO: implement fetchAllClients
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<TherapistData>>> fetchAllTherapists() {
    // TODO: implement fetchAllTherapists
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Patient>> fetchClient() {
    // TODO: implement fetchClient
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, TherapistData>> fetchTherapist() {
    // TODO: implement fetchTherapist
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, dynamic>> sendNotification() {
    // TODO: implement sendNotification
    throw UnimplementedError();
  }



}