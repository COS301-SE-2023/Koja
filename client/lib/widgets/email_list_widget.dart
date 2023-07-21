import 'package:client/providers/context_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/service_provider.dart';
import '../screens/login_screen.dart';
import 'all_emails_widget.dart';

class EmailList extends StatefulWidget {
  const EmailList({Key? key}) : super(key: key);

  @override
  State<EmailList> createState() => _EmailListState();
}

class _EmailListState extends State<EmailList> {

  List<String> emails = [];

  @override
  void initState() {
    super.initState();
    emails = Provider.of<ContextProvider>(context, listen: false).userEmails;
  }

  int editedindex = -1;

  late String selectedOption;

  // function to delete an email from the list
  void delete(int index) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmation'),
        content: Text('Are you sure you want to delete this email from your account?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {  
                Provider.of<ServiceProvider>(context, listen: false).deleteUserEmail(emails[index]);
                emails.removeAt(index);
                Provider.of<ContextProvider>(context, listen: false).userEmails = emails;
                if (emails.isEmpty) {
                  Provider.of<ServiceProvider>(context, listen: false)
                      .deleteUserAccount();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Login()),
                    (Route<dynamic> route) => false,
                  );
                }
              });
              Navigator.pop(context); 
            },
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
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
        "\nClick here to view all the email addresses you have added. You can delete an email by just clicking on the delete icon.",
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
                  emails[index],
                  (context) => delete(index),
                ),
              ),
            );
          },
        ),
      ],
    ));
  }
}
