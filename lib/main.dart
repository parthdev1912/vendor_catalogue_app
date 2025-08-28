import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor_catalogue_app/app.dart';
import 'package:vendor_catalogue_app/constants/preference_helper.dart';
import 'package:vendor_catalogue_app/core/bloc/bloc_observer.dart';
import 'package:vendor_catalogue_app/core/di/service_locator.dart';
import 'package:vendor_catalogue_app/data/repositories/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceHelper.init(encryptionKey: "VENDORCATALOGUE1");
  setupServiceLocator();
  Bloc.observer = AppBlocObserver();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: serviceLocator<AuthRepository>()),
      ],
      child: MyApp(),
    ),
  );
}

