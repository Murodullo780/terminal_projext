import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terminal_project/presentation/bloc/edit_host/edit_host_bloc.dart';
import 'package:terminal_project/presentation/components/custom_app_bar.dart';
import 'package:terminal_project/presentation/components/custom_elevated_button.dart';
import 'package:terminal_project/presentation/components/custom_outlined_button.dart';
import 'package:terminal_project/presentation/components/custom_text_form_field.dart';
import 'package:terminal_project/presentation/routes/routes.dart';
import 'package:terminal_project/presentation/screens/qr_scanner/qr_scanner.dart';

class EditHost extends StatelessWidget {
  EditHost({super.key});

  final TextEditingController hostController = TextEditingController();
  final TextEditingController portController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    void saveEditedHost(BuildContext context2){
      final host = hostController.text;
      final port = portController.text;
      if (port.isEmpty || host.isEmpty) return;
      context2.read<EditHostBloc>().add(SaveEditedHost(host: host, port: port));
    }

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
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.productCatalog, ModalRoute.withName("/"));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
              child: AppBar(
                title: Text('edit_host'.tr()),
                actions: [
                  CustomOutlinedButton(
                    child: Icon(Icons.document_scanner),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QrScanner(
                            onScan: (value){
                              try {
                                final parts = value.split(':');

                                if (parts.length != 2) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Invalid QR format')),
                                  );
                                  return;
                                }

                                final host = parts[0];
                                final port = parts[1];

                                if (int.tryParse(port) == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Invalid port')),
                                  );
                                  return;
                                }

                                hostController.text = host;
                                portController.text = port;

                                saveEditedHost(context);
                              } catch (_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('QR parsing error')),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
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
                saveEditedHost(context);
              },
            ),
          );
        },
      ),
    );
  }
}
