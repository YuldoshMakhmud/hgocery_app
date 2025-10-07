import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hgocery_app/consts/firebase_consts.dart';
import 'package:hgocery_app/screens/auth/forget_pass.dart';
import 'package:hgocery_app/screens/loading_manager.dart';
import 'package:hgocery_app/screens/orders/orders_screen.dart';
import 'package:hgocery_app/screens/viewed_recently/viewed_recently.dart';
import 'package:hgocery_app/screens/wishlist/wishlist_screen.dart';
import 'package:hgocery_app/services/global_methods.dart';
import 'package:hgocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/dark_theme_provider.dart';
import 'auth/login.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController = TextEditingController();
  String? _email;
  String? _name;
  String? address;
  bool _isLoading = false;
  final User? user = authInstance.currentUser;

  final Uri _privacyUrl = Uri.parse(
    'https://sites.google.com/view/tut-privacy-policy/home',
  );
  final Uri _termsUrl = Uri.parse(
    'https://sites.google.com/view/tut-terms-of-service/home',
  );

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() => _isLoading = true);
    if (user == null) return;
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (userDoc.exists) {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        address = userDoc.get('shipping-address');
        _addressTextController.text = address ?? '';
      }
    } catch (e) {
      GlobalMethods.errorDialog(subtitle: '$e', context: context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Linkni ochib bo‘lmadi')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    final color = theme.getDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: theme.getDarkTheme
                ? [Colors.green, Colors.white]
                : [
                    const Color.fromARGB(
                      255,
                      247,
                      247,
                      247,
                    ), // pastel light green
                    const Color(0xFFFFFFFF), // white
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: LoadingManager(
          isLoading: _isLoading,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  // Profil qismi
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: const Color(
                            0xFF2E7D32,
                          ), // deep halal green
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _name ?? 'Foydalanuvchi',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1B5E20),
                          ),
                        ),
                        Text(
                          _email ?? 'Email mavjud emas',
                          style: TextStyle(
                            fontSize: 16,
                            color: color.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // menyu bo‘limlari
                  _buildTile(
                    icon: IconlyLight.profile,
                    title: 'Address',
                    subtitle: address ?? 'Manzil kiritilmagan',
                    onTap: _showAddressDialog,
                    color: const Color(0xFF1B5E20),
                  ),
                  _buildTile(
                    icon: IconlyLight.bag,
                    title: 'Orders',
                    onTap: () => GlobalMethods.navigateTo(
                      ctx: context,
                      routeName: OrdersScreen.routeName,
                    ),
                    color: const Color(0xFF2E7D32),
                  ),
                  _buildTile(
                    icon: IconlyLight.heart,
                    title: 'Wishlist',
                    onTap: () => GlobalMethods.navigateTo(
                      ctx: context,
                      routeName: WishlistScreen.routeName,
                    ),
                    color: const Color(0xFF388E3C),
                  ),
                  _buildTile(
                    icon: IconlyLight.show,
                    title: 'Viewed Recently',
                    onTap: () => GlobalMethods.navigateTo(
                      ctx: context,
                      routeName: ViewedRecentlyScreen.routeName,
                    ),
                    color: const Color(0xFF4CAF50),
                  ),
                  _buildTile(
                    icon: IconlyLight.unlock,
                    title: 'Forget Password',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ForgetPasswordScreen(),
                      ),
                    ),
                    color: const Color(0xFF66BB6A),
                  ),

                  // light/dark
                  SwitchListTile(
                    title: Text(
                      theme.getDarkTheme ? 'Dark Mode' : 'Light Mode',
                      style: TextStyle(fontSize: 18, color: color),
                    ),
                    secondary: Icon(
                      theme.getDarkTheme
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                      color: const Color(0xFF1B5E20),
                    ),
                    value: theme.getDarkTheme,
                    onChanged: (v) => setState(() {
                      theme.setDarkTheme = v;
                    }),
                  ),

                  const Divider(thickness: 1),
                  _buildTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () => _launchUrl(_privacyUrl),
                    color: const Color(0xFF2E7D32),
                  ),
                  _buildTile(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    onTap: () => _launchUrl(_termsUrl),
                    color: const Color(0xFF2E7D32),
                  ),
                  const Divider(thickness: 1),

                  _buildTile(
                    icon: user == null ? IconlyLight.login : IconlyLight.logout,
                    title: user == null ? 'Login' : 'Logout',
                    onTap: () {
                      if (user == null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      } else {
                        GlobalMethods.warningDialog(
                          title: 'Sign out',
                          subtitle: 'Do you wanna sign out?',
                          fct: () async {
                            await authInstance.signOut();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          context: context,
                        );
                      }
                    },
                    color: const Color(0xFF1B5E20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required Function onTap,
    required Color color,
  }) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        subtitle: subtitle != null && subtitle.isNotEmpty
            ? Text(subtitle)
            : null,
        trailing: Icon(IconlyLight.arrowRight2, color: color),
        onTap: () => onTap(),
      ),
    );
  }

  Future<void> _showAddressDialog() async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Update Address'),
        content: TextField(
          controller: _addressTextController,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'Your address'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (user == null) return;
              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .update({'shipping-address': _addressTextController.text});
                setState(() {
                  address = _addressTextController.text;
                });
                Navigator.pop(context);
              } catch (e) {
                GlobalMethods.errorDialog(
                  subtitle: e.toString(),
                  context: context,
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
