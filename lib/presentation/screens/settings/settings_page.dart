import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terminal_project/presentation/components/custom_app_bar.dart';
import 'package:terminal_project/presentation/cubit/settings/settings_cubit.dart';
import 'package:terminal_project/presentation/routes/routes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        child: AppBar(title: Text('settings'.tr())),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final selectedLocale = Locale(state.locale.languageCode);
          return ListView(
            children: [
              ListTile(
                leading: Icon(Icons.wifi),
                title: Text('edit_host'.tr()),
                onTap: () => Navigator.pushNamed(context, AppRoutes.editHost),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                leading: Icon(Icons.language),
                title: Text('language'.tr()),
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton<Locale>(
                    value: selectedLocale,
                    items: [
                      DropdownMenuItem(
                        value: const Locale('ru'),
                        child: Text('russian'.tr()),
                      ),
                      DropdownMenuItem(
                        value: const Locale('uz'),
                        child: Text('uzbek'.tr()),
                      ),
                    ],
                    onChanged: (locale) async {
                      if (locale == null) return;
                      await context.setLocale(locale);
                      if (context.mounted) {
                        context.read<SettingsCubit>().setLocale(locale);
                      }
                    },
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text('dark_mode'.tr()),
                trailing: Switch(
                  value: state.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    context.read<SettingsCubit>().setDarkMode(value);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
