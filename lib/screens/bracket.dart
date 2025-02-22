import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:karate_brackets/data_manage/participants_manipulation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../components/single_bracket.dart';
import '../data_manage/line_drawing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';

Future<Uint8List> generateBracketPdf(Map<String, List<String>> filteredCategories) async {
  final pw.Document doc = pw.Document();

  const double baseMargin = 10;
  const double headerHeight = 30;

  final ttf = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));

  // get the width and height of a4 page
  final a4Width = PdfPageFormat.a4.landscape.width;
  print("width: $a4Width");
  final a4Height = PdfPageFormat.a4.landscape.height;
  print("height: $a4Height");

  filteredCategories.forEach((category, participants) {
    // get the number of columns needed for the bracket 
    int totalColumns = numberOfColumns(participants.length);

    var truncatedParticipants = participants.map((participant) {
      var singleParts = participant.split(" ");
      if (singleParts.length > 1) {
        //return '${singleParts[0][0]}. ${singleParts.sublist(1).join(' ')}';
        return participant;
      } else {
        return participant;
      }
    }).toList();

    truncatedParticipants.shuffle(Random());

    print(truncatedParticipants);

    doc.addPage(
      pw.Page(
        orientation: pw.PageOrientation.landscape,
        margin: pw.EdgeInsets.all(baseMargin),
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
//          drawLine(context, 100, 100, 200, 100);

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.ClipRect(
                child: pw.Container(
                  height: headerHeight,
                  child: pw.Text(
                    category,
                    style: pw.TextStyle(font: ttf, fontSize: 24, fontWeight: pw.FontWeight.bold),
                  )
                ),
              ),
              _buildRoundsPdf(truncatedParticipants, a4Width, a4Height, totalColumns, baseMargin, headerHeight, context, ttf),
            ],
          );
        },
      ),
    );
  });

  return doc.save();
}

