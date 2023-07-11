import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:icons_plus/icons_plus.dart';

class AllEmailsWidget extends StatelessWidget {
  final String emailadress;
  final Function(BuildContext)? delete;
  final Function(BuildContext)? edit;

  AllEmailsWidget(this.emailadress, this.delete, this.edit, {super.key});
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
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.email_outlined,
                    size: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    emailadress,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
