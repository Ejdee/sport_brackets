import 'package:pdf/widgets.dart' as pw;

pw.Container buildDoubleBracketPdf(String participant1, String participant2) {
  return pw.Container(
    width: 130, // Set a fixed width for the double bracket container
    child: pw.Column(
      children: [
        buildSingleBracketPdf(participant1),
        buildSingleBracketPdf(participant2),
      ],
    ),
  );
}

pw.Container buildSingleBracketPdf(String participant) {
  return pw.Container(
    width: 130, // Set a fixed width for the single bracket container
    padding: pw.EdgeInsets.all(8),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(),
    ),
    child: pw.Text(participant),
  );
}
