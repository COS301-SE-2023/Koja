import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/context_provider.dart';

class AllEmailsWidget extends StatelessWidget {
  final String emailadress;
  final Function(BuildContext)? delete;

  AllEmailsWidget(this.emailadress, this.delete, {Key? key}) : super(key: key);

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
                Expanded(
                  child: Text(
                    emailadress,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    maxLines: 1,
                  ),
                ),
                if(Provider.of<ContextProvider>(context, listen: true).userEmails.length > 1)
                  GestureDetector(
                    onTap: () {
                      delete?.call(context); // Use call method to invoke the function safely
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
      ),
    );
  }
}