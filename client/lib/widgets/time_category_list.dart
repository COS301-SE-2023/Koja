import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TimeCategory extends StatelessWidget {
  final String category;
  final String startTime;
  final String endTime;
  final Function(BuildContext)? delete;
  final Function(BuildContext)? edit;

  TimeCategory(
      this.category, this.startTime, this.endTime, this.delete, this.edit,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => delete!(context),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete_outline_rounded,
              borderRadius: BorderRadius.circular(100),
            ),
            SlidableAction(
              onPressed: (context) => edit!(context),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: LineAwesome.edit,
              borderRadius: BorderRadius.circular(200),
            ),
          ],
        ),
        child: Container(
            width: MediaQuery.of(context).size.width * 0.91,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        category == 'School'
                            ? Icons.school_outlined
                            : category == 'Work'
                                ? Icons.card_travel_outlined
                                : category == 'Hobbies'
                                    ? Icons.self_improvement_outlined
                                    : category == 'Resting'
                                        ? Icons.king_bed_outlined
                                        : category == 'Chores'
                                            ? Icons.help
                                            : LineAwesome.question_circle,
                        size: 30,
                      ),
                      SizedBox(width: 7),
                      Text(
                        category.toUpperCase(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(children: [
                    Icon(
                      Icons.watch_later_outlined,
                    ),
                    SizedBox(width: 5),
                    Text(
                      startTime as String,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.watch_later_outlined,
                    ),
                    SizedBox(width: 5),
                    Text(
                      endTime as String,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ])
                ],
              ),
            )),
      ),
    );
  }
}
