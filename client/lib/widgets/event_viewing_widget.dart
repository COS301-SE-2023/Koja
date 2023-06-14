import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utils/event_util.dart';

import 'event_editing_widget.dart';
import 'event_provider.dart';

class EventViewing extends StatefulWidget {
  final Event userEvent;
  const EventViewing({Key? key, required this.userEvent}) : super(key: key);

  @override
  _EventViewingState createState() => _EventViewingState();
}

class _EventViewingState extends State<EventViewing> {
  late Event userEvent;

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
                  builder: (context) => EventEditing(userEvent: userEvent),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<EventProvider>(context, listen: false)
                  .deleteEvent(userEvent);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: <Widget>[
          buildDateTime(userEvent),
          const SizedBox(height: 12.0),
          buildDescription(),
        ],
      ),
    );
  }

  Widget buildDateTime(Event userEvent) {
    return Column(
      children: [
        buildDate(userEvent.isAllDay ? 'All-day' : 'From', userEvent.from),
        if (!userEvent.isAllDay) buildDate('To', userEvent.to),
      ],
    );
  }
  
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
          userEvent.description,
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
