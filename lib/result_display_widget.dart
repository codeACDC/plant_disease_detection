import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constants.dart';

class ResultDisplayingWidget extends StatelessWidget {
  final List recognition;
  final TextStyle bold =
  TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600);
  final TextStyle normal = TextStyle(fontSize: 12.sp);

  ResultDisplayingWidget({
    super.key,
    required this.recognition,
  });

  List recognitionKey() =>
      ['w', 'x', 'h', 'y'];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.1,
        maxChildSize: 0.5,
        builder: (_, ScrollController scrollController) => Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            // borderRadius: BORDER_RADIUS_BOTTOM_SHEET
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.keyboard_arrow_up,
                      size: 48.h, color: Colors.orange),
                  Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Column(
                      children: [
                        ...recognition.map((e) => Card(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'rect:',
                                    style: bold,
                                  ),
                                  ...e[PredictionConsts.rect]
                                      .values
                                      .map((el) => Text(
                                    ' ${recognitionKey().elementAt(e[PredictionConsts.rect].values.toList().indexOf(el))}: ${el.toString().substring(0, 3)}',
                                    style: normal,
                                  ))
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'confidence:',
                                    style: bold,
                                  ),
                                  Text(
                                    ' ${(e[PredictionConsts.confidence] * 100).toString().substring(0, 4)}%',
                                    style: normal,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'detected class: ',
                                    style: bold,
                                  ),
                                  Text(
                                    (e[PredictionConsts.detectedClass])
                                        .toString(),
                                    style: normal,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
