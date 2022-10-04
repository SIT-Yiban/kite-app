import 'package:flutter_test/flutter_test.dart';
import 'package:kite/module/library/search/init.dart';
import 'package:kite/module/library/search/service/book_search.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  var session = LibrarySearchInit.session;
  test('search test', () async {
    var result = await BookSearchService(session).search(
      keyword: 'Java',
      rows: 10,
    );
    logger.i(result);
  });
}
