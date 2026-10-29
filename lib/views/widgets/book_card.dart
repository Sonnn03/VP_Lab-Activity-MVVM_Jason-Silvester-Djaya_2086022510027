import 'package:flutter/material.dart';

import '/models/book.dart';
import 'format.dart';
import 'status_chip.dart';

class BookCard extends StatefulWidget {
  final Book book;
  final BookStatus status;
  final void Function(int quantity) onBorrow;

  const BookCard({
    super.key,
    required this.book,
    required this.status,
    required this.onBorrow,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final book = widget.book;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.title, style: t.titleMedium),
                  Text(book.author, style: t.bodyMedium),
                  Text('Harga ganti: ${formatRupiah(book.replacementPrice)}', style: t.bodySmall),
                  Text('Tersedia: ${book.availableCopies} dari ${book.totalCopies}',
                      style: t.bodySmall),
                  const SizedBox(height: 8),
                  StatusChip.forBook(widget.status),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed:
                          _quantity > 1 ? () => setState(() => _quantity--) : null,
                    ),
                    Text('$_quantity', style: t.titleMedium),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() => _quantity++),
                    ),
                  ],
                ),
                FilledButton(
                  onPressed: () {
                    widget.onBorrow(_quantity);
                    setState(() => _quantity = 1);
                  },
                  child: const Text('Pinjam'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
