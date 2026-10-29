import 'package:flutter/material.dart';

import '/models/book.dart';
import '/models/loan.dart';

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const StatusChip({super.key, required this.label, required this.color});

  factory StatusChip.forBook(BookStatus s) {
    switch (s) {
      case BookStatus.available:
        return StatusChip(label: 'Tersedia', color: Colors.green.shade700);
      case BookStatus.borrowed:
        return StatusChip(label: 'Dipinjam', color: Colors.blue.shade700);
      case BookStatus.overdue:
        return StatusChip(label: 'Terlambat', color: Colors.orange.shade800);
      case BookStatus.missing:
        return StatusChip(label: 'Hilang', color: Colors.red.shade700);
    }
  }

  factory StatusChip.forLoan(LoanStatus s) {
    switch (s) {
      case LoanStatus.active:
        return StatusChip(label: 'Dipinjam', color: Colors.blue.shade700);
      case LoanStatus.overdue:
        return StatusChip(label: 'Terlambat', color: Colors.orange.shade800);
      case LoanStatus.missing:
        return StatusChip(label: 'Hilang', color: Colors.red.shade700);
      case LoanStatus.returned:
        return StatusChip(label: 'Dikembalikan', color: Colors.green.shade700);
    }
  }

  @override
  Widget build(BuildContext context) => Chip(
        label: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        side: BorderSide(color: color),
        backgroundColor: color.withOpacity(0.1),
        visualDensity: VisualDensity.compact,
      );
}
  