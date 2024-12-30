import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart' show rootBundle;

pw.Container buildDoubleBracketPdf(String participant1, String participant2, double marginTop, double marginBottom, final ttf) {
  return pw.Container(
    width: 130, // Set a fixed width for the double bracket container
    margin: pw.EdgeInsets.only(top: marginTop, bottom: marginBottom),
    child: pw.Column(
      children: [
        buildSingleBracketPdf_withMarginBottom(participant1, 5, ttf),
        buildSingleBracketPdf_withMarginTop(participant2, 5, ttf),
      ],
    ),
  );
}

pw.Container buildDoubleBlank(double marginTop, double marginBottom) {
  return pw.Container(
    width: 100, // Set a fixed width for the double bracket container
    margin: pw.EdgeInsets.only(top: marginTop, bottom: marginBottom),
    child: pw.Column(
      children: [
        buildSingleBlank(5),
        buildSingleBlank(5),
      ],
    ),
  );
}

pw.Container buildSingleBracketPdf(String participant, final ttf) {
  return pw.Container(
    width: 130, // Set a fixed width for the single bracket container
    height: 15,
    padding: pw.EdgeInsets.only(left: 2),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(),
    ),
    child: pw.Text(
      participant,
      style: pw.TextStyle(font: ttf),
      ),
  );
}

pw.Container buildSingleBracketPdf_withMarginBottom(String participant, double margin, final ttf) {
  return pw.Container(
    width: 130, // Set a fixed width for the single bracket container
    height: 15,
    padding: pw.EdgeInsets.only(left: 2),
    margin: pw.EdgeInsets.only(bottom: margin),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.red),
    ),
    child: pw.Text(
      participant,
      style: pw.TextStyle(font: ttf),
    ),
  );
}

pw.Container buildSingleBracketPdf_withMarginTop(String participant, double margin, final ttf) {
  return pw.Container(
    width: 130, // Set a fixed width for the single bracket container
    height: 15,
    padding: pw.EdgeInsets.only(left: 2),
    margin: pw.EdgeInsets.only(top: margin),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.blue),
    ),
    child: pw.Text(
      participant,
      style: pw.TextStyle(font: ttf),
    ),
  );
}

pw.Container buildSingleBlank(double margin) {
  return pw.Container(
    width: 100, // Set a fixed width for the single bracket container
    height: 15,
    padding: pw.EdgeInsets.only(left: 2),
    margin: pw.EdgeInsets.only(top: margin),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.white),
    ),
  );
}
