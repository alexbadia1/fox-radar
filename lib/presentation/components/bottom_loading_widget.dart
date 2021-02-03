import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';

class BottomLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenPaddingBottom = MediaQuery.of(context).padding.bottom;
    final screenInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    final screenPaddingTop = MediaQuery.of(context).padding.top;

    final _realHeight = screenHeight -
        screenPaddingTop -
        screenPaddingBottom +
        screenInsetsBottom;

    return Builder(builder: (context) {
      final SuggestedEventsState _suggestedEventsState =
          context.watch<SuggestedEventsBloc>().state;

      if (_suggestedEventsState is SuggestedEventsStateSuccess) {
        if (!_suggestedEventsState.maxEvents) {
          return Container(
            height: screenHeight * .65,
            width: double.infinity,
            child: Column(
              children: [
                Expanded(flex: 1, child: SizedBox()),
                SizedBox(
                  height: _realHeight * .03,
                  width: screenWidth * .05,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(cWhite70),
                    strokeWidth: 2.25,
                  ),
                ),
                Expanded(flex: 3, child: SizedBox()),
              ],
            ),
          );
        }
        else{
          return Container(height: _realHeight * .1);
        }
      } else {
        return Container();
      }
    });
  } // build
} // BottomLoadingWidget
