import 'package:flutter/material.dart';
import 'package:terminal_project/core/constants/colors.dart';
import 'package:terminal_project/data/models/product_model/product_model.dart';
import 'package:terminal_project/presentation/screens/product_catalog/product_detail.dart';

class ProductItem extends StatelessWidget {
  final ProductModel item;
  final int index;

  const ProductItem({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetail(productModel: item),
        ),
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.prodColors[(index % AppColors.prodColors.length)].withAlpha(150),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item.name,
                style:
                    Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
            Text(item.category,
                style:
                    Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('${item.price} sum',
                style:
                    Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
