import 'package:client/Utils/event_util.dart';
import 'package:client/providers/service_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../providers/event_provider.dart';

class EventViewing extends StatefulWidget {
  late final Event event = Event(
    title: 'No events',
    description: '',
    from: DateTime.now(),
    to: DateTime.now(),
  );
  EventViewing({super.key, required Event event});

  @override
  EventViewingState createState() => EventViewingState();
}

class EventViewingState extends State<EventViewing> {
  @override
  Widget build(BuildContext context) {
    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Container(
        height: 350, 
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            if(widget.event.title != 'No events')
              Column(
                children: [
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'No Tasks Found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway'
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Lottie.asset(
                      'assets/animations/empty.json',
                      height: 200, width: 300,
                    ),
                  ),
                ],
              ),

            if(widget.event.title == 'No events')
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Bootstrap.calendar_date,
                        size: 20,
                      ),
                      const SizedBox(width: 10), 
                      Text(
                        widget.event.title,
                        style: GoogleFonts.raleway(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      IconButton(onPressed: 
                      (){}, 
                      icon: Icon(Bootstrap.pencil_square)
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // serviceProvider.deleteEvent(widget.event);
                          // eventProvider.removeEvent(widget.event);
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.event.category,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway'
                        ),
                      ),
                      Text(
                        widget.event.location,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway'
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Text(
                        widget.event.from.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway'
                        ),
                      ),
                      Text(
                        widget.event.to.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway'
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.event.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Raleway'
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
