
import 'package:ElAmlCenter/data_layer/data_source/network/network_checker.dart';
import 'package:ElAmlCenter/data_layer/data_source/network/network_client.dart';
import 'package:ElAmlCenter/data_layer/data_source/remote_data_source/remote_data_source.dart';
import 'package:ElAmlCenter/data_layer/repository/repository.dart';
import 'package:ElAmlCenter/domain_layer/repository/base_repository.dart';
import 'package:ElAmlCenter/domain_layer/usecases/home_use_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation_layer/HomePage/ViewModel/HomePageVM.dart';

var instance = GetIt.instance;
Future initAppModule() async {
  
  instance.registerLazySingleton<BaseRepository>(() => Repository(instance<BaseRemoteDataSource>(), instance<NetworkChecker>()));
  instance.registerLazySingleton<BaseRemoteDataSource>(() => RemoteDataSource(instance<NetworkChecker>(), instance<NetworkClient>()));
  instance.registerLazySingleton<NetworkChecker>(() => NetworkChecker(InternetConnectionChecker()));
  instance.registerLazySingleton<NetworkClient>(() => NetworkClient(instance(), instance(), instance()));
  // instance.registerLazySingleton<SharedPreferences>(() => SharedPreferences.getInstance());
  instance.registerLazySingleton(() =>  FirebaseDatabase.instance);
  instance.registerLazySingleton(() =>  FirebaseFirestore.instance);
  instance.registerLazySingleton(() => FirebaseAuth.instance);
}
 initHomeModule() {
  if(!GetIt.I.isRegistered<HomeUseCase>()){
    instance.registerFactory<HomeUseCase>(() => HomeUseCase(instance<BaseRepository>()));
    instance.registerFactory<HomePageVM>(() => HomePageVM(instance<HomeUseCase>()));

  }
}