import 'package:communitytabs/components/addEvent/formPart1.dart';
import 'package:communitytabs/components/imagePicker/addImage.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/logic/cubits/cubits.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/data/pageViewMetadata.dart';
import 'package:communitytabs/components/addEvent/addEventAppBar.dart';

class CreateEventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SlidingUpPanelState _slidingUpPanelState =
        context.watch<SlidingUpPanelCubit>().state;

    /// Sliding Up Panel Closed
    /// Show a blank container, background isn't white to avoid white flicker when closing the panel
    if (_slidingUpPanelState is SlidingUpPanelClosed) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: cBackground,
      );
    } // if

    /// Sliding Up Panel Open
    /// Show a the actual event form
    else if (_slidingUpPanelState is SlidingUpPanelOpen) {
      return SafeArea(
        child: Scaffold(
          body: BlocProvider<CreateEventBloc>(
            create: (context) => CreateEventBloc(),
            child: Container(
              color: cBackground,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AddEventAppBar(),
                  Expanded(
                    child: Consumer<PageViewMetaData>(
                      builder: (context, pageViewState, child) {
                        return PageView(
                          controller: pageViewState.pageViewController,
                          physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            FormPart1(),
                            AddImage(),
                            Container(
                              color: Colors.blueAccent,
                              child: Center(
                                child: Text('3'),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } // else-if

    else {
      return Container(
          child: Center(
              child: Text(
                  'Sliding Up Panel Cubit did not return a state that is either open or closed!')));
    } // else
  }
}

//Form Section Headers and ProgressBars
//Container(
//  decoration: BoxDecoration(
//    color: cCard,
//    border: Border(bottom: BorderSide(width: .25, color: Color.fromRGBO(255, 255, 255, .7)))
//  ),
//  width: double.infinity,
//  height: MediaQuery.of(context).size.height * .0725,
//  child: Row(
//    mainAxisAlignment: MainAxisAlignment.spaceAround,
//    children: <Widget>[
//      SizedBox(width: MediaQuery.of(context).size.width * .05),
//      FormTitle(),
//      Expanded(child: SizedBox()),
//      ProgressBar(),
//      SizedBox(width: MediaQuery.of(context).size.width * .05),
//    ],
//  ),
//),
