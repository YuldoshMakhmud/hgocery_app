import 'package:flutter/material.dart';
import 'package:hgocery_app/widgets/back_widget.dart';
import 'package:hgocery_app/widgets/empty_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/orders_provider.dart';
import '../../services/utils.dart';
import '../../widgets/text_widget.dart';
import 'orders_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    try {
      await ordersProvider.fetchOrders();
    } catch (e) {
      print("Xatolik: $e");
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final ordersList = ordersProvider.getOrders;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: const BackWidget(),
          elevation: 0,
          title: TextWidget(
            text: 'Your orders',
            color: color,
            textSize: 24.0,
            isTitle: true,
          ),
          backgroundColor: Theme.of(
            context,
          ).scaffoldBackgroundColor.withOpacity(0.9),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasError) {
      return Scaffold(
        appBar: AppBar(
          leading: const BackWidget(),
          elevation: 0,
          title: TextWidget(
            text: 'Your orders',
            color: color,
            textSize: 24.0,
            isTitle: true,
          ),
          backgroundColor: Theme.of(
            context,
          ).scaffoldBackgroundColor.withOpacity(0.9),
        ),
        body: const Center(
          child: Text('Xatolik yuz berdi. Qaytadan urinib ko\'ring.'),
        ),
      );
    }

    return ordersList.isEmpty
        ? Scaffold(
            appBar: AppBar(
              leading: const BackWidget(),
              elevation: 0,
              title: TextWidget(
                text: 'Your orders',
                color: color,
                textSize: 24.0,
                isTitle: true,
              ),
              backgroundColor: Theme.of(
                context,
              ).scaffoldBackgroundColor.withOpacity(0.9),
            ),
            body: const EmptyScreen(
              title: 'You didnt place any order yet',
              subtitle: 'order something and make me happy :)',
              buttonText: 'Shop now',
              imagePath: 'assets/images/cart.png',
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: const BackWidget(),
              elevation: 0,
              centerTitle: false,
              title: TextWidget(
                text: 'Your orders (${ordersList.length})',
                color: color,
                textSize: 24.0,
                isTitle: true,
              ),
              backgroundColor: Theme.of(
                context,
              ).scaffoldBackgroundColor.withOpacity(0.9),
            ),
            body: RefreshIndicator(
              onRefresh: _loadOrders,
              child: ListView.separated(
                itemCount: ordersList.length,
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 6,
                    ),
                    child: ChangeNotifierProvider.value(
                      value: ordersList[index],
                      child: const OrderWidget(),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(color: color, thickness: 1);
                },
              ),
            ),
          );
  }
}
