import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'all_emails_widget.dart';

class EmailList extends StatefulWidget {
  const EmailList({Key? key}) : super(key: key);

  @override
  State<EmailList> createState() => _EmailListState();
}

class _EmailListState extends State<EmailList> {
  List<String> emails = ["trial@gmail.com"];

  int editedindex = -1;

  late String selectedOption;

  // function to delete an email from the list
  void delete(int index) {
    setState(() {
      emails.removeAt(index);
    });
  }

  // function to delete an email from the list
  void makeprimary(int index) {
    // setState(() {
    //   emails.removeAt(index);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: ExpansionTile(
      trailing: Icon(
        Icons.arrow_drop_down,
      ),
      title: Text("Email Address(es)",
          style: GoogleFonts.ubuntu(
            fontSize: 17,
          )),
      subtitle: Text(
        "\nClick here to view all the email addresses you have added. You can manage them by just swiping to the left to make an email primary or delete it",
        style: GoogleFonts.ubuntu(
          fontSize: 12.5,
        ),
      ),
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: emails.length,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AllEmailsWidget(
                  emails[index][0],
                  (context) => delete(index),
                  (context) => makeprimary(index),
                ),
              ),
            );
          },
        ),
      ],
    ));
  }
}
