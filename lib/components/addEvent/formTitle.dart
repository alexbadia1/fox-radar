// import 'package:communitytabs/data/pageViewMetadata.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class FormTitle extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     String _title = '';
//     return Consumer<PageViewMetaData>(
//       builder: (context, pageViewState, child) {
//         switch (pageViewState.formStepNum) {
//           case 1:
//             _title = 'Step 1: Event';
//             break;
//           case 2:
//             _title = 'Pick a Photo';
//             break;
//           case 3:
//             _title = 'Event Preview';
//             break;
//           default:
//             _title = '';
//             break;
//         } //switch
//         return Container(
//           color: Colors.transparent,
//           child: Center(
//             child: Text(
//               _title,
//               style: TextStyle(fontSize: 18.0, color: Colors.white),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }