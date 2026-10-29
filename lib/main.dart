import 'package:flutter/material.dart';

import '/viewmodels/library_view_model.dart';
import '/views/borrowed_books_screen.dart';
import '/views/library_screen.dart';

void main() => runApp(const LibraryApp());

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University Library System',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _viewModel = LibraryViewModel();
  int _index = 0;

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          LibraryScreen(viewModel: _viewModel),
          BorrowedBooksScreen(viewModel: _viewModel),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Katalog'),
          NavigationDestination(icon: Icon(Icons.bookmark), label: 'Pinjaman'),
        ],
      ),
    );
  }
}
