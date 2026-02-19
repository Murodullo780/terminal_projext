import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:terminal_project/core/theme/app_themes.dart';
import 'package:terminal_project/presentation/bloc/product_catalog/product_catalog_bloc.dart';
import 'package:terminal_project/presentation/bloc/splash/splash_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terminal_project/presentation/cubit/settings/settings_cubit.dart';
import 'package:terminal_project/presentation/custom_loading/custom_loading.dart';
import 'package:terminal_project/presentation/routes/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SplashBloc()..add(InitSplashEvent())),
        BlocProvider(create: (context) => ProductCatalogBloc()),
        BlocProvider(create: (_) => SettingsCubit(initialLocale: EasyLocalization.of(context)!.locale)),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp(
            title: 'Terminal',
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: settingsState.themeMode,
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            builder: (context, child) {
              return Stack(
                children: [
                  child!,
                  CustomEasyLoading(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
