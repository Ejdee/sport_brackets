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

  // create a list of integers that will hold the information if the line
  // has been drawn from that bracket or not.. the values will be 0(is not drawn) or 1(is drawn)
  List<int> hasLineDrawn = [];
  for(int i = 0; i < params.rows[0]; i++) {
    hasLineDrawn.add(0);
  }

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

    // draw horizontal lines 
    for(int j = 0; j < params.rows[i]; j++) {
      // the ones that are starting from the bracket
      drawLine(params.context, params.columnWidth*increment/2, yPos+diff*j, params.columnWidth*(i+1), yPos+diff*j);
    }
    increment += 2;
    
    if(params.preroundsExisting && i == 0) {
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
            for(int k = 0; k < hasLineDrawn.length; k++) {
              if(hasLineDrawn[k] == 0) {
                drawLine(params.context, params.columnWidth*(i+1), yPos+diff*(hasLineDrawn.length - k - 1), params.columnWidth*(i+1), yPosOfMiddle);
                drawLine(params.context, params.columnWidth*(i+1), yPosOfMiddle, params.columnWidth*(increment)/2, yPosOfMiddle);
                hasLineDrawn[k] = 1;
                break;
              }
              //TODO: anohter line bro
            }

          } else if(params.nOfParticipantsInSecondRoundBracket[j] == 0) {
            int count = 0;
            for(int k = 0; k < hasLineDrawn.length; k++) {
              if(hasLineDrawn[k] == 0) {
                drawLine(params.context, params.columnWidth*(i+1), yPos+diff*(hasLineDrawn.length - k - 1), params.columnWidth*(i+1), yPosOfMiddle);
                drawLine(params.context, params.columnWidth*(i+1), yPosOfMiddle, params.columnWidth*(increment)/2, yPosOfMiddle);
                count++;
                hasLineDrawn[k] = 1;
              }
              if(count == 2) {
                break;
              }
            }
          }
        }
      }

    } else {

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

  //testMarginPass is the distance that each bracket has on both sides 
  // that means we can take the whole available margin which is
  // a4Height - ((baseMargin*2) + headerHeight + extraSpace) and substract
  // testMarginPass and 15 since the one bracket has height 15 and we have a 
  // middle of one of the brackets 
//  double yPos = (marginPassed/2) + 15 + baseMargin + extraSpace;
//  double diff = testMarginPass + 30;
//  print("testMarginPass: $testMarginPass");
//  drawLine(context, columnWidth/2, yPos, columnWidth, yPos);
//  drawLine(context, columnWidth/2, yPos+diff, columnWidth, yPos+diff);
//  drawLine(context, columnWidth/2, yPos+diff*2, columnWidth, yPos+diff*2);
//  drawLine(context, columnWidth/2, yPos+diff*3, columnWidth, yPos+diff*3);
//  drawLine(context, columnWidth, yPos+diff*3, columnWidth, yPos+diff*2);
//  drawLine(context, columnWidth, yPos+diff*1, columnWidth, yPos+diff*0);
//  drawLine(context, columnWidth, (yPos+diff*3) - testMarginPass/2 - 15, columnWidth*3/2, (yPos+diff*3) - testMarginPass/2 -15);
//  drawLine(context, columnWidth, (yPos+diff*1) - testMarginPass/2 - 15, columnWidth*3/2, (yPos+diff*1) - testMarginPass/2 -15);

void drawLine(pw.Context context, double x1, double y1, double x2, double y2) {
  final canvas = context.canvas;
  canvas
    ..setColor(PdfColors.black)
    ..moveTo(x1, y1)
    ..lineTo(x2, y2)
    ..strokePath();
}