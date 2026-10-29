enum LoanStatus { active, overdue, missing, returned }

class Loan {
  final String id;
  final String bookId;
  final String studentId;
  final DateTime borrowDate;
  final DateTime dueDate;
  final DateTime? returnDate;

  final int? outstandingFine;

  final int paidAmount;

  const Loan({
    required this.id,
    required this.bookId,
    required this.studentId,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
    this.outstandingFine,
    this.paidAmount = 0,
  });

  bool get isActive => returnDate == null;

  Loan copyWith({DateTime? returnDate, int? outstandingFine, int? paidAmount}) => Loan(
        id: id,
        bookId: bookId,
        studentId: studentId,
        borrowDate: borrowDate,
        dueDate: dueDate,
        returnDate: returnDate ?? this.returnDate,
        outstandingFine: outstandingFine ?? this.outstandingFine,
        paidAmount: paidAmount ?? this.paidAmount,
      );
}