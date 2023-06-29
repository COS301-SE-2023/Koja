import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utils/event_util.dart';

<<<<<<< HEAD
import 'event_editing_widget.dart';
import 'event_provider.dart';
=======
import '../providers/event_provider.dart';
import 'event_editing_widget.dart';
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9

class EventViewing extends StatefulWidget {
  final Event event;
  const EventViewing({Key? key, required this.event}) : super(key: key);

  @override
<<<<<<< HEAD
  _EventViewingState createState() => _EventViewingState();
}

class _EventViewingState extends State<EventViewing> {
=======
  EventViewingState createState() => EventViewingState();
}

class EventViewingState extends State<EventViewing> {
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
  late Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event'),
        centerTitle: true,
        leading: const CloseButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventEditing(event: event),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<EventProvider>(context, listen: false)
                  .deleteEvent(event);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: <Widget>[
          buildDateTime(event),
          const SizedBox(height: 12.0),
          buildDescription(),
        ],
      ),
    );
  }

  Widget buildDateTime(Event event) {
    return Column(
      children: [
        buildDate(event.isAllDay ? 'All-day' : 'From', event.from),
        if (!event.isAllDay) buildDate('To', event.to),
      ],
    );
  }
<<<<<<< HEAD
  
=======

>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
  Widget buildDate(String s, DateTime to) {
    return Row(
      children: [
        Text(
          s,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          '${to.day}/${to.month}/${to.year} ${to.hour}:${to.minute}',
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
<<<<<<< HEAD
  
=======

>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
  Widget buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12.0),
        const Text(
          'Description',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          event.description,
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
