import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

pw.Container buildDoubleBracketPdf(String participant1, String participant2, double marginTop, double marginBottom) {
  return pw.Container(
    width: 100, // Set a fixed width for the double bracket container
    margin: pw.EdgeInsets.only(top: marginTop, bottom: marginBottom),
    child: pw.Column(
      children: [
        buildSingleBracketPdf_withMarginBottom(participant1, 5),
        buildSingleBracketPdf_withMarginTop(participant2, 5),
      ],
    ),
  );
}

pw.Container buildSingleBracketPdf(String participant) {
  return pw.Container(
    width: 100, // Set a fixed width for the single bracket container
    height: 15,
    padding: pw.EdgeInsets.only(left: 2),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(),
    ),
    child: pw.Text(participant),
  );
}

pw.Container buildSingleBracketPdf_withMarginBottom(String participant, double margin) {
  return pw.Container(
    width: 100, // Set a fixed width for the single bracket container
    height: 15,
    padding: pw.EdgeInsets.only(left: 2),
    margin: pw.EdgeInsets.only(bottom: margin),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.red),
    ),
    child: pw.Text(participant),
  );
}

pw.Container buildSingleBracketPdf_withMarginTop(String participant, double margin) {
  return pw.Container(
    width: 100, // Set a fixed width for the single bracket container
    height: 15,
    padding: pw.EdgeInsets.only(left: 2),
    margin: pw.EdgeInsets.only(top: margin),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.blue),
    ),
    child: pw.Text(participant),
  );
}
