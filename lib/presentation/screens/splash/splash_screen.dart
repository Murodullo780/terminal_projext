import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terminal_project/presentation/bloc/splash/splash_bloc.dart';
import 'package:terminal_project/presentation/routes/routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashHaveData) {
          Navigator.pushReplacementNamed(context, AppRoutes.productCatalog);
        } else if (state is SplashNoData) {
          Navigator.pushReplacementNamed(context, AppRoutes.editHost);
        }
      },
      child: Scaffold(),
    );
  }
}
