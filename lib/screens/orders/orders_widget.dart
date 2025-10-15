import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:hgocery_app/inner_screens/product_details.dart';
import 'package:hgocery_app/models/orders_model.dart';
import 'package:hgocery_app/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../../providers/products_provider.dart';
import '../../services/utils.dart';
import '../../widgets/text_widget.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({Key? key}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late String orderDateToShow;

  @override
  Widget build(BuildContext context) {
    final ordersModel = Provider.of<OrderModel>(context);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);

    // Debug
    print("OrderWidget: ${ordersModel.orderId}");
    print("ProductId: ${ordersModel.productId}");
    print("ImageUrl: ${ordersModel.imageUrl}");

    final getCurrProduct = productProvider.findProdById(ordersModel.productId);

    // Agar product topilmasa, orderdagi imageUrl ni ishlating
    if (getCurrProduct == null) {
      return ListTile(
        leading: ordersModel.imageUrl.isNotEmpty
            ? FancyShimmerImage(
                width: size.width * 0.2,
                imageUrl: ordersModel.imageUrl, // ✅ Orderdagi imageUrl
                boxFit: BoxFit.cover,
              )
            : Container(
                width: size.width * 0.2,
                height: size.width * 0.2,
                color: Colors.grey[300],
                child: const Icon(Icons.shopping_bag, color: Colors.grey),
              ),
        title: TextWidget(
          text: 'Mahsulot: ${ordersModel.productId}',
          color: color,
          textSize: 16,
        ),
        subtitle: Text('Narx: \$${ordersModel.price}'),
        trailing: TextWidget(text: orderDateToShow, color: color, textSize: 14),
      );
    }

    return ListTile(
      subtitle: Text('Narx: \$${ordersModel.price}'),
      onTap: () {
        // ProductDetails ga o'tish
      },
      leading: FancyShimmerImage(
        width: size.width * 0.2,
        imageUrl: getCurrProduct.imageUrl,
        boxFit: BoxFit.cover,
      ),
      title: TextWidget(
        text: '${getCurrProduct.title}  x${ordersModel.quantity}',
        color: color,
        textSize: 16,
      ),
      trailing: TextWidget(text: orderDateToShow, color: color, textSize: 14),
    );
  }
}
