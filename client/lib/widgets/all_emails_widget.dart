import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../providers/context_provider.dart';

class AllEmailsWidget extends StatelessWidget {
  final String emailAddress;
  final Function(BuildContext)? delete;

  AllEmailsWidget(this.emailAddress, this.delete, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.91,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Bootstrap.envelope_at,
                  size: 25,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    emailAddress,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                  ),
                ),
                if(Provider.of<ContextProvider>(context, listen: true).userEmails.length > 1)
                  GestureDetector(
                    onTap: () {
                      delete?.call(context); 
                    },
                    child: Icon(
                      Bootstrap.trash3,
                      size: 25,
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