import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utils/date_and_time_util.dart';
import '../Utils/event_util.dart';
import 'event_provider.dart';

class EventEditing extends StatefulWidget {
  final Event? event;

  const EventEditing({Key? key, this.event}) : super(key: key);
  
  @override
  _EventEditingState createState() => _EventEditingState();
}

class _EventEditingState extends State<EventEditing> {

  late DateTime fromDate;
  late DateTime toDate;
  
  //key which is used to validate the form
  var _formKey = GlobalKey<FormState>();

  //controller for the title text field
  final titleController = TextEditingController();
 

  @override
  void initState() {
    super.initState();

    if(widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(const Duration(hours: 2));
    } else {
      final event = widget.event!;

      titleController.text = event.title;
      fromDate = event.from;
      toDate = event.to;
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
            child: const Text('Save'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
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
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildTitle(),
              SizedBox(height: 12,),
              buildDateTimePickers(),
            ]),
        ),
      ),   
    );
  }
  
  Widget buildTitle() => TextFormField(
    style: TextStyle(fontSize: 24),
    decoration: InputDecoration(
      border: UnderlineInputBorder(),
      hintText: 'Add Title',
    ),
    onFieldSubmitted: (_) { saveForm(); },
    controller: titleController,
    validator: (title) =>
        title != null && title.isEmpty ? 'Title cannot be empty' : null,
  );
  
  Widget buildDateTimePickers() => Column(
    children: [
      buildFrom(),
      buildTo(),
    ],
  );
  
  Widget buildFrom() => BuildHeader(
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
  
  Widget buildTo() => BuildHeader(
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
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );
      
  Widget BuildHeader({
  required String header,
  required Widget child,
  }) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
      final event = Event(
        title: titleController.text,
        location: '',
        description: 'description',
        from: fromDate,
        to: toDate,
        isAllDay: false,
      );

      

      final isEditing = widget.event != null;
      final provider = Provider.of<EventProvider>(context, listen: false);
      
      if(isEditing){
        provider.editEvent(event, widget.event!);
        Navigator.of(context).pop();
      }
      else{
        provider.addEvent(event);
        Navigator.of(context).pop();
    }
  }
}
}