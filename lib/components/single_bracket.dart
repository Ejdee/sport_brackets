import 'package:pdf/widgets.dart' as pw;

pw.Container buildDoubleBracketPdf(String participant1, String participant2, double margin) {
  return pw.Container(
    width: 130, // Set a fixed width for the double bracket container
    margin: pw.EdgeInsets.only(bottom: margin),
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
    height: 15,
    padding: pw.EdgeInsets.only(left: 2),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(),
    ),
    child: pw.Text(participant),
  );
}
