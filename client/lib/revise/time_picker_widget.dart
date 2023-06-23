import 'package:flutter/material.dart';

// I don't think this is used anywhere

class TimePickerWidget extends StatefulWidget {
  const TimePickerWidget({super.key});

  @override
  TimePickerWidgetState createState() => TimePickerWidgetState();
}

class TimePickerWidgetState extends State<TimePickerWidget> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
    print('time ${_selectedTime.format(context)}');

  }

  String getStartTime() {
    return _selectedTime.format(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectTime(context),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedTime.format(context),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
///
///
///
// import 'package:flutter/material.dart';
// import 'package:icons_plus/icons_plus.dart';

// import '../Utils/constants_util.dart';
// import '../widgets/chart_widget.dart';

// class Home extends StatefulWidget {
//   static const routeName = '/home';

//   const Home({Key? key}) : super(key: key);

//   @override
//   HomeState createState() => HomeState();
// }

// class HomeState extends State<Home> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Home',
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: darkBlue,
//         actions: [
//           // ChangeTheme()
//         ],
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start, 
//         children: [
//           const SizedBox(height: 10),
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: TaskOverviewBlock(),
//           ),        
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               /*  The First Block which gives a summary of the tasks pending and total*/
//               Center(
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 0.95,
//                   height: 75,
//                   margin: const EdgeInsets.all(4.0),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const TasksBlock(),
//                 ),
//               ),
//               /*  The Second Block which gives a least busy and busiest day of the week */
//               Center(
//                 child: Container(
//                     width: MediaQuery.of(context).size.width * 0.95,
//                     height: 75,
//                     margin: const EdgeInsets.all(4.0),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const BusyDaysBlock(),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Summary(),
//           ), 
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: ChartWidget(),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TaskOverviewBlock extends StatelessWidget {
//   const TaskOverviewBlock({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return const Row(
//       children: [
//         Text(
//           'Tasks Overview',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Colors.black,
//           ),
//         ),
//       ],
//     );
//   }
// }

// /* Summary Section with pie chart */
// class Summary extends StatelessWidget {
//   const Summary({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return const Row(
//       children: [
//         Text(
//           'Summary',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Colors.black,
//           ),
//         ),
//       ],
//     );
//   }
// }

// /*  The Second Block which gives a summary of the Days with tight and flexible schedules */
// class BusyDaysBlock extends StatelessWidget {
//   const BusyDaysBlock({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width * 0.45,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       Bootstrap.activity,
//                       color: Colors.black,
//                       size: 26,
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Busiest Day",
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.black,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 1,
//                         ),
//                         Text(
//                           'Tuesday',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//       ),
//       Container(
//         width: MediaQuery.of(context).size.width * 0.45,
//         height: 100,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: const Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(
//                     Bootstrap.battery_charging,
//                     color: Colors.black,
//                     size: 26,
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Least Busy Day",
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.black,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 1,
//                       ),
//                       Text(
//                         'Sunday',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     ],
//     );
//   }
// }

// /*  The First Block which gives a summary of the tasks pending and total*/
// class TasksBlock extends StatelessWidget {
//   const TasksBlock({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width * 0.45,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.pending_actions,
//                       color: Colors.black,
//                       size: 26,
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Today's Tasks",
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.black,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 1,
//                         ),
//                         Text(
//                           '5',
//                           style: TextStyle(
//                             fontSize: 19,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(4.0),
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.45,
//             height: 100,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       Bootstrap.calendar4_range,
//                       color: Colors.black,
//                       size: 26,
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "This Week's Tasks",
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.black,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 1,
//                         ),
//                         Text(
//                           '35',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }