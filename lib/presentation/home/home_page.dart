import 'package:flutter/material.dart';

import '../widgets/bottom_nav_bar.dart';

class LiturgicalHomePage extends StatelessWidget {
  const LiturgicalHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF7F3EB),
      body: SafeArea(
        child: SizedBox.expand(),
      ),
      bottomNavigationBar: BottomNavBar(selectedTab: 'today'),
    );
  }
}
