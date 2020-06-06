import 'package:communitytabs/data/pageViewMetadata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageViewMetaData>(
      builder: (context, pageViewState, child) {
        return Container(
          color: Colors.transparent,
          child: StepProgressIndicator(
            totalSteps: 3,
            currentStep: pageViewState.formStepNum,
            size: 36,
            selectedColor: Colors.green,
            unselectedColor: Colors.grey[200],
            customStep: (index, color, _) => color == Colors.green
                ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: color, width: 2.0, style: BorderStyle.solid),
              ),
              child: Center(
                child: Text(
                  (index + 1).toString(),
                ),
              ),
            )
                : Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: color, width: 2.0, style: BorderStyle.solid),
              ),
              child: Center(
                child: Text(
                  (index + 1).toString(),
                  style: TextStyle(color: Colors.grey[200]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}