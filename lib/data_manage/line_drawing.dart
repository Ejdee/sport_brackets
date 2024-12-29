import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class DrawBracketLinesParams {
  final pw.Context context;
  final List<int> rows;
  final double marginAvailable;
  final bool preroundsExisting;
  final int containerHeight;
  final double baseMargin;
  final int extraSpace;
  final double columnWidth;
  final List<int> nOfParticipantsInSecondRoundBracket;
  final double marginOffsetOfDoubleBracket;
  final int marginBetweenBracket;

  DrawBracketLinesParams({
    required this.context,
    required this.rows,
    required this.marginAvailable,
    required this.preroundsExisting,
    required this.containerHeight,
    required this.baseMargin,
    required this.extraSpace,
    required this.columnWidth,
    required this.nOfParticipantsInSecondRoundBracket,
    required this.marginOffsetOfDoubleBracket,
    required this.marginBetweenBracket,
  });
}

void drawBracketLines(DrawBracketLinesParams params) {

  // distance that has to be traveled from the middle of bracket to the middle of the participant bracket
  double distanceToBracketCenter = ((params.containerHeight - params.marginBetweenBracket) / 4) + (params.marginBetweenBracket / 2);

  double marginAvailable = params.marginAvailable + (params.rows[0] * params.containerHeight);

  const int containerWidth = 100;

  double check = params.columnWidth;
  print("columnWidth: $check");
  double check2 = params.columnWidth*(1)/2;
  print("starting x1 position: $check2");

  // draw lines for bracets that are not prerounds
  int increment = 1;
  for(int i = 0; i < params.rows.length; i++) {
    print("i: $i");
    if(i == params.rows.length - 1) {
      continue;
    }
    double marginPassed = (marginAvailable - (params.rows[i] * params.containerHeight)) / params.rows[i];
    double yPos = (marginPassed/2) + params.containerHeight/2 + params.baseMargin + params.extraSpace;
    double diff = marginPassed + params.containerHeight;

    if(i == 0 && params.preroundsExisting) {
      increment+=2;
      for(int j = 0; j < params.nOfParticipantsInSecondRoundBracket.length; j++) {
        // if there are not two names in the bracket, we need to create lines
        if(params.nOfParticipantsInSecondRoundBracket[j] < 2) {
          // if there is one name, we need to draw the line only from one bracket
          double marginPassedInSecondRound = (marginAvailable - (params.nOfParticipantsInSecondRoundBracket.length * params.containerHeight)) / params.nOfParticipantsInSecondRoundBracket.length;
          double yPosOfBottomBracket = (marginPassedInSecondRound/2) + params.containerHeight/2 + params.baseMargin + params.extraSpace;
          double diffInSecondRound = marginPassedInSecondRound + params.containerHeight;
          
          double yPosOfMiddle = yPosOfBottomBracket + diffInSecondRound*(params.nOfParticipantsInSecondRoundBracket.length - 1 - j);
          print("yPosOfMiddle: $yPosOfMiddle");

          // we take the column width, subtract the width of the container and divide it by 4 to get the end position 
          double xEndOfContainer = params.columnWidth - ((params.columnWidth-containerWidth)/4);
          if(params.rows.length <= 3) {
            xEndOfContainer = params.columnWidth - ((params.columnWidth-containerWidth)/2)+15;
          } else if (params.rows.length == 4) {
            xEndOfContainer = params.columnWidth - ((params.columnWidth-containerWidth)/4)-15;
          }

          // distance from forked fork to fork 
          const int lineOffset = 15;

          // if there is one participant in the next bracket, we have one preround before that, so we will draw one "fork"
          if(params.nOfParticipantsInSecondRoundBracket[j] == 1) {
            //drawLine(params.context, params.columnWidth*(i+1)/2, yPosOfMiddle, params.columnWidth*(increment)/2, yPosOfMiddle);
            drawLine(params.context, xEndOfContainer, yPosOfMiddle-distanceToBracketCenter, params.columnWidth*(i+1), yPosOfMiddle-distanceToBracketCenter);
            drawLine(params.context, xEndOfContainer, yPosOfMiddle+distanceToBracketCenter, params.columnWidth*(i+1), yPosOfMiddle+distanceToBracketCenter);
            drawLine(params.context, params.columnWidth*(i+1), yPosOfMiddle-distanceToBracketCenter, params.columnWidth*(i+1), yPosOfMiddle+distanceToBracketCenter);
            drawLine(params.context, params.columnWidth*(i+1), yPosOfMiddle, params.columnWidth*(increment)/2, yPosOfMiddle);
          // if there aren't any participants, we have to draw forked fork, since we have two prerounds before this
          } else if(params.nOfParticipantsInSecondRoundBracket[j] == 0) {
            // FORKED FORK - outer containers
            drawLine(params.context, xEndOfContainer, yPosOfMiddle-(distanceToBracketCenter+params.marginOffsetOfDoubleBracket), params.columnWidth*(i+1), yPosOfMiddle-(distanceToBracketCenter+params.marginOffsetOfDoubleBracket));
            drawLine(params.context, xEndOfContainer, yPosOfMiddle+(distanceToBracketCenter+params.marginOffsetOfDoubleBracket), params.columnWidth*(i+1), yPosOfMiddle+(distanceToBracketCenter+params.marginOffsetOfDoubleBracket));

            // FORKED FORK - inner containers
            drawLine(params.context, xEndOfContainer, yPosOfMiddle-(distanceToBracketCenter)+params.marginOffsetOfDoubleBracket, params.columnWidth*(i+1), yPosOfMiddle-(distanceToBracketCenter)+params.marginOffsetOfDoubleBracket);
            drawLine(params.context, xEndOfContainer, yPosOfMiddle+(distanceToBracketCenter)-params.marginOffsetOfDoubleBracket, params.columnWidth*(i+1), yPosOfMiddle+(distanceToBracketCenter)-params.marginOffsetOfDoubleBracket);

            // FORKED FORK - connect the previous two steps 

            drawLine(params.context, params.columnWidth, yPosOfMiddle+distanceToBracketCenter+params.marginOffsetOfDoubleBracket, params.columnWidth, yPosOfMiddle+params.marginOffsetOfDoubleBracket-distanceToBracketCenter);
            drawLine(params.context, params.columnWidth, yPosOfMiddle-params.marginOffsetOfDoubleBracket+distanceToBracketCenter, params.columnWidth, yPosOfMiddle-params.marginOffsetOfDoubleBracket-distanceToBracketCenter);

            // FORK
            drawLine(params.context, params.columnWidth, yPosOfMiddle-params.marginOffsetOfDoubleBracket, params.columnWidth+lineOffset, yPosOfMiddle-params.marginOffsetOfDoubleBracket);
            drawLine(params.context, params.columnWidth, yPosOfMiddle+params.marginOffsetOfDoubleBracket, params.columnWidth+lineOffset, yPosOfMiddle+params.marginOffsetOfDoubleBracket);
            drawLine(params.context, params.columnWidth+lineOffset, yPosOfMiddle-params.marginOffsetOfDoubleBracket, params.columnWidth+lineOffset, yPosOfMiddle+params.marginOffsetOfDoubleBracket);
            drawLine(params.context, params.columnWidth+lineOffset, yPosOfMiddle, params.columnWidth*(increment)/2, yPosOfMiddle);
          }
        }
      }

    } else if (i == 0 && !params.preroundsExisting) {
      increment += 2;
      print("$yPos");
      print("marginPassed: $marginPassed");
      print("diff: $diff");
      const int lineOffset = 15;

      // we take the column width, subtract the width of the container and divide it by 4 to get the end position 
      double xEndOfContainer = params.columnWidth - ((params.columnWidth-containerWidth)/4);
      if(params.rows.length <= 3) {
        xEndOfContainer = params.columnWidth - ((params.columnWidth-containerWidth)/2)+15;
      } else if (params.rows.length == 4) {
        xEndOfContainer = params.columnWidth - ((params.columnWidth-containerWidth)/4)-15;
      }

      for(int j = 0; j < params.rows[i]; j+=2) {
        print("ypos+diff*j: ${yPos+diff*j}");
        // FORKED FORK - starting lines
        drawLine(params.context, xEndOfContainer, yPos+diff*j+distanceToBracketCenter, params.columnWidth, yPos+diff*j+distanceToBracketCenter);
        drawLine(params.context, xEndOfContainer, yPos+diff*j-distanceToBracketCenter, params.columnWidth, yPos+diff*j-distanceToBracketCenter);

        drawLine(params.context, xEndOfContainer, yPos+diff*(j+1)+distanceToBracketCenter, params.columnWidth, yPos+diff*(j+1)+distanceToBracketCenter);
        drawLine(params.context, xEndOfContainer, yPos+diff*(j+1)-distanceToBracketCenter, params.columnWidth, yPos+diff*(j+1)-distanceToBracketCenter);

        // vertical lines to connect starting lines
        drawLine(params.context, params.columnWidth, yPos+diff*j+distanceToBracketCenter, params.columnWidth, yPos+diff*j-distanceToBracketCenter);
        drawLine(params.context, params.columnWidth, yPos+diff*(j+1)+distanceToBracketCenter, params.columnWidth, yPos+diff*(j+1)-distanceToBracketCenter);

        // horizontal lines from the connecting lines
        drawLine(params.context, params.columnWidth, yPos+diff*j, params.columnWidth+lineOffset, yPos+diff*j);
        drawLine(params.context, params.columnWidth, yPos+diff*(j+1), params.columnWidth+lineOffset, yPos+diff*(j+1));

        // vertical line to connect those horizontal lines we created before this
        drawLine(params.context, params.columnWidth+lineOffset, yPos+diff*(j+1), params.columnWidth+lineOffset, yPos+diff*j);

        double middleOfTwo = yPos+diff*j+params.containerHeight/2+marginPassed/2;
        // last line from the connecting line
        drawLine(params.context, params.columnWidth+lineOffset, middleOfTwo, params.columnWidth*(increment)/2, middleOfTwo);
      }

    } else if (i == 1 && params.preroundsExisting) {

      List<int> indexOfTwos = [];
      // we check for brackets in second round that are starters, we have to draw different lines for them
      // so we create a list where will we put those indexes from the back, because y-position starts from the bototm of the page
      // and we have helper variable that calculates the number of brackets that are starters, but from the start.
      for(int j = 0; j < params.rows[i]; j++) {
        if(params.nOfParticipantsInSecondRoundBracket[j] == 2) {
          indexOfTwos.add(params.rows[i]-j-1);
        }
      }

      print("$indexOfTwos");

      double xEndOfContainer = params.columnWidth - ((params.columnWidth-containerWidth)/4) + params.columnWidth;
      const int lineOffset = 15;
      if(params.rows.length <= 3) {
        xEndOfContainer = params.columnWidth - ((params.columnWidth-containerWidth)/2)+ params.columnWidth + 15;
      } else if (params.rows.length == 4) {
        xEndOfContainer = params.columnWidth - ((params.columnWidth-containerWidth)/4) + params.columnWidth -15;
      }

      // if there are some brackets that needs to be drawn again, do it
      if(indexOfTwos.isNotEmpty) {
        for(int j = 0; j < indexOfTwos.length; j++) {
          // two tails starting from brackets
          drawLine(params.context, xEndOfContainer, yPos+diff*(indexOfTwos[j])+distanceToBracketCenter, params.columnWidth*2, yPos+diff*(indexOfTwos[j])+distanceToBracketCenter);
          drawLine(params.context, xEndOfContainer, yPos+diff*(indexOfTwos[j])-distanceToBracketCenter, params.columnWidth*2, yPos+diff*(indexOfTwos[j])-distanceToBracketCenter);
          // vertical line that is connecting those two tails
          drawLine(params.context, params.columnWidth*2, yPos+diff*(indexOfTwos[j])+distanceToBracketCenter, params.columnWidth*2, yPos+diff*(indexOfTwos[j])-distanceToBracketCenter);
          // short horizontal line for visual satisfaction
          drawLine(params.context, params.columnWidth*2, yPos+diff*(indexOfTwos[j]), params.columnWidth*2+lineOffset, yPos+diff*(indexOfTwos[j]));
        }
      }
      bool skip = false;
      for(int j = 0; j < params.rows[i]; j++) {

        // if the row is even, we want to draw the big vertical that connects two brackets and horizontal that goes to the next bracket in the next row
        if(j % 2 == 0 && params.rows[i] != 1) {
          drawLine(params.context, params.columnWidth*(i+1)+lineOffset, yPos+diff*j, params.columnWidth*(i+1)+lineOffset, yPos+diff*(j+1));
          drawLine(params.context, params.columnWidth*(i+1)+lineOffset, (yPos+diff*(j+1)) - marginPassed/2 - params.containerHeight/2, params.columnWidth*(increment+2)/2, (yPos+diff*(j+1)) - marginPassed/2 - params.containerHeight/2);
        } else if (j % 2 == 0 && params.rows[i] == 1) {
          drawLine(params.context, params.columnWidth*(i+1)+lineOffset, (yPos+diff*(j)), (params.columnWidth*(increment+2)/2)-40, (yPos+diff*(j)));
        }

        // we want to skip the row, that we drew before
        for(int k = 0; k < indexOfTwos.length; k++) {
          if(j == indexOfTwos[k]) {
            print("setting skip for tru");
            skip = true; 
            break;
          }
        }
        if(skip){
          skip = false;
          continue;
        }

        print("doing for: j=$j");

        // draw the simple line for bracket
        drawLine(params.context, params.columnWidth*increment/2, yPos+diff*j, params.columnWidth*(i+1)+lineOffset, yPos+diff*j);

      }
      increment += 2;

    } else {

      for(int j = 0; j < params.rows[i]; j++) {
        // the ones that are starting from the bracket
        drawLine(params.context, params.columnWidth*increment/2, yPos+diff*j, params.columnWidth*(i+1), yPos+diff*j);
      }
      increment += 2;

      // draw vertical lines 
      for(int j = 0; j < params.rows[i]; j+=2) {
        if(params.rows[i] >= 2) {
          drawLine(params.context, params.columnWidth*(i+1), yPos+diff*j, params.columnWidth*(i+1), yPos+diff*(j+1));
        }
      }
      
      // draw the last horizontal line to the next bracket
      for(int j = 0; j < params.rows[i]; j++) {
        if(i == params.rows.length - 2 && params.rows[i] == 1) {
          drawLine(params.context, params.columnWidth*(i+1), yPos, (params.columnWidth*(increment)/2) - 40, yPos);
        } else {
          if(params.rows[i] >= 2) {
            j++;
          }
          drawLine(params.context, params.columnWidth*(i+1), (yPos+diff*j) - marginPassed/2 - params.containerHeight/2, params.columnWidth*(increment)/2, (yPos+diff*j) - marginPassed/2 - params.containerHeight/2);
        }
      }
    }
  }


  // get the width and height of a4 page
  final a4Width = PdfPageFormat.a4.landscape.width;

  drawLine(params.context, a4Width-250, 150, a4Width-90, 150);
  drawLine(params.context, a4Width-250, 125, a4Width-90, 125);
  drawLine(params.context, a4Width-250, 100, a4Width-90, 100);
  drawLine(params.context, a4Width-250, 75, a4Width-90, 75);
}

void drawLine(pw.Context context, double x1, double y1, double x2, double y2) {
  final canvas = context.canvas;
  canvas
    ..setColor(PdfColors.black)
    ..moveTo(x1, y1)
    ..lineTo(x2, y2)
    ..strokePath();
}