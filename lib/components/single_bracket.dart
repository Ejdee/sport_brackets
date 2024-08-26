import 'package:pdf/widgets.dart' as pw;

pw.Container buildSingleBracketPdf(String participant) {
  return pw.Container(
    padding: pw.EdgeInsets.all(8),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(),
      borderRadius: pw.BorderRadius.circular(8),
    ),
    child: pw.Text(participant),
  );
}