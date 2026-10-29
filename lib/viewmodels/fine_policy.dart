
class FinePolicy {
  final int dailyRateStep;

  final int maxLoanDays;

  final int missingAfterMonths;

  const FinePolicy({
    this.dailyRateStep = 5000,
    this.maxLoanDays = 6,
    this.missingAfterMonths = 6,
  });

  static const int _daysPerTier = 7;

  int get loanPeriodDays => maxLoanDays - 1;

  DateTime _day(DateTime d) => DateTime.utc(d.year, d.month, d.day);

  DateTime missingThreshold(DateTime due) {
    final d = _day(due);
    final total = d.month - 1 + missingAfterMonths;
    final year = d.year + total ~/ 12;
    final month = total % 12 + 1;
    final lastDay = DateTime.utc(year, month + 1, 0).day;
    return DateTime.utc(year, month, d.day > lastDay ? lastDay : d.day);
  }

  bool isOverdue(DateTime due, DateTime asOf) => _day(asOf).isAfter(_day(due));

  bool isMissing(DateTime due, DateTime asOf) =>
      _day(asOf).isAfter(missingThreshold(due));

  /// Jumlah hari sejak jatuh tempo (0 jika belum lewat).
  int overdueDays(DateTime due, DateTime asOf) {
    final days = _day(asOf).difference(_day(due)).inDays;
    return days < 0 ? 0 : days;
  }

  int dailyRate(int dayNumber) {
    if (dayNumber <= maxLoanDays) return 0;
    if (dayNumber <= 14) return dailyRateStep;
    return (2 + (dayNumber - 15) ~/ _daysPerTier) * dailyRateStep;
  }

  int fine({
    required DateTime due,
    required DateTime asOf,
    required int replacementPrice,
  }) {
    final late = overdueDays(due, asOf);
    var dailyFine = 0;
    for (var n = 1; n <= late; n++) {
      dailyFine += dailyRate(maxLoanDays + n);
    }
    if (isMissing(due, asOf)) return replacementPrice + dailyFine;
    return dailyFine;
  }
}