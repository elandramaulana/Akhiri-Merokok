// import 'dart:math';

// import 'package:akhiri_merokok/core/utils/keys.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:screen/screen.dart';

// import '../../data/models/answer.dart';
// import '../../data/models/users.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class QuizScreen7 extends StatefulWidget {
//   const QuizScreen7({Key? key}) : super(key: key);

//   @override
//   State<QuizScreen7> createState() => _QuizScreen7State();
// }

// class _QuizScreen7State extends State<QuizScreen7> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: BrightnessSliderContainer(),
//       ),
//     );
//   }
// }

// class BrightnessSliderContainer extends StatefulWidget {
//   @override
//   _BrightnessSliderContainerState createState() =>
//       _BrightnessSliderContainerState();
// }

// class _BrightnessSliderContainerState extends State<BrightnessSliderContainer> {
//   double brightness = 0.0;

//   @override
//   Widget build(BuildContext context) {
//     return /* Slider  */ CupertinoSlider(
//       activeColor: CupertinoColors.activeGreen,
//       min: 0.0,
//       max: 1.0,
//       value: brightness,
//       onChanged: (val) {
//         Screen.setBrightness(brightness);
//         setState(() {
//           brightness = val;
//         });
//       },
//     );
//   }
// }

// class RangeSliderWidget extends StatefulWidget {
//   @override
//   _RangeSliderWidgetState createState() => _RangeSliderWidgetState();
// }

// class _RangeSliderWidgetState extends State<RangeSliderWidget> {
//   static double _lowerValue = 0.0;
//   static double _upperValue = 10.0;

//   RangeValues values = RangeValues(_lowerValue, _upperValue);

//   @override
//   Widget build(BuildContext context) {
//     return SliderTheme(
//       data: SliderTheme.of(context).copyWith(
//         trackHeight: 15,
//         overlayColor: Colors.transparent,
//         minThumbSeparation: 100,
//         rangeThumbShape: RoundRangeSliderThumbShape(
//           enabledThumbRadius: 10,
//           disabledThumbRadius: 10,
//         ),
//       ),
//       child: RangeSlider(
//         activeColor: CupertinoColors.activeGreen,
//         labels: RangeLabels(
//             values.start.abs().toString(), values.end.abs().toString()),
//         min: 0.0,
//         max: 1.0,
//         values: values,
//         onChanged: (val) {
//           setState(() {
//             values = val;
//           });
//         },
//       ),
//     );
//   }
// }
