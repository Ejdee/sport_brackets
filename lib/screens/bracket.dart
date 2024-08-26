import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import '../components/single_bracket.dart';

Future<Uint8List> generateBracketPdf(Map<String, List<String>> filteredCategories) async {
  final pw.Document doc = pw.Document();

  filteredCategories.forEach((category, participants) {
    doc.addPage(
      pw.Page(
        orientation: pw.PageOrientation.landscape,
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              category,
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            ..._buildRoundsPdf(participants),
          ],
        ),
      ),
    );
  });

  return doc.save();
}

List<pw.Widget> _buildRoundsPdf(List<String> participants) {
  return [
    pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
      children: participants.map((participant) => buildSingleBracketPdf(participant)).toList(),
    ),
  ];
}

Future<String> savePdf(Future<Uint8List> pdfData) async {
  final output = await getTemporaryDirectory();
  final file = File("${output.path}/bracket.pdf");
  await file.writeAsBytes(await pdfData);
  return file.path;
}