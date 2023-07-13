import 'package:flutter/material.dart';

class AllEmailsWidget extends StatelessWidget {
  final String emailadress;
  final Function(BuildContext)? delete;

  AllEmailsWidget(this.emailadress, this.delete, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      emailadress,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {

                      },
                      child: Icon(
                        Icons.delete_outlined,
                        size: 30,
                      ),
                    ),
                    
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
