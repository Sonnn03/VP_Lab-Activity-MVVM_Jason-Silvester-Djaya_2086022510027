import 'package:flutter/material.dart';

import '/viewmodels/library_view_model.dart';
import '/views/widgets/book_card.dart';

class LibraryScreen extends StatelessWidget {
  final LibraryViewModel viewModel;
  const LibraryScreen({super.key, required this.viewModel});

  static const _studentId = '2024001';

  static const _filterLabels = {
    BookFilter.all: 'Semua',
    BookFilter.available: 'Tersedia',
    BookFilter.borrowed: 'Dipinjam',
    BookFilter.overdue: 'Terlambat',
    BookFilter.missing: 'Hilang',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Katalog Buku')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final books = viewModel.books;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: TextField(
                  onChanged: viewModel.setSearchQuery,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Cari judul atau penulis',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 52,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8),
                  children: [
                    for (final f in BookFilter.values)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(_filterLabels[f]!),
                          selected: viewModel.filter == f,
                          onSelected: (_) => viewModel.setFilter(f),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: books.isEmpty
                    ? const Center(child: Text('Tidak ada buku.'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: books.length,
                        itemBuilder: (context, i) {
                          final book = books[i];
                          return BookCard(
                            key: ValueKey(book.id),
                            book: book,
                            status: viewModel.bookStatus(book),
                            onBorrow: (quantity) {
                              final ok = viewModel.borrowBook(
                                book.id,
                                _studentId,
                                quantity: quantity,
                              );
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(SnackBar(
                                  content: Text(ok
                                      ? 'Berhasil meminjam $quantity buku.'
                                      : 'Stok tidak mencukupi untuk meminjam $quantity buku.'),
                                ));
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
