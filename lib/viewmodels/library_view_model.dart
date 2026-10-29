import 'package:flutter/foundation.dart';

import '../models/book.dart';
import '../models/loan.dart';
import 'fine_policy.dart';

enum BookFilter { all, available, borrowed, overdue, missing }

class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel({this.policy = const FinePolicy()}) {
    _books = _sampleBooks();
    _loans = _sampleLoans();
    _nextLoanNumber = _loans.length + 1;
    for (final l in _loans) {
      if (l.isActive) _adjustAvailable(l.bookId, -1);
    }
  }

  final FinePolicy policy;

  late List<Book> _books;
  late List<Loan> _loans;
  late int _nextLoanNumber;

  String _searchQuery = '';
  BookFilter _filter = BookFilter.all;

  DateTime? _simulatedDate;

  DateTime get _today {
    final n = _simulatedDate ?? DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  DateTime get currentDate => _today;

  bool get isDateSimulated => _simulatedDate != null;

  void setSimulatedDate(DateTime date) {
    _simulatedDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  void addSimulatedDays(int days) {
    final t = _today;
    _simulatedDate = DateTime(t.year, t.month, t.day + days);
    notifyListeners();
  }

  void resetDate() {
    _simulatedDate = null;
    notifyListeners();
  }

  BookFilter get filter => _filter;

  List<Book> get books {
    final q = _searchQuery.trim().toLowerCase();
    return _books.where((b) {
      final matchQuery = q.isEmpty ||
          b.title.toLowerCase().contains(q) ||
          b.author.toLowerCase().contains(q);
      return matchQuery && _matchesFilter(b);
    }).toList();
  }

  List<Loan> get loans {
    final active = _loans.where((l) => l.isActive).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    final returned = _loans.where((l) => !l.isActive).toList()
      ..sort((a, b) => b.returnDate!.compareTo(a.returnDate!));
    return [...active, ...returned];
  }

  List<Loan> get activeLoans => _loans.where((l) => l.isActive).toList();

  List<Loan> get overdueRecords => activeLoans.where((l) {
        final s = getOverdueStatus(l);
        return s == LoanStatus.overdue || s == LoanStatus.missing;
      }).toList();

  int get totalFine => _loans.fold(0, (sum, l) => sum + calculateFine(l));

  Book? findBook(String id) {
    for (final b in _books) {
      if (b.id == id) return b;
    }
    return null;
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setFilter(BookFilter value) {
    _filter = value;
    notifyListeners();
  }

  bool _matchesFilter(Book book) {
    if (_filter == BookFilter.all) return true;
    if (_filter == BookFilter.available) return book.isAvailable;
    final statuses = _activeLoansForBook(book.id).map(getOverdueStatus).toList();
    if (_filter == BookFilter.borrowed) return statuses.contains(LoanStatus.active);
    if (_filter == BookFilter.overdue) return statuses.contains(LoanStatus.overdue);
    if (_filter == BookFilter.missing) return statuses.contains(LoanStatus.missing);
    return false;
  }

  List<Loan> _activeLoansForBook(String bookId) =>
      _loans.where((l) => l.bookId == bookId && l.isActive).toList();

  BookStatus bookStatus(Book book) {
    if (book.isAvailable) return BookStatus.available;
    final statuses = _activeLoansForBook(book.id).map(getOverdueStatus).toList();
    if (statuses.contains(LoanStatus.missing)) return BookStatus.missing;
    if (statuses.contains(LoanStatus.overdue)) return BookStatus.overdue;
    return BookStatus.borrowed;
  }

  LoanStatus getOverdueStatus(Loan loan) {
    if (!loan.isActive) return LoanStatus.returned;
    final now = _today;
    if (policy.isMissing(loan.dueDate, now)) return LoanStatus.missing;
    if (policy.isOverdue(loan.dueDate, now)) return LoanStatus.overdue;
    return LoanStatus.active;
  }

  int _grossFine(Loan loan) {
    if (!loan.isActive) return loan.outstandingFine ?? 0;
    return policy.fine(
      due: loan.dueDate,
      asOf: _today,
      replacementPrice: findBook(loan.bookId)?.replacementPrice ?? 0,
    );
  }

  int calculateFine(Loan loan) {
    final remaining = _grossFine(loan) - loan.paidAmount;
    return remaining < 0 ? 0 : remaining;
  }

  bool borrowBook(String bookId, String studentId, {int quantity = 1}) {
    final book = findBook(bookId);
    if (book == null || quantity < 1 || quantity > book.availableCopies) {
      return false;
    }
    final today = _today;
    for (var n = 0; n < quantity; n++) {
      _loans.add(Loan(
        id: 'L${(_nextLoanNumber++).toString().padLeft(3, '0')}',
        bookId: bookId,
        studentId: studentId,
        borrowDate: today,
        dueDate: DateTime(today.year, today.month, today.day + policy.loanPeriodDays),
      ));
    }
    _adjustAvailable(bookId, -quantity);
    notifyListeners();
    return true;
  }

  bool returnBook(String loanId) {
    final i = _loans.indexWhere((l) => l.id == loanId);
    if (i < 0 || !_loans[i].isActive) return false;
    final loan = _loans[i];
    _loans[i] = loan.copyWith(
      returnDate: _today,
      outstandingFine: _grossFine(loan),
    );
    _adjustAvailable(loan.bookId, 1);
    notifyListeners();
    return true;
  }

  bool payFine(String loanId) {
    final i = _loans.indexWhere((l) => l.id == loanId);
    if (i < 0) return false;
    final loan = _loans[i];
    final due = calculateFine(loan);
    if (due <= 0) return false;
    _loans[i] = loan.copyWith(paidAmount: loan.paidAmount + due);
    notifyListeners();
    return true;
  }

  void _adjustAvailable(String bookId, int delta) {
    final i = _books.indexWhere((b) => b.id == bookId);
    if (i < 0) return;
    final b = _books[i];
    var next = b.availableCopies + delta;
    if (next < 0) next = 0;
    if (next > b.totalCopies) next = b.totalCopies;
    _books[i] = b.copyWith(availableCopies: next);
  }

  List<Book> _sampleBooks() => <Book>[
        Book(id: 'B01', title: 'Bumi Manusia', author: 'Pramoedya Ananta Toer', replacementPrice: 350000, totalCopies: 3),
        Book(id: 'B02', title: 'Laskar Pelangi', author: 'Andrea Hirata', replacementPrice: 420000, totalCopies: 3),
        Book(id: 'B03', title: 'Cantik Itu Luka', author: 'Eka Kurniawan', replacementPrice: 500000, totalCopies: 3),
        Book(id: 'B04', title: 'Laut Bercerita', author: 'Leila S. Chudori', replacementPrice: 450000, totalCopies: 2),
        Book(id: 'B05', title: 'Negeri 5 Menara', author: 'Ahmad Fuadi', replacementPrice: 380000, totalCopies: 1),
        Book(id: 'B06', title: 'Ronggeng Dukuh Paruk', author: 'Ahmad Tohari', replacementPrice: 300000, totalCopies: 3),
      ];

  List<Loan> _sampleLoans() {
    final today = _today;
    Loan make(String id, String bookId, int daysUntilDue) {
      final due = DateTime(today.year, today.month, today.day + daysUntilDue);
      return Loan(
        id: id,
        bookId: bookId,
        studentId: '2024001',
        borrowDate: DateTime(due.year, due.month, due.day - policy.loanPeriodDays),
        dueDate: due,
      );
    }

    return <Loan>[
      make('L001', 'B02', 5),
      make('L002', 'B03', -7),
      make('L003', 'B04', -14),
      make('L004', 'B05', -190),
    ];
  }
}