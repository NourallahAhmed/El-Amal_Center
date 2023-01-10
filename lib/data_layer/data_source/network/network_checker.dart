import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class BaseNetworkChecker{
  Future<bool> get isConnected;
}

class NetworkChecker implements BaseNetworkChecker{

  final InternetConnectionChecker _internetConnectionChecker;


  NetworkChecker(this._internetConnectionChecker);

  @override
  Future<bool> get isConnected => _internetConnectionChecker.hasConnection;

}