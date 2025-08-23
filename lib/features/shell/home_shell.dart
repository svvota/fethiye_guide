import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeShell extends StatefulWidget {
  final Widget child;
  const HomeShell({super.key, required this.child});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;
  final tabs = ['/home', '/places', '/events', '/favorites'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          setState(() => index = i);
          context.go(tabs[i]);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.place_outlined), label: 'Places'),
          NavigationDestination(icon: Icon(Icons.event_outlined), label: 'Events'),
          NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Favs'),
        ],
      ),
    );
  }
}

