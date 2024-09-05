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
  });
}

void drawBracketLines(DrawBracketLinesParams params) {

  double marginAvailable = params.marginAvailable + (params.rows[0] * params.containerHeight);

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

    if(params.preroundsExisting && i == 0) {
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

          if(params.nOfParticipantsInSecondRoundBracket[j] == 1) {
            drawLine(params.context, params.columnWidth*(i+1)/2, yPosOfMiddle, params.columnWidth*(increment)/2, yPosOfMiddle);
          } else if(params.nOfParticipantsInSecondRoundBracket[j] == 0) {
            drawLine(params.context, params.columnWidth*(i+1)/2, yPosOfMiddle-17.5, params.columnWidth*(i+1), yPosOfMiddle-17.5);
            drawLine(params.context, params.columnWidth*(i+1)/2, yPosOfMiddle+17.5, params.columnWidth*(i+1), yPosOfMiddle+17.5);
            drawLine(params.context, params.columnWidth*(i+1), yPosOfMiddle-17.5, params.columnWidth*(i+1), yPosOfMiddle+17.5);
            drawLine(params.context, params.columnWidth*(i+1), yPosOfMiddle, params.columnWidth*(increment)/2, yPosOfMiddle);
          }
        }
      }

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
}

void drawLine(pw.Context context, double x1, double y1, double x2, double y2) {
  final canvas = context.canvas;
  canvas
    ..setColor(PdfColors.black)
    ..moveTo(x1, y1)
    ..lineTo(x2, y2)
    ..strokePath();
}