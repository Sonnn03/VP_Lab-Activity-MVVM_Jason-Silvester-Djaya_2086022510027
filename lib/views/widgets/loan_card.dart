import 'package:flutter/material.dart';

import '/models/loan.dart';
import '/views/widgets/format.dart';
import '/views/widgets/status_chip.dart';

class LoanCard extends StatelessWidget {
  final Loan loan;
  final String bookTitle;
  final LoanStatus status;
  final int fine;
  final VoidCallback onReturn;
  final VoidCallback onPayFine;

  const LoanCard({
    super.key,
    required this.loan,
    required this.bookTitle,
    required this.status,
    required this.fine,
    required this.onReturn,
    required this.onPayFine,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(bookTitle, style: t.titleMedium)),
                StatusChip.forLoan(status),
              ],
            ),
            Text('Mahasiswa: ${loan.studentId}', style: t.bodySmall),
            Text('Dipinjam: ${formatDate(loan.borrowDate)}', style: t.bodySmall),
            Text('Jatuh tempo: ${formatDate(loan.dueDate)}', style: t.bodyMedium),
            if (loan.returnDate != null)
              Text('Dikembalikan: ${formatDate(loan.returnDate!)}', style: t.bodySmall),
            if (fine > 0)
              Text('Denda: ${formatRupiah(fine)}',
                  style: t.titleSmall?.copyWith(color: Colors.red.shade700)),
            if (loan.paidAmount > 0)
              Text('Sudah dibayar: ${formatRupiah(loan.paidAmount)}',
                  style: t.bodySmall?.copyWith(color: Colors.green.shade700)),
            if (fine > 0 || loan.isActive)
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  spacing: 8,
                  children: [
                    if (fine > 0)
                      FilledButton(onPressed: onPayFine, child: const Text('Bayar denda')),
                    if (loan.isActive)
                      FilledButton.tonal(onPressed: onReturn, child: const Text('Kembalikan')),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}