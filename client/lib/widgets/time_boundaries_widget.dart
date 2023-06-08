import 'package:client/widgets/set_boundary_widget.dart';
import 'package:client/widgets/time_category_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeBoundaries extends StatefulWidget {
  @override
  _TimeBoundariesState createState() => _TimeBoundariesState();
}

class _TimeBoundariesState extends State<TimeBoundaries> {
  //controllers for starting time
  final TextEditingController _hobbyStart = TextEditingController(),
      _choreStart = TextEditingController(),
      _schoolStart = TextEditingController(),
      _workStart = TextEditingController(),
      _restStart = TextEditingController();

  //controllers for ending time
  final TextEditingController _hobbyEnd = TextEditingController(),
      _choreEnd = TextEditingController(),
      _schoolEnd = TextEditingController(),
      _workEnd = TextEditingController(),
      _restEnd = TextEditingController();

  //general controller for all time pickers
  final _start = TextEditingController(), _end = TextEditingController();

  // list of categories
  List categories = [];

  late String selectedOption;
  List<String> dropdownOptions = [
    'School',
    'Work',
    'Hobbies',
    'Resting',
    'Chores',
  ];

  void saveTime() {
    print("Saving time");
    print(_start.text);
    print(_end.text);
    print(selectedOption);
    setState(() {
      categories.add([selectedOption, _start.text, _end.text]);
    });
  }

  @override
  void initState() {
    super.initState();
    selectedOption = dropdownOptions[0]; 
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      trailing: Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
      title: Text("Click To Set Your Active Times ",
          style: GoogleFonts.ubuntu(
            fontSize: 15,
            // fontWeight: FontWeight.bold,
            // color: Colors.white,
          )),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Select Category:",
                  style: TextStyle(
                    fontSize: 15,
                    // fontWeight: FontWeight.bold,
                    // color: Colors.white,
                  )),
              SizedBox(width: 3),
              Expanded(
                child: Container(
                  child: DropdownButton<String>(
                    value: selectedOption,
                    onChanged: (newValue) {
                      setState(() {
                        selectedOption = newValue!;
                      });
                    },
                    items: dropdownOptions.map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
              Container(
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    print('Add button pressed!' + selectedOption);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SetBoundary(
                              selectedOption, _start, _end, saveTime);
                        });
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        // TimeCategory("selectedOption", "_start", "_end"),
        SizedBox(
          height: 400,
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Container(
                height: 90,
                child: TimeCategory(
                    categories[index][0], 
                    categories[index][1], 
                    categories[index][2]
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
