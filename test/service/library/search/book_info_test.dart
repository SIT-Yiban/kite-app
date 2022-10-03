import 'package:flutter_test/flutter_test.dart';
import 'package:kite/module/library/search/init.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('book_info test', () async {
    var books = await LibrarySearchInit.bookSearch.search(rows: 100);
    var bookInfo = await LibrarySearchInit.bookInfo.query(books.books[0].bookId);
    logger.i(bookInfo);
  });
}
