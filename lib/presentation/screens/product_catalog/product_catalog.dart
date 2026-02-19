import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terminal_project/core/constants/colors.dart';
import 'package:terminal_project/presentation/bloc/product_catalog/product_catalog_bloc.dart';
import 'package:terminal_project/presentation/components/custom_app_bar.dart';
import 'package:terminal_project/presentation/components/custom_outlined_button.dart';
import 'package:terminal_project/presentation/routes/routes.dart';
import 'package:terminal_project/presentation/screens/product_catalog/widget/product_item.dart';

class ProductCatalog extends StatefulWidget {
  const ProductCatalog({super.key});

  @override
  State<ProductCatalog> createState() => _ProductCatalogState();
}

class _ProductCatalogState extends State<ProductCatalog> {
  Widget _drawer() {
    Widget item(String title, Widget value, {void Function()? onTap}) {
      return ListTile(
        title: Text(title.tr()),
        leading: value,
        onTap: () {
          Navigator.pop(context);
          onTap != null ? onTap() : null;
        },
      );
    }

    return Container(
      width: MediaQuery.sizeOf(context).width * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  height: 100,
                  color: AppColors.primary,
                ),
                item(
                  'settings',
                  Icon(Icons.settings),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: Text('Version: 1.0.0'),
          )
        ],
      ),
    );
  }

  late final ProductCatalogBloc productBloc;

  @override
  void initState() {
    productBloc = BlocProvider.of<ProductCatalogBloc>(context);
    productBloc.add(ProductCatalogGetEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCatalogBloc, ProductCatalogState>(
      bloc: productBloc,
      builder: (context, state) {
        final bloc = productBloc;
        return Scaffold(
          drawer: _drawer(),
          appBar: CustomAppBar(
            leading: Builder(
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
                  child: CustomOutlinedButton(
                    child: Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                );
              },
            ),
            child: AppBar(
              title: Text('product_catalog'.tr()),
              actions: [
                CustomOutlinedButton(
                  child: Icon(Icons.refresh),
                  onPressed: () => bloc.add(ProductCatalogGetEvent()),
                ),
              ],
            ),
          ),
          body: BlocBuilder<ProductCatalogBloc, ProductCatalogState>(
            builder: (context, state) {
              if (state is ProductCatalogLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ProductCatalogError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'error'.tr(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          state.message.tr(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.red,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is ProductCatalogLoaded) {
                return GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return ProductItem(
                      item: state.data[index],
                      index: index,
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        );
      },
    );
  }
}
