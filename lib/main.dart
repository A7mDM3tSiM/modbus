import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:modbus_app/features/history/presentation/blocs/history_bloc.dart';
import 'package:modbus_app/features/setup/presentation/blocs/setup_bloc/setup_bloc.dart';
import 'package:modbus_app/injector.dart';
import 'package:modbus_app/screens/splash/splash_screen.dart';

import 'core/theme/light_theme.dart';
import 'features/request/presentation/blocs/request_bloc/request_bloc.dart';

void main() {
  setup();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RequestBloc>(create: (_) => sl()),
        BlocProvider<SetupBloc>(create: (_) => sl()),
        BlocProvider<HistoryBloc>(create: (_) => sl()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
