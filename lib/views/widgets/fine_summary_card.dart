import 'package:flutter/material.dart';

import 'format.dart';

class FineSummaryCard extends StatelessWidget {
  final int totalFine;
  final int activeCount;
  final int overdueCount;

  const FineSummaryCard({
    super.key,
    required this.totalFine,
    required this.activeCount,
    required this.overdueCount,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total denda', style: t.labelLarge),
            Text(formatRupiah(totalFine),
                style: t.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Pinjaman aktif: $activeCount   |   Terlambat/Hilang: $overdueCount',
                style: t.bodyMedium),
          ],
        ),
      ),
    );
  }
}
