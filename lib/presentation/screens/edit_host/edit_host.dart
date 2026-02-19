import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terminal_project/presentation/bloc/edit_host/edit_host_bloc.dart';
import 'package:terminal_project/presentation/components/custom_app_bar.dart';
import 'package:terminal_project/presentation/components/custom_elevated_button.dart';
import 'package:terminal_project/presentation/components/custom_outlined_button.dart';
import 'package:terminal_project/presentation/components/custom_text_form_field.dart';
import 'package:terminal_project/presentation/routes/routes.dart';

class EditHost extends StatelessWidget {
  EditHost({super.key});

  final TextEditingController hostController = TextEditingController();
  final TextEditingController portController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditHostBloc()..add(InitEditHostEvent()),
      child: BlocConsumer<EditHostBloc, EditHostState>(
        listener: (context, state) {
          if (state is EditHostLoaded) {
            hostController.text = state.host;
            portController.text = state.port;
          } else if (state is EditHostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is EditHostDone) {
            // Navigator.pushAndRemoveUntil(context, AppRoutes.productCatalog);
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.productCatalog, ModalRoute.withName("/"));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
              child: AppBar(
                title: Text('edit_host'.tr()),
                actions: [
                  CustomOutlinedButton(child: Icon(Icons.document_scanner)),
                ],
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              children: [
                CustomTextField(
                  label: 'host'.tr(),
                  hintText: 'enter_host'.tr(),
                  keyboardType: TextInputType.url,
                  controller: hostController,
                ),
                CustomTextField(
                  label: 'port'.tr(),
                  hintText: 'enter_port'.tr(),
                  keyboardType: TextInputType.number,
                  controller: portController,
                ),
              ],
            ),
            bottomNavigationBar: CustomElevatedButton(
              text: 'save'.tr(),
              useRounding: true,
              onPressed: () {
                final host = hostController.text;
                final port = portController.text;
                if (port.isEmpty || host.isEmpty) return;
                context.read<EditHostBloc>().add(SaveEditedHost(host: host, port: port));
              },
            ),
          );
        },
      ),
    );
  }
}
