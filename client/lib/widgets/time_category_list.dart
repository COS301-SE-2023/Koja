import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class TimeCategory extends StatelessWidget {
  final String Category;
  final StartTime;
  final EndTime;

  TimeCategory(this.Category, this.StartTime, this.EndTime, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          // height: 300,
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          Category.toUpperCase(),
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
                        StartTime,
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
                        EndTime,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ])
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MaterialButton(
                      minWidth: 10,
                      onPressed: () {},
                      child: Icon(
                        Icons.add,
                      ),
                      padding: EdgeInsets.zero, // Remove button padding
                      visualDensity: VisualDensity.compact,
                    ),
                    SizedBox(width: 12),
                    MaterialButton(
                      minWidth: 10,
                      onPressed: () {},
                      child: Icon(
                        Icons.delete,
                      ),
                      padding: EdgeInsets.zero, // Remove button padding
                      visualDensity:
                          VisualDensity.compact, // Reduce button spacing
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
