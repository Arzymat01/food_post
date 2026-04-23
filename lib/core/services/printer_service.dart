class PrinterService {
  Future<String> buildReceiptText({
    required int orderNumber,
    required List<Map<String, dynamic>> items,
    required int total,
  }) async {
    final buffer = StringBuffer();
    buffer.writeln('ЗАКАЗ №$orderNumber');
    buffer.writeln('----------------------');
    for (final item in items) {
      buffer.writeln(
        '${item['name']} x${item['qty']}  ${item['line_total']} сом',
      );
    }
    buffer.writeln('----------------------');
    buffer.writeln('ЖАЛПЫ: $total сом');
    buffer.writeln('Рахмат!');
    return buffer.toString();
  }

  Future<void> printReceipt(String text) async {
    // Бул жерге реалдуу ESC/POS интеграция кошулат.
    // Азыр scaffold катары калтырылды.
    // print(text);
  }
}
