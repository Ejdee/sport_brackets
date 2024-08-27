import 'dart:io';
import 'dart:typed_data';
import 'package:karate_brackets/data_manage/participants_manipulation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../components/single_bracket.dart';

Future<Uint8List> generateBracketPdf(Map<String, List<String>> filteredCategories) async {
  final pw.Document doc = pw.Document();

  // get the width and height of a4 page
  final a4Width = PdfPageFormat.a4.width;
  final a4Height = PdfPageFormat.a4.height;

  filteredCategories.forEach((category, participants) {
    // get the number of columns needed for the bracket 
    int totalColumns = numberOfColumns(participants.length);

    doc.addPage(
      pw.Page(
        orientation: pw.PageOrientation.landscape,
        margin: pw.EdgeInsets.all(10),
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              category,
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            _buildRoundsPdf(participants, a4Width, totalColumns),
          ],
        ),
      ),
    );
  });

  return doc.save();
}

pw.Widget _buildRoundsPdf(List<String> participants, double a4Width, int numberOfColumns) {
  // calculate width of one column
  double columnWidth = a4Width / numberOfColumns;
  // get the number of prerounds if there are any
  int nOfPrerounds = numberOfPrerounds(participants.length);
  // based on the number of prerounds calculate the number of participants in the first round
  int participantsInFirstRound = nOfPrerounds == 0 ? participants.length : nOfPrerounds * 2;
  // calculate the number of rows in the first round
  int rowsNumber = participantsInFirstRound ~/ 2;

  List<pw.Widget> columns = [];
  // flag to check if it is the first round (where we fill the names)
  bool firstRound = true;

  for(int column = 0; column < numberOfColumns; column++) {
    List<pw.Widget> brackets = [];

    // if it is the first round create the double brackets with the names
    if(firstRound) {
      for(int i = 0; i < participantsInFirstRound; i += 2) {
        String participant1 = i < participants.length ? participants[i] : '';
        String participant2 = i + 1 < participants.length ? participants[i + 1] : '';
        brackets.add(
          buildDoubleBracketPdf(participant1, participant2),
        );
      }
    } else {
      // if it is not the first round calculate the new number of rows
      // which is half of the previous number of rows (rounded up)
      rowsNumber = (rowsNumber + 1) ~/ 2;
      // if it is last column then add a single bracket to fill the winner
      if(column == numberOfColumns - 1) {
        brackets.add(buildSingleBracketPdf(""));
      } else {
        // otherwise add the empty double brackets
        for(int i = 0; i < rowsNumber; i++) {
          brackets.add(buildDoubleBracketPdf("", ""));
        }
      }
    }

    // add the column to the list of columns
    columns.add(
      pw.Container(
        width: columnWidth,
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: brackets,
        ),
      ),
    );

    // set the flag to false after the first iteration
    firstRound = false;
  }

  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: columns,
  );
}

Future<String> savePdf(Future<Uint8List> pdfData) async {
  final output = await getTemporaryDirectory();
  final file = File("${output.path}/bracket.pdf");
  await file.writeAsBytes(await pdfData);
  return file.path;
}