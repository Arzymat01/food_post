import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

class ExcelService {
  Future<String?> exportSalesReport({
    required List<Map<String, dynamic>> rows,
    required int total,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Отчет'];

    sheet.appendRow([
      TextCellValue('Товар'),
      TextCellValue('Саны'),
      TextCellValue('Сумма'),
    ]);

    for (final row in rows) {
      final name = row['name']?.toString() ?? '';
      final qty = int.tryParse(row['qty'].toString()) ?? 0;
      final sum = int.tryParse(row['sum'].toString()) ?? 0;

      sheet.appendRow([
        TextCellValue(name),
        IntCellValue(qty),
        IntCellValue(sum),
      ]);
    }

    sheet.appendRow([TextCellValue(''), TextCellValue(''), TextCellValue('')]);

    sheet.appendRow([
      TextCellValue('Жалпы'),
      TextCellValue(''),
      IntCellValue(total),
    ]);

    // 📁 Documents папкага сактайт
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/report.xlsx';

    final bytes = excel.encode();
    if (bytes == null) return null;

    final file = File(path);
    await file.writeAsBytes(bytes);

    return path;
  }
}
