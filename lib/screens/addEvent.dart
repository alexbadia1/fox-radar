// import 'package:communitytabs/components/addEvent/formPart1.dart';
// import 'package:communitytabs/components/imagePicker/addImage.dart';
// import 'package:communitytabs/constants/marist_color_scheme.dart';
// import 'package:communitytabs/data/club_event_data.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:communitytabs/data/pageViewMetadata.dart';
// import 'package:communitytabs/components/addEvent/addEventAppBar.dart';
// import 'package:communitytabs/data/slidingUpPanelMetadata.dart';
//
// class AddEventContent extends StatefulWidget {
//   @override
//   _AddEventContentState createState() => _AddEventContentState();
// }
//
// class _AddEventContentState extends State<AddEventContent> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Consumer<SlidingUpPanelMetaData>(
//           builder: (context, slidingUpPanelState, child) {
//             return slidingUpPanelState.getPanelIsClosed
//                 ? Container(
//                   color: cBackground,
//                 )
//                 : ChangeNotifierProvider<ClubEventData>(
//                     create: (context) => ClubEventData.nullConstructor(),
//                     child: Container(
//                       color: cBackground,
//                       height: MediaQuery.of(context).size.height,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           AddEventAppBar(),
//                           Expanded(child: EventForm()),
//                         ],
//                       ),
//                     ),
//                   );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class EventForm extends StatefulWidget {
//   @override
//   _EventFormState createState() => _EventFormState();
// }
//
// class _EventFormState extends State<EventForm> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<PageViewMetaData>(
//       builder: (context, pageViewState, child) {
//         return PageView(
//           controller: pageViewState.pageViewController,
//           physics: NeverScrollableScrollPhysics(),
//           children: <Widget>[
//             FormPart1(),
//             AddImage(),
//             Container(
//               color: Colors.blueAccent,
//               child: Center(
//                 child: Text('3'),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// //Form Section Headers and ProgressBars
// //Container(
// //  decoration: BoxDecoration(
// //    color: cCard,
// //    border: Border(bottom: BorderSide(width: .25, color: Color.fromRGBO(255, 255, 255, .7)))
// //  ),
// //  width: double.infinity,
// //  height: MediaQuery.of(context).size.height * .0725,
// //  child: Row(
// //    mainAxisAlignment: MainAxisAlignment.spaceAround,
// //    children: <Widget>[
// //      SizedBox(width: MediaQuery.of(context).size.width * .05),
// //      FormTitle(),
// //      Expanded(child: SizedBox()),
// //      ProgressBar(),
// //      SizedBox(width: MediaQuery.of(context).size.width * .05),
// //    ],
// //  ),
// //),
