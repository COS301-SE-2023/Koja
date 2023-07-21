import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../providers/event_provider.dart';
import '../providers/service_provider.dart';

class AddEmailModal extends StatefulWidget {
  const AddEmailModal({Key? key}) : super(key: key);

  @override
  State<AddEmailModal> createState() => _AddEmailModalState();
}

class _AddEmailModalState extends State<AddEmailModal> {
  @override
  Widget build(BuildContext context) {
    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Container(
        height: 130,
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            ElevatedButton(
              onPressed: () async {
                if (await serviceProvider.addEmail(
                    eventProvider: eventProvider)) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email was added'),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email was not added'),
                    ),
                  );
                }
              },
              child: const SizedBox(
                height: 30,
                width: 200,
                child: Row(
                  children: [
                    Icon(
                      Bootstrap.google,
                      size: 16.0,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10.0),
                    Text('Sign In With Google',
                        style:
                          TextStyle(color: Colors.white, fontSize: 16.0)),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              )),
              SizedBox(height: 10.0), 
          ],
        ),
      ),
    );
  }
}