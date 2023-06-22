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
  late TextEditingController _start = TextEditingController();
  late TextEditingController _end = TextEditingController();

  // list of categories
  List categories = [];

  // index of list item which is being edited so that we can delete the current item and add the edited item
  int editedindex = -1;

  // selected option for dropdown
  late String selectedOption;

  // list of options for dropdown
  List<String> dropdownOptions = [
    'School',
    'Work',
    'Hobbies',
    'Resting',
    'Chores',
  ];

  // function to save time
  void saveTime() {

    if(_start.text == '') {
        _start = TextEditingController(
            text: '${DateTime.now().hour}:${DateTime.now().minute}');
    }
    if(_end.text == '') {
      _end = TextEditingController(
          text: '${DateTime.now().hour}:${DateTime.now().minute}');
    }

    setState(() {
      categories.add([selectedOption, _start.text, _end.text]);
    });

    //if editing an item, remove the current item from the list and add the edited item
    if (editedindex != -1) {
      categories.removeAt(editedindex);
      editedindex = 0;
    }
  }

  // function to delete an item from the list
  void delete(int index) {
    setState(() {
      categories.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    selectedOption = dropdownOptions[0];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionTile(
        trailing: Icon(
          Icons.arrow_drop_down,
        ),
        title: Text("Times Boundaries ",
        style: GoogleFonts.ubuntu(
          fontSize: 17,
        )),
        subtitle: Text(
          "Click here to add time boundaries for each category, select category and then click +\n\nAfter adding time boundary for a category, you can swipe to the left to edit or delete a boundary.",
          style: GoogleFonts.ubuntu(
            fontSize: 12.5,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(" Category:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )
                ),
                SizedBox(width: 8),
                Container(
                  height: 35,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    padding: EdgeInsets.all(5),
                    underline: Container(
                      height: 0,
                    ),
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
                SizedBox(width: 2),
                IconButton(
                  icon: Icon(Icons.add),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SetBoundary(
                          selectedOption, _start, _end, saveTime);
                      }
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 83,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TimeCategory(categories[index][0],
                      categories[index][1], categories[index][2], (context) {
                    delete(index);
                  }, (context) {
                    editedindex = index;
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SetBoundary(
                          categories[index][0], _start, _end, saveTime
                        );
                      }
                    );
                  }),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
