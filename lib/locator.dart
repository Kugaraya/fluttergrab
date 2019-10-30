import 'package:fluttergrab/core/models/counter.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();

void setupLocator(){
  locator.registerLazySingleton(() => Counter(0));
}