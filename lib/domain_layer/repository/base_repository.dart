import '../../data_layer/model/patient_response.dart';
import '../../data_layer/model/therapist_response.dart';
import '../../domain_layer/Model/patient.dart';
import '../../domain_layer/Model/TherapistModel.dart';
import 'package:dartz/dartz.dart';
import '../../data_layer/data_source/network/failure.dart';

abstract class BaseRepository{

  Future<Either<Failure,Patient>> fetchPatient();
  Future<Either<Failure,Therapist>> fetchTherapist();

  Future<Either<Failure,List<Therapist>>> fetchAllTherapists();
  Future<Either<Failure,List<Patient>>> fetchAllPatients();

  Future<Either<Failure,List<Patient>>> fetchAllPatientsForCurrentTherapist();

  Future<Either<Failure,Patient>> editPatient();
  Future<Either<Failure,Therapist>> editTherapist(TherapistResponse therapistResponse);


  Future<Either<Failure,Patient>> deletePatient();
  Future<Either<Failure,Therapist>> deleteTherapist( TherapistResponse therapistResponse);

  Future<Either<Failure,Patient>> addPatient(PatientResponse patientResponse , TherapistResponse therapistResponse);
  Future<Either<Failure,Therapist>> addTherapist(TherapistResponse therapistResponse);

  Future sendNotification(String patientName , String therapistEmail);
}