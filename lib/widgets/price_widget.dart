import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 🧩 qo‘shildi
import 'package:hgocery_app/widgets/text_widget.dart';
import '../services/utils.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    Key? key,
    required this.salePrice,
    required this.price,
    required this.textPrice,
    required this.isOnSale,
  }) : super(key: key);

  final double salePrice, price;
  final String textPrice;
  final bool isOnSale;

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;

    // 🔹 Butun raqam va minglik format
    final formatCurrency = NumberFormat('#,##0', 'en_US');

    // 🧼 textPrice ichidagi bo‘sh joy va vergullarni olib tashlaymiz
    final int quantity =
        int.tryParse(textPrice.replaceAll(RegExp(r'[^\d]'), '')) ?? 1;

    double userPrice = isOnSale ? salePrice : price;
    double total = userPrice * quantity;

    return FittedBox(
      child: Row(
        children: [
          // ✅ Asosiy narx
          TextWidget(
            text: '₩${formatCurrency.format(total)}',
            color: Colors.green,
            textSize: 18,
          ),
          const SizedBox(width: 5),

          // 🔁 Agar aksiya bo‘lsa — eski narxni chizib ko‘rsatamiz
          Visibility(
            visible: isOnSale,
            child: Text(
              '₩${formatCurrency.format(price * quantity)}',
              style: TextStyle(
                fontSize: 15,
                color: color,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
