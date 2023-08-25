import 'package:client/features/home/home_screen.dart';
import 'package:flutter/material.dart';

class ToggleDrawerButton extends StatelessWidget {
  const ToggleDrawerButton({super.key});

  void toggleDrawer(BuildContext context) {
    final home = HomeScreen.of(context)!;
    final state = home.scaffoldKey.currentState!;
    state.isDrawerOpen ? state.closeDrawer() : state.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () => toggleDrawer(context)
    );
  }
}
