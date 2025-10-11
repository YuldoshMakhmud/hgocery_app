import 'package:flutter/material.dart';
import 'package:hgocery_app/services/utils.dart';
import 'package:hgocery_app/widgets/categories_widget.dart';
import 'package:hgocery_app/widgets/text_widget.dart';

// ignore: must_be_immutable
class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  // 🌿 Yashilga yo‘naltirilgan rang palitrasi
  final List<Color> gridColors = const [
    Color(0xFF81C784), // Light Green
    Color(0xFF4CAF50), // Green
    Color(0xFFA5D6A7), // Mint Green
    Color(0xFFC8E6C9), // Soft Pastel Green
    Color(0xFFB2DFDB), // Aqua Mint
    Color(0xFFDCEDC8), // Light Lime
  ];

  final List<Map<String, dynamic>> catInfo = const [
    {'imgPath': 'assets/images/cat/fruits.png', 'catText': 'Fruits'},
    {'imgPath': 'assets/images/cat/veg.png', 'catText': 'Vegetables'},
    {'imgPath': 'assets/images/cat/Spinach.png', 'catText': 'Fish'},
    {'imgPath': 'assets/images/cat/nuts.png', 'catText': 'Nuts'},
    {'imgPath': 'assets/images/cat/spices.png', 'catText': 'Savr'},
    {'imgPath': 'assets/images/cat/grains.png', 'catText': 'Grains'},
  ];

  @override
  Widget build(BuildContext context) {
    final utils = Utils(context);
    final Color color = utils.color;

    const Color halalGreenDark = Color(0xFF1B5E20);
    const Color halalGreen = Color(0xFF2E7D32);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        backgroundColor: halalGreen, // 🔹 AppBar yashil
        title: TextWidget(
          text: 'Categories',
          color: Colors.white, // 🔹 oq matn
          textSize: 24,
          isTitle: true,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 247, 247, 247), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 240 / 250,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: List.generate(catInfo.length, (index) {
              return CategoriesWidget(
                catText: catInfo[index]['catText'],
                imgPath: catInfo[index]['imgPath'],
                passedColor: gridColors[index],
              );
            }),
          ),
        ),
      ),
    );
  }
}
