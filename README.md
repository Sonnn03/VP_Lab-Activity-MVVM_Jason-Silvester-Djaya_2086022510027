1. What is the difference between the Model, View, and ViewModel in this application?
The Model (Book, Loan) defines the core data structures, while the View (like book_card.dart and library_screen.dart) handles the user interface and interactions. The ViewModel (LibraryViewModel) acts as the bridge between them, managing the application state, filtering, and business logic.

2. What should happen if a student attempts to borrow a book that already has an active loan?
If there are still remaining copies of that specific book (availableCopies > 0), the borrowBook method will successfully create a new loan. However, if the requested quantity exceeds the available copies (e.g., all copies are already checked out), the method will return false and reject the transaction.

3. Why is it better to calculate the fine in one place rather than repeating the formula in multiple widgets?
Centralizing the fine calculation inside FinePolicy ensures that the mathematical logic remains consistent across the entire application. It also makes the code much easier to maintain, as any future changes to the penalty rules only need to be updated in one file instead of modifying every UI component like LoanCard or FineSummaryCard.

4. What is the difference between a book being Overdue and being Missing?
A loan becomes "Overdue" as soon as the current date surpasses its return due date. It is escalated to the more severe "Missing" status only if it remains unreturned after a significantly longer extended period, which is determined by the missingAfterMonths threshold (defaulting to 6 months).

5. If the university changes its weekly fine from Rp5,000 to Rp7,000, how should the app be updated?
The developer only needs to update the default value of the dailyRateStep parameter in the FinePolicy constructor from 5000 to 7000. Because the fine calculation logic is centralized, this single change will automatically propagate to all rate calculations throughout the application.