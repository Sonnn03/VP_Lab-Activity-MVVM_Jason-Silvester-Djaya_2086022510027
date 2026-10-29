import 'package:flutter/material.dart';

import '/viewmodels/library_view_model.dart';
import '/views/widgets/date_test_card.dart';
import '/views/widgets/fine_summary_card.dart';
import '/views/widgets/format.dart';
import '/views/widgets/loan_card.dart';

class BorrowedBooksScreen extends StatelessWidget {
  final LibraryViewModel viewModel;
  const BorrowedBooksScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buku Dipinjam')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final loans = viewModel.loans;
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              DateTestCard(
                currentDate: viewModel.currentDate,
                isSimulated: viewModel.isDateSimulated,
                onPickDate: viewModel.setSimulatedDate,
                onAddDays: viewModel.addSimulatedDays,
                onReset: viewModel.resetDate,
              ),
              FineSummaryCard(
                totalFine: viewModel.totalFine,
                activeCount: viewModel.activeLoans.length,
                overdueCount: viewModel.overdueRecords.length,
              ),
              if (loans.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: Text('Belum ada peminjaman.')),
                ),
              for (final loan in loans)
                LoanCard(
                  loan: loan,
                  bookTitle: viewModel.findBook(loan.bookId)?.title ?? loan.bookId,
                  status: viewModel.getOverdueStatus(loan),
                  fine: viewModel.calculateFine(loan),
                  onReturn: () => viewModel.returnBook(loan.id),
                  onPayFine: () {
                    final paid = viewModel.calculateFine(loan);
                    final ok = viewModel.payFine(loan.id);
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text(ok
                            ? 'Denda ${formatRupiah(paid)} berhasil dibayar.'
                            : 'Tidak ada denda yang harus dibayar.'),
                      ));
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}