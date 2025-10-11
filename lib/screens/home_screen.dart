import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hgocery_app/inner_screens/feeds_screen.dart';
import 'package:hgocery_app/inner_screens/on_sale_screen.dart';
import 'package:hgocery_app/services/utils.dart';
import 'package:hgocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../consts/contss.dart';
import '../models/products_model.dart';
import '../providers/products_provider.dart';
import '../services/global_methods.dart';
import '../widgets/feed_items.dart';
import '../widgets/on_sale_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final Color color = Utils(context).color;
    Size size = utils.getScreenSize;
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productProviders.getProducts;
    List<ProductModel> productsOnSale = productProviders.getOnSaleProducts;

    // 🎨 UserScreen rang palitrasi
    const Color halalGreenDark = Color(0xFF1B5E20);
    const Color halalGreen = Color(0xFF2E7D32);
    const Color halalMid = Color(0xFF388E3C);
    const Color halalLight = Color(0xFF4CAF50);

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 247, 247, 247), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.33,
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 6.0,
                        ),
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            Constss.offerImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    autoplay: true,
                    itemCount: Constss.offerImages.length,
                    pagination: const SwiperPagination(
                      alignment: Alignment.bottomCenter,
                      builder: DotSwiperPaginationBuilder(
                        color: Colors.white,
                        activeColor: halalLight, // 🔹 yashil rang
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 6),
                TextButton(
                  onPressed: () {
                    GlobalMethods.navigateTo(
                      ctx: context,
                      routeName: OnSaleScreen.routeName,
                    );
                  },
                  child: TextWidget(
                    text: 'View all',
                    maxLines: 1,
                    color: halalGreen, // 🔹 yashil rang
                    textSize: 20,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    RotatedBox(
                      quarterTurns: -1,
                      child: Row(
                        children: [
                          TextWidget(
                            text: 'On sale'.toUpperCase(),
                            color:
                                halalGreenDark, // 🔹 qizil o‘rniga chuqur yashil
                            textSize: 22,
                            isTitle: true,
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            IconlyLight.discount,
                            color: halalGreenDark, // 🔹 qizil o‘rniga yashil
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: SizedBox(
                        height: size.height * 0.24,
                        child: ListView.builder(
                          itemCount: productsOnSale.length < 10
                              ? productsOnSale.length
                              : 10,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, index) {
                            return ChangeNotifierProvider.value(
                              value: productsOnSale[index],
                              child: const OnSaleWidget(),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Our products',
                        color: halalGreenDark, // 🔹 sarlavha yashil
                        textSize: 22,
                        isTitle: true,
                      ),
                      TextButton(
                        onPressed: () {
                          GlobalMethods.navigateTo(
                            ctx: context,
                            routeName: FeedsScreen.routeName,
                          );
                        },
                        child: TextWidget(
                          text: 'Browse all',
                          maxLines: 1,
                          color: halalGreen, // 🔹 ko‘k o‘rniga yashil
                          textSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  padding: EdgeInsets.zero,
                  childAspectRatio: size.width / (size.height * 0.61),
                  children: List.generate(
                    allProducts.length < 4 ? allProducts.length : 4,
                    (index) {
                      return ChangeNotifierProvider.value(
                        value: allProducts[index],
                        child: const FeedsWidget(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