pw.Widget _buildRoundsPdf(List<String> participants, double a4Width, double a4Height, int numberOfColumns, double baseMargin, double headerHeight, pw.Context context, final ttf) {
  // calculate width of one column
  double columnWidth = a4Width / numberOfColumns;
  // get the number of prerounds if there are any
  int nOfPrerounds = numberOfPrerounds(participants.length);
  // based on the number of prerounds calculate the number of participants in the first round
  int participantsInFirstRound = nOfPrerounds == 0 ? participants.length : nOfPrerounds * 2;
  print("participantsInFirstRound: $participantsInFirstRound");
  // calculate the number of rows in the first round
  int rowsNumber = participantsInFirstRound ~/ 2;
  print("rowsNumber: $rowsNumber");

  const int marginBetweenBracket = 10;
  // this is the height of the single bracket container we defined in the single_bracket.dart
  int containerHeight = 30 + marginBetweenBracket;

  List<pw.Widget> columns = [];
  // flag to check if it is the first round (where we fill the names)
  bool firstRound = true;
  bool secondRound = nOfPrerounds > 0;
  // flag to check if there are any prerounds
  bool preroundsExisting = nOfPrerounds > 0;
  print("preroundsExisting: $preroundsExisting");

  const int extraSpace = 12;

  // margin between double brackets (between two signle brackets)
  const double marginBetweenDoubleBracket = 5;
  // how many pixels on each side there are more when building double brackets than single bracket
  double marginOffsetOfDoubleBracket = containerHeight - ((containerHeight-marginBetweenDoubleBracket)/2);


  List<int> rounds = [];
  double marginAvailable = a4Height - ((baseMargin*2) + headerHeight + extraSpace) - (containerHeight * rowsNumber);
  List<int> nOfParticipantsInSecondRound = [];

  print("numberOfColumns: $numberOfColumns");
  for(int column = 0; column < numberOfColumns; column++) {
    List<pw.Widget> brackets = [];

    // if it is the first round create the double brackets with the names
    if(firstRound && !preroundsExisting) {
      // calculate the margin available for the brackets 
      print("marginAvailable: $marginAvailable");
      print("passed margin: ${marginAvailable / rowsNumber}");
      // rowsNumber*2 because we have two participants in each row
      for(int i = 0; i < rowsNumber*2; i+=2) {
        String participant1 = i < participants.length ? participants[i] : '';
        String participant2 = i + 1 < participants.length ? participants[i + 1] : '';
        // if it is the last row then we dont want to add margin to the bottom
        brackets.add(
          buildDoubleBracketPdf(participant1, participant2, (marginAvailable / rowsNumber)/2, (marginAvailable / rowsNumber)/2, ttf),
        );
      }

      // since there are no prerounds, it means in second column there will be no names in each bracket
      // so we add zeros
      for(int i = 0; i < rowsNumber/2; i++) {
        nOfParticipantsInSecondRound.add(0);
      }

      // add the number of rows here, because it may be changed after this
      rounds.add(rowsNumber);

    } else if (firstRound && preroundsExisting) {
      // calculate rows in seconds column
      int rowsInSecondColumn = (participants.length - nOfPrerounds) ~/ 2;
      print("rowsInSecondColumn: $rowsInSecondColumn");

      // calculate the fill number and build brackets and get the number
      // of brackets with two, one and none names
      int participantsLeft = participants.length - (nOfPrerounds * 2);
      print("participantsLeft: $participantsLeft");
      int fillNumber = participantsLeft - rowsInSecondColumn;
      print("fillNumber: $fillNumber");

      // calculate the margin available for the brackets in seconds column
      double marginAvailableForSecondRound = a4Height - ((baseMargin*2) + headerHeight + extraSpace) - (containerHeight * rowsInSecondColumn);
      print("margin available: $marginAvailableForSecondRound");
      double passingMargin = marginAvailableForSecondRound / rowsInSecondColumn;
      print("passing Marign: $passingMargin");
      // dont forget to add the height of the bracket after = 30
      double onePieceMargin = passingMargin / 2;
      print("One piece margin: $onePieceMargin");
      
      int nOfBracketWithTwoNames = 0;
      int nOfBracketWithNoNames = 0;
      // manipulate the fill number
      if(fillNumber > 0) {
        while(fillNumber != 0) {
          nOfBracketWithTwoNames++;
          fillNumber--;
        }
      } else if(fillNumber < 0) {
        while(fillNumber != 0) {
          nOfBracketWithNoNames++;
          fillNumber++;
        }
      }
      
      int nOfBracketWithOneName = rowsInSecondColumn - nOfBracketWithTwoNames - nOfBracketWithNoNames;
      print("nOfBracketWithTwoNames: $nOfBracketWithTwoNames");
      print("nOfBracketWithNoNames: $nOfBracketWithNoNames");
      print("nOfBracketWithOneName: $nOfBracketWithOneName");

      int iterator = 0;
      double marginTracker = onePieceMargin;
      double marginBottomTracker = 0;
      int bracketsTracker = 0;
      int rowsTracker = 0;

      // take track of how many brackets we have builded so far
      int buildedTracker = 0;
      // we take the available margin and subtract the space, that is contained in the containers - so we get the free margin we have to add somewhere
      double marginToFill = marginAvailableForSecondRound + (containerHeight*rowsInSecondColumn) - (containerHeight*nOfBracketWithOneName) - ((containerHeight + marginOffsetOfDoubleBracket* 2)*nOfBracketWithNoNames);

      // we are going to build brackets with priorities over each iteration
      // it will be DOUBLE, SINGLE, NO and over again
      for(int i = 0; i < rowsInSecondColumn; i++) {
        if(nOfBracketWithTwoNames > 0) {
          // we draw nothing here
          marginTracker += (passingMargin+containerHeight);
          print("marginTrackerADDED: $marginTracker");
          bracketsTracker++;
          rowsTracker++;
          nOfBracketWithTwoNames--;
          // if we wont build any brackets, we want to subtract the margin of one bracket with margin around from free margin
          marginToFill -= (passingMargin+containerHeight);
        }
        if(nOfBracketWithOneName > 0) {
          // if it is the last bracket we will build in the column, we put the free margin available in the margin bottom of that
          if(buildedTracker == rowsNumber-1) {
            print("ano");
            double bottomMarginToAdd = onePieceMargin + (containerHeight * (rowsInSecondColumn - (rowsTracker+1)) + passingMargin * (rowsInSecondColumn- (rowsTracker+1)));
            print(bottomMarginToAdd);
            brackets.add(
              buildDoubleBracketPdf(participants[iterator], participants[iterator+1], marginTracker, bottomMarginToAdd, ttf)
            );

          // otherwise we will build the bracket normally
          } else {
            brackets.add(
              buildDoubleBracketPdf(participants[iterator], participants[iterator+1], marginTracker, marginBottomTracker, ttf)
            );
          }

          print("build single");

          buildedTracker++;
          // change the free margin according to what we have builded
          marginToFill -= passingMargin;

          // increment the participants
          iterator += 2;
          bracketsTracker++;
          rowsTracker++;
          if(iterator == participants.length - participantsLeft - 2) {
            marginBottomTracker = calculateBottomMargin(rowsInSecondColumn, bracketsTracker, passingMargin, containerHeight, false, marginOffsetOfDoubleBracket);
          }
          marginTracker = passingMargin;
          nOfBracketWithOneName--;
        }
        if(nOfBracketWithNoNames > 0) {
          
          // print the first bracket normally
          print("build double");
          brackets.add(
            buildDoubleBracketPdf(participants[iterator], participants[iterator+1], marginTracker - marginOffsetOfDoubleBracket, marginBottomTracker, ttf)
          );

          buildedTracker++;
          // here we have to subtract the margin on top but we have to add the offset back
          marginToFill -= (onePieceMargin-marginOffsetOfDoubleBracket);

          iterator += 2;
          bracketsTracker++;
          if(iterator == participants.length - participantsLeft - 2) {
            marginBottomTracker = calculateBottomMargin(rowsInSecondColumn, bracketsTracker, passingMargin, containerHeight, true, marginOffsetOfDoubleBracket);
          }

          // if it is the last bracket in the column, we have to put there the free margin which will be subtracted by margin between those brackets and the offset to get the correct value
          if(buildedTracker == rowsNumber-1){
            print("margin to fill: $marginToFill");
            brackets.add(
              buildDoubleBracketPdf(participants[iterator], participants[iterator+1], marginBetweenDoubleBracket, marginToFill, ttf)
            );
          } else {
            brackets.add(
              buildDoubleBracketPdf(participants[iterator], participants[iterator+1], marginBetweenDoubleBracket, marginBottomTracker, ttf)
            );
          }

          buildedTracker++;
          marginToFill -= (onePieceMargin-marginOffsetOfDoubleBracket);

          iterator += 2;
          bracketsTracker++;
          if(iterator == participants.length - participantsLeft - 2) {
            marginBottomTracker = calculateBottomMargin(rowsInSecondColumn, bracketsTracker, passingMargin, containerHeight, true, marginOffsetOfDoubleBracket);
          }
          nOfBracketWithNoNames--;
          marginTracker = passingMargin - marginOffsetOfDoubleBracket;
          rowsTracker++;
        }
      }

      rounds.add(rowsNumber);

      rowsNumber = rowsInSecondColumn;
    } else {
      if(preroundsExisting && secondRound) {
        // calculate the number of participants left after the prerounds
        int participantsLeft = participants.length - (nOfPrerounds * 2);
        // if fill number is greater than 0 then there will be atleast one row with two participants
        int fillNumber = participantsLeft - rowsNumber;
        print("fillNumber: $fillNumber");

        // calculate the margin available for the brackets
        double marginAvailable = a4Height - ((baseMargin*2) + headerHeight + extraSpace) - (containerHeight * rowsNumber);
        print("passed margin: ${marginAvailable / rowsNumber}");

        // get the position of the first participant in the second round
        // this is the offset for the participnats
        int iterator = participants.length - participantsLeft;
        print("iterator: $iterator");

        int nOfBracketWithTwoNames = 0;
        int nOfBracketWithNoNames = 0;
        // manipulate the fill number
        if(fillNumber > 0) {
          while(fillNumber != 0) {
            nOfBracketWithTwoNames++;
            fillNumber--;
          }
        } else if(fillNumber < 0) {
          while(fillNumber != 0) {
            nOfBracketWithNoNames++;
            fillNumber++;
          }
        }

        int nOfBracketWithOneName = rowsNumber - nOfBracketWithTwoNames - nOfBracketWithNoNames;

        int bracketTracker = 0;
        while(bracketTracker != rowsNumber) {
          if(nOfBracketWithTwoNames > 0) {
            brackets.add(
              buildDoubleBracketPdf(participants[iterator], participants[iterator+1], (marginAvailable / rowsNumber)/2, (marginAvailable / rowsNumber)/2, ttf),
            );
            iterator += 2;
            nOfBracketWithTwoNames--;
            bracketTracker++;
            nOfParticipantsInSecondRound.add(2);
          }
          if(nOfBracketWithOneName > 0) {
            brackets.add(
              buildDoubleBracketPdf(participants[iterator], "", (marginAvailable / rowsNumber)/2, (marginAvailable / rowsNumber)/2, ttf),
            );
            iterator++;
            nOfBracketWithOneName--;
            bracketTracker++;
            nOfParticipantsInSecondRound.add(1);
          }
          if(nOfBracketWithNoNames > 0) {
            brackets.add(
              buildDoubleBracketPdf("", "", (marginAvailable / rowsNumber)/2, (marginAvailable / rowsNumber)/2, ttf),
            );
            nOfBracketWithNoNames--;
            bracketTracker++;
            nOfParticipantsInSecondRound.add(0);
          }
        }
        secondRound = false;
      } else {
        // if it is not the first round calculate the new number of rows
        // which is half of the previous number of rows (rounded up)
        rowsNumber = (rowsNumber + 1) ~/ 2;
        // calculate the margin available for the brackets
        double marginAvailable = a4Height - ((baseMargin*2) + headerHeight + extraSpace) - (containerHeight * rowsNumber);
        // if it is last column then add a single bracket to fill the winner
        if(column == numberOfColumns - 1) {
          brackets.add(
            buildSingleBracketPdf("", ttf),
          );
        } else {
          // otherwise add the empty double brackets
          for(int i = 0; i < rowsNumber; i++) {
            brackets.add(
              buildDoubleBracketPdf("", "", (marginAvailable / rowsNumber)/2, (marginAvailable / rowsNumber)/2, ttf),
            );
          }
        }
      }
    }

    // since the first round is being added in its iterations
    // we dont want to add it twice 
    if(!firstRound) {
      rounds.add(rowsNumber);
    }

    // add the column to the list of columns
    columns.add(
      pw.Container(
        width: columnWidth,
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: brackets,
        ),
      ),
    );

    // set the flag to false after the first iteration
    firstRound = false;
  }

  drawBracketLines(DrawBracketLinesParams(
    context: context,
    rows: rounds,
    marginAvailable: marginAvailable,
    preroundsExisting: preroundsExisting,
    containerHeight: containerHeight,
    baseMargin: baseMargin,
    extraSpace: extraSpace,
    columnWidth: columnWidth,
    nOfParticipantsInSecondRoundBracket: nOfParticipantsInSecondRound,
    marginOffsetOfDoubleBracket: marginOffsetOfDoubleBracket,
    marginBetweenBracket: marginBetweenBracket,
  ));

  print("nOfParticipantsInSecondRound: $nOfParticipantsInSecondRound");
  print("rounds: $rounds");
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: columns,
  );
}

Future<String> savePdf(Future<Uint8List> pdfData) async {
  // Get the current working directory
  final programDir = Directory.current;

  // Define the desired path
  final outputDir = Directory("${programDir.path}/pavouk");
  final filePath = "${outputDir.path}/file.pdf";

  // Ensure the directory exists
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  // Write the PDF file
  final file = File(filePath);
  await file.writeAsBytes(await pdfData);

  return file.path;
}

double calculateBottomMargin(int numberOfSecondRoundRows, int currentRow, double passingMargin, int containerHeight, bool isDoubleDoubleBracket, double marginDiff) {
  double result = (isDoubleDoubleBracket) ? marginDiff : 0;
  if(isDoubleDoubleBracket) {
    for(int i = currentRow; i < numberOfSecondRoundRows; i++) {
      result += passingMargin;
    }
  }
  return result + passingMargin/2;
}