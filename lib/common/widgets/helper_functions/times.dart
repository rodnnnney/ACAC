// import 'package:ACAC/common_layer/widgets/helper_functions/start_stop.dart';
//
// class Time {
//   List<StartStop> hours;
//
//   Time({
//     required StartStop monday,
//     required StartStop tuesday,
//     required StartStop wednesday,
//     required StartStop thursday,
//     required StartStop friday,
//     required StartStop saturday,
//     required StartStop sunday,
//   }) : hours = [monday, tuesday, wednesday, thursday, friday, saturday, sunday];
//
//   StartStop get monday => hours[0];
//   StartStop get tuesday => hours[1];
//   StartStop get wednesday => hours[2];
//   StartStop get thursday => hours[3];
//   StartStop get friday => hours[4];
//   StartStop get saturday => hours[5];
//   StartStop get sunday => hours[6];
//
//   StartStop getTodayStartStop() {
//     DateTime now = DateTime.now();
//     int weekday = now.weekday;
//     return hours[weekday - 1];
//   }
//
//   String getDay() {
//     DateTime now = DateTime.now();
//     int weekday = now.weekday;
//     switch (weekday) {
//       case 1:
//         return 'Monday';
//       case 2:
//         return 'Tuesday';
//       case 3:
//         return 'Wednesday';
//       case 4:
//         return 'Thursday';
//       case 5:
//         return 'Friday';
//       case 6:
//         return 'Saturday';
//       case 7:
//         return 'Sunday';
//       default:
//         return 'Error';
//     }
//   }
// }
