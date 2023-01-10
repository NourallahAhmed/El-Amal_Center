import '../../domain_layer/Model/Client.dart';
import '../../domain_layer/Model/TherapistData.dart';
import 'package:dartz/dartz.dart';
import '../../data_layer/data_source/network/failure.dart';

abstract class BaseRepository{

  Future<Either<Failure,Patient>> fetchClient();
  Future<Either<Failure,TherapistData>> fetchTherapist();

  Future<Either<Failure,List<TherapistData>>> fetchAllTherapists();
  Future<Either<Failure,List<Patient>>> fetchAllClients();

  Future<Either<Failure,Patient>> editClient();
  Future<Either<Failure,TherapistData>> editTherapist();


  Future<Either<Failure,Patient>> deleteClient();
  Future<Either<Failure,TherapistData>> deleteTherapist();

  Future<Either<Failure,Patient>> addClient();
  Future<Either<Failure,TherapistData>> addTherapist();

  Future<Either<Failure,dynamic>> sendNotification();
}