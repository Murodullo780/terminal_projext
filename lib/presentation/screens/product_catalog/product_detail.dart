import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terminal_project/data/models/product_model/product_model.dart';
import 'package:terminal_project/presentation/bloc/product_catalog/product_catalog_bloc.dart';
import 'package:terminal_project/presentation/components/custom_app_bar.dart';
import 'package:terminal_project/presentation/components/custom_outlined_button.dart';
import 'package:terminal_project/presentation/screens/qr_scanner/qr_scanner.dart';

class ProductDetail extends StatefulWidget {
  final ProductModel productModel;

  const ProductDetail({
    super.key,
    required this.productModel,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late final ProductCatalogBloc productBloc;

  Future<void> _scanProd(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context2) => QrScanner(
          onScan: (value) {
            _addProd(value);
          },
        ),
      ),
    );
  }

  void _addProd(String value) {
    print("RAW: $value");

    final cleaned = _extractMark(value);

    print("CLEANED: $cleaned");

    productBloc.add(
      ProductCatalogAddEvent(widget.productModel, cleaned),
    );
  }

  String _extractMark(String input) {
    final match = RegExp(r'9N\d+').firstMatch(input);
    return match?.group(0) ?? input;
  }

  @override
  void initState() {
    productBloc = BlocProvider.of<ProductCatalogBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCatalogBloc, ProductCatalogState>(
      bloc: productBloc,
      builder: (context, state) {
        return BarcodeKeyboardListener(
          bufferDuration: Duration(milliseconds: 200),
          caseSensitive: true,
          useKeyDownEvent: true,
          onBarcodeScanned: _addProd,
          child: Scaffold(
            appBar: CustomAppBar(
              child: AppBar(
                title: Text(widget.productModel.name),
                actions: [
                  if (state is ProductCatalogLoaded &&
                      (state.data
                              .firstWhere((product) => product.id == widget.productModel.id,
                                  orElse: () => widget.productModel)
                              .marks
                              ?.isNotEmpty ??
                          false))
                    CustomOutlinedButton(
                      child: Icon(Icons.document_scanner),
                      onPressed: () async {
                        _scanProd(context);
                      },
                    ),
                ],
              ),
            ),
            body: Builder(builder: (context) {
              if (state is ProductCatalogLoaded) {
                final ProductModel foundProduct = state.data.firstWhere(
                  (product) => product.id == widget.productModel.id,
                  orElse: () => widget.productModel,
                );
                final ProductModel? currentProd =
                    foundProduct.id == widget.productModel.id ? foundProduct : null;
                final List<String> marks = currentProd?.marks ?? [];
                if (marks.isNotEmpty) {
                  return ListView.separated(
                    itemCount: marks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.code),
                        title: SelectableText(
                          marks[index],
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            productBloc.add(
                              ProductCatalogDeleteEvent(widget.productModel, marks[index]),
                            );
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(height: 1, thickness: 1);
                    },
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SizedBox(
                        height: 50,
                        child: CustomOutlinedButton(
                          child: Text('add_mark'.tr()),
                          onPressed: () => _scanProd(context),
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
          ),
        );
      },
    );
  }
}
