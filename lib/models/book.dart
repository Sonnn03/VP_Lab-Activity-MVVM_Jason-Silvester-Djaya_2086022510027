enum BookStatus { available, borrowed, overdue, missing }

class Book {
  final String id;
  final String title;
  final String author;
  final int replacementPrice;
  final int totalCopies;
  final int availableCopies;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.replacementPrice,
    required this.totalCopies,
    int? availableCopies,
  }) : availableCopies = availableCopies ?? totalCopies;

  bool get isAvailable => availableCopies > 0;

  Book copyWith({int? availableCopies}) => Book(
        id: id,
        title: title,
        author: author,
        replacementPrice: replacementPrice,
        totalCopies: totalCopies,
        availableCopies: availableCopies ?? this.availableCopies,
      );
}
