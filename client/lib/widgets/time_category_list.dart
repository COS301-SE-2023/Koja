import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../Utils/constants_util.dart';

class TimeCategory extends StatefulWidget {
  final String category;
  final String startTime;
  final String endTime;
  final Function(BuildContext)? delete;
  final Function(BuildContext)? edit;

  TimeCategory(
      this.category, this.startTime, this.endTime, this.delete, this.edit,
      {Key? key});

  @override
  State<TimeCategory> createState() => _TimeCategoryState();
}

class _TimeCategoryState extends State<TimeCategory> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            if(widget.category != 'Bed-Time')
              SlidableAction(
                onPressed: (context) => widget.delete!(context),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete_outline_rounded,
              ),
            SlidableAction(
              onPressed: (context) => {
                widget.edit!(context),
                isEditing = true,
              },
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: LineAwesome.edit,
            ),
          ],
        ),
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.91,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    widget.category == 'School'
                    ? Bootstrap.journals
                    : widget.category == 'Work'
                    ? LineAwesome.suitcase_rolling_solid
                    : widget.category == 'Hobbies'
                    ? Icons.self_improvement_outlined
                    : widget.category == 'Bed-Time'
                    ? Icons.king_bed_outlined
                    : widget.category == 'Chores'
                    ? Icons.help
                    : widget.category == 'Resting'
                    ? Icons.hotel_outlined
                    : Icons.help,
                    size: 23,
                  ),
                  SizedBox(width: 7),
                  Text(
                    widget.category.toUpperCase(),
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
                  Bootstrap.alarm,
                  size: 18,
                ),
                SizedBox(width: 5),
                Text(
                  widget.startTime,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Bootstrap.alarm,
                  size: 18,
                ),
                SizedBox(width: 5),
                Text(
                  widget.endTime,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}