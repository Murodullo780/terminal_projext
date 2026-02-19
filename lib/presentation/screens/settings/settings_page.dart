import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:terminal_project/presentation/components/custom_app_bar.dart';
import 'package:terminal_project/presentation/routes/routes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(child: AppBar(title: Text('settings'.tr()),)),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.wifi),
            title: Text('edit_host'.tr()),
            onTap: () => Navigator.pushNamed(context, AppRoutes.editHost),
          ),
        ],
      ),
    );
  }
}
