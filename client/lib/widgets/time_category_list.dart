import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TimeCategory extends StatelessWidget {
  final String category;
  final startTime;
  final endTime;
  Function(BuildContext)? delete;
  Function(BuildContext)? edit;

  TimeCategory(this.category, this.startTime, this.endTime,this.delete,this.edit, {super.key});

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
              label: 'Delete',
              borderRadius: BorderRadius.circular(20),
            ),
            SlidableAction(
              onPressed: (context) => edit!(context),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(20),
            ),
          ],
        ),
        child: Container(
          // height: 500,
          width: MediaQuery.of(context).size.width * 0.91,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(224, 224, 224, 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // width: MediaQuery.of(context).size.width * 0.5,
                // height: 400,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(children: [
                      MaterialButton(
                        minWidth: 10,
                        onPressed: () {},
                        child: Icon(
                          Icons.school,
                        ),
                      ),
                      Text(
                        startTime,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      // Text(
                      //   " Until: ",
                      //   style: TextStyle(
                      //     fontSize: 15,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      Text(
                        endTime,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ])
                  ],
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
