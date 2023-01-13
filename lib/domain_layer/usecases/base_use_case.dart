
import 'package:dartz/dartz.dart';

import '../../data_layer/data_source/network/failure.dart';

abstract class BaseUseCase<In,Out>{
  /// In from presentation to the domain
  /// Out the result coming from domain

  Future <Either <Failure ,Out>> execute(In input);
}