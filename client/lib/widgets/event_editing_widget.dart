import 'package:client/Utils/constants_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utils/date_and_time_util.dart';
import '../Utils/event_util.dart';
import '../models/autocomplete_predict_model.dart';
import '../models/location_predict_widget.dart';
import '../models/place_auto_response_model.dart';
import '../providers/event_provider.dart';

class EventEditing extends StatefulWidget {
  final Event? event;

  const EventEditing({Key? key, this.event}) : super(key: key);

  @override
  _EventEditingState createState() => _EventEditingState();
}

class _EventEditingState extends State<EventEditing> {
  List<AutocompletePrediction> Eventplacepredictions = [];
  final TextEditingController _Eventplace = TextEditingController();

  Future<void> eventplaceAutocomplete(String query) async {
    Uri uri = Uri.https("maps.googleapis.com",
        'maps/api/place/autocomplete/json', {"input": query, "key": apiKey});

    String? response = await LocationPredict.fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parsePlaceAutocompleteResponse(response);
      if (result.predictions != null) {
        setState(() {
          Eventplacepredictions =
              result.predictions!.cast<AutocompletePrediction>();
        });
      }
    }
  }

  late DateTime fromDate;
  late DateTime toDate;

  //key which is used to validate the form
  final _formKey = GlobalKey<FormState>();

  //controller for the title text field
  final titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
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
    return AlertDialog(
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: const ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(Colors.black),
            ),
            child: 
              Text('Cancel')
        ),
        TextButton(
          onPressed: saveForm,
          style: const ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(Colors.black),
          ),
          child: 
            Text('Save',
              style: TextStyle(
                fontFamily: 'Railway', 
                color: Colors.black
              )
            )
          ),
      ],
      backgroundColor: Colors.grey[100],
      contentPadding: const EdgeInsets.all(16),
      content: Form(
        key: _formKey,
        child: ListView(
          children: [
            buildTitle(),
            const SizedBox(height: 12),
            buildDateTimePickers(),
            const SizedBox(height: 12),
            location(),
            const SizedBox(height: 12),
            deleteEventButton()
          ],
        )
      ),
    );
  }

  Widget deleteEventButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (widget.event != null) {
            Provider.of<EventProvider>(context, listen: false)
                .deleteEvent(widget.event!);
            Navigator.of(context).pop();
          }
        },
        child: const Text('Delete Event'),
      ),
    );
  }

  Widget location() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView( // Add SingleChildScrollView here
          child: Column(
            children: [
              TextField(
                onChanged: onLocationChanged,
                cursorColor: Colors.white,
                controller: _Eventplace,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: const OutlineInputBorder(),
                  hintText: "Meeting's Location",
                  hintStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    onPressed: clearLocation,
                    icon: const Icon(Icons.clear, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 1),
              ListView.builder(
                shrinkWrap: true,
                itemCount: Eventplacepredictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      Eventplacepredictions[index].description!,
                      textAlign: TextAlign.start,
                      style: const TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      selectLocation(Eventplacepredictions[index].description!);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

  }

  void onLocationChanged(String value) {
    if (value.length > 2) {
      eventplaceAutocomplete(value);
    } else {
      setState(() {
        eventplaceAutocomplete("");
      });
    }
  }

  void clearLocation() {
    _Eventplace.clear();
    setState(() {
      eventplaceAutocomplete("");
    });
  }

  void selectLocation(String location) {
    setState(() {
      _Eventplace.text = location;
      eventplaceAutocomplete("");
    });
    // Send the selected location (placeId) to the backend
    // meetinglocation(Eventplacepredictions[index].placeId!);
  }


  Widget buildTitle() 
  {
    return TextFormField(
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
  }

  Widget buildDateTimePickers() => Column(
        children: [
          buildFrom(),
          const SizedBox(height: 12),
          buildTo(),
        ],
      );

  Widget buildFrom()
  {
    return buildHeader(
      header: 'FROM',
      child: Row(
        children: [
          Expanded(
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
                onClicked: () => pickFromDateTime(pickDate: false)),
          ),
        ],
      ),
    );
  }

  Widget buildTo() => buildHeader(
    header: 'TO',
    child: Row(
      children: [
        Expanded(
          child: buildDropdownField(
              text: DateAndTimeUtil.toDate(toDate),
              onClicked: () => pickToDateTime(pickDate: true)),
        ),
        Expanded(
          child: buildDropdownField(
              text: DateAndTimeUtil.toTime(toDate),
              onClicked: () => pickToDateTime(pickDate: false)),
        ),
      ],
    ),
  );

  Widget buildDropdownField({ required String text,required VoidCallback onClicked,}) 
  {
    return ListTile(
      title: Text(text),
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: onClicked,
    );

  }
      

  Widget buildHeader({required String header,required Widget child}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black),
        ),
        child,
      ],
    );
  }
  

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      fromDate,
      pickDate: pickDate,
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

  Future<DateTime?> pickDateTime(DateTime initialDate, {required bool pickDate,DateTime? firstDate}) async 
  {
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
    } else {
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

  Future saveForm() async 
  {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
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

      if (isEditing) {
        provider.editEvent(event, widget.event!);
        Navigator.of(context).pop();
      } else {
        provider.addEvent(event);
        Navigator.of(context).pop();
      }
    }
  }

  }

  // void meetinglocation(String id) 
  // {
  //   //send to an api
  //   final backendurl = '';
  //   final data = {'placeId': id};

  //   // final response = http.post(Uri.parse(backendurl), body: json.encode(data));
  // }