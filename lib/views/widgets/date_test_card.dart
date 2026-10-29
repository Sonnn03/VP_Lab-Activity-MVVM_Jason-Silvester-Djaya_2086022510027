import 'package:flutter/material.dart';

import 'format.dart';

class DateTestCard extends StatelessWidget {
  final DateTime currentDate;
  final bool isSimulated;
  final ValueChanged<DateTime> onPickDate;
  final ValueChanged<int> onAddDays;
  final VoidCallback onReset;

  const DateTestCard({
    super.key,
    required this.currentDate,
    required this.isSimulated,
    required this.onPickDate,
    required this.onAddDays,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tes tanggal', style: t.labelLarge),
            Text(
              '${formatDate(currentDate)}  ${isSimulated ? '(simulasi)' : '(tanggal asli)'}',
              style: t.titleLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: currentDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) onPickDate(picked);
                  },
                  child: const Text('Pilih tanggal'),
                ),
                OutlinedButton(
                  onPressed: () => onAddDays(1),
                  child: const Text('+1 hari'),
                ),
                OutlinedButton(
                  onPressed: () => onAddDays(7),
                  child: const Text('+7 hari'),
                ),
                TextButton(
                  onPressed: isSimulated ? onReset : null,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}