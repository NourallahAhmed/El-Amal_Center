
import 'package:ElAmlCenter/data_layer/data_source/network/failure.dart';
import 'package:ElAmlCenter/domain_layer/Model/patient.dart';
import 'package:ElAmlCenter/domain_layer/repository/base_repository.dart';
import 'package:ElAmlCenter/domain_layer/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

/// fetch the patients for the current therapist

class HomeUseCase extends BaseUseCase<void , List<Patient>>{
  final BaseRepository _repository;

  HomeUseCase(this._repository);

  @override
  Future<Either<Failure, List<Patient>>> execute(void input) async {
    return await _repository.fetchAllPatientsForCurrentTherapist();
  }

}