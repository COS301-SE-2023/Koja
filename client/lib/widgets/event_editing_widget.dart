import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utils/date_and_time_util.dart';
import '../Utils/event_util.dart';
import 'event_provider.dart';

class EventEditing extends StatefulWidget {
  final Event? userEvent;

  const EventEditing({Key? key, this.userEvent}) : super(key: key);
  
  @override
  EventEditingState createState() => EventEditingState();
}

class EventEditingState extends State<EventEditing> {

  late DateTime fromDate;
  late DateTime toDate;
  
  //key which is used to validate the form
  final _formKey = GlobalKey<FormState>();

  //controller for the title text field
  final titleController = TextEditingController();
 

  @override
  void initState() {
    super.initState();

    if(widget.userEvent == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(const Duration(hours: 2));
    } else {
      final userEvent = widget.userEvent!;

      titleController.text = userEvent.title;
      fromDate = userEvent.from;
      toDate = userEvent.to;
    }
 
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: [
          ElevatedButton(
            onPressed: saveForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: const Text('Save'),
          ),
          const SizedBox(width: 12),
          
        ],
        title: const Text('Event Editing',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ), 
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildTitle(),
              const SizedBox(height: 12,),
              buildDateTimePickers(),
            ]),
        ),
      ),   
    );
  }
  
  Widget buildTitle() => TextFormField(
    style: const TextStyle(fontSize: 24),
    decoration: const InputDecoration(
      border: UnderlineInputBorder(),
      hintText: 'Add Title',
    ),
    onFieldSubmitted: (_) => saveForm(),
    
    validator: (title) =>
        title != null && title.isEmpty ? 'Title cannot be empty' : null,
    controller: titleController,
  );
  
  Widget buildDateTimePickers() => Column(
    children: [
      buildFrom(),
      buildTo(),
    ],
  );
  
  Widget buildFrom() => buildHeader(
    header: 'FROM',
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: buildDropdownField(
            text: DateAndTimeUtil.toDate(fromDate),
            //If the user clicked the date the new date is saved in the fromDate variable
            onClicked: () => pickFromDateTime(pickDate: true),
  
          ),
        ),
        Expanded(
          child: buildDropdownField(
            text: DateAndTimeUtil.toTime(fromDate),
            //If the user clicked the time the new time is saved in the fromDate variable
             onClicked: () => pickFromDateTime(pickDate: false)
            ),      
        ),
       
      ],
    ),
  );
  
  Widget buildTo() => buildHeader(
    header: 'TO',
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: buildDropdownField(
            text: DateAndTimeUtil.toDate(toDate),
            onClicked: () => pickToDateTime(pickDate: true)
  
          ),
        ),
        Expanded(
          child: buildDropdownField(
            text: DateAndTimeUtil.toTime(toDate),
             onClicked: () => pickToDateTime(pickDate: false)
            ),      
        ),
       
      ],
    ),
  );


  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );
      
  Widget buildHeader({
  required String header,
  required Widget child,
  }) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        child,
      ],
    );
      
  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate,
      firstDate: pickDate ? fromDate : null,
    );
    
    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate = DateTime(
        date.year,
        date.month,
        date.day,
        toDate.hour,
        toDate.minute,
      );
    }

    setState(() {
      fromDate = date;
    });
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(initialDate.year - 5),
        lastDate: DateTime(initialDate.year + 10),
      );

      if (date == null) return null;

      final time = Duration(
        hours: initialDate.hour,
        minutes: initialDate.minute,
      );

      return date.add(time);
    } 
    else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (timeOfDay == null) return null;

      final date = DateTime(
        initialDate.year,
        initialDate.month,
        initialDate.day,
      );

      final time = Duration(
        hours: timeOfDay.hour,
        minutes: timeOfDay.minute,
      );

      return date.add(time);
    }
  }
  
  //To Section
  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(toDate, pickDate: pickDate);
    
    if (date == null) return;

    // if (date.isAfter(toDate)) {
    //   toDate = DateTime(
    //     date.year,
    //     date.month,
    //     date.day,
    //     toDate.hour,
    //     toDate.minute,
    //   );
    // }

    setState(() {
      toDate = date;
    });
  }
        
  Future saveForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if(isValid){
      final userEvent = Event(
        title: titleController.text,
        location: '',
        description: 'description',
        from: fromDate,
        to: toDate,
        isAllDay: false,
      );

      

      final isEditing = widget.userEvent != null;
      final provider = Provider.of<EventProvider>(context, listen: false);
      
      if(isEditing){
        provider.editEvent(userEvent, widget.userEvent!);
        Navigator.of(context).pop();
      }
      else{
        provider.addEvent(userEvent);
        Navigator.of(context).pop();
    }
  }
}
}