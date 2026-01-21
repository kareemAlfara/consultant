import 'package:flutter/material.dart';
import 'package:marriage/feature/myspace/presentation/pages/layoutpages/Consulting_page.dart';
import 'package:marriage/feature/myspace/presentation/pages/layoutpages/Interactions_Page.dart';
import 'package:marriage/feature/myspace/presentation/pages/layoutpages/Social_page.dart';
import 'package:marriage/feature/myspace/presentation/pages/layoutpages/marriaging_Page.dart';
import 'package:marriage/feature/myspace/presentation/widgets/bottomnavbar.dart';
// import 'custom_bottom_nav.dart';

class MainLayoutPage extends StatefulWidget {
  const MainLayoutPage({super.key});

  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}

class _MainLayoutPageState extends State<MainLayoutPage> {
  int _currentIndex = 3; // مساحتي active افتراضيًا

  final List<Widget> layouts = const [
    SocialPage(),
    MarriagingPage(),
    ConsultingPage(),
    InteractionsPage(),
    SocialPage(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: layouts,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
