import 'package:flutter/material.dart';

class ChooseCategory extends StatefulWidget {
  final void Function(String category) onCategorySelected;
  const ChooseCategory({Key? key, required this.onCategorySelected})
      : super(key: key);

  @override
  ChooseCategoryState createState() => ChooseCategoryState();
}

class ChooseCategoryState extends State<ChooseCategory> {
  String selectedCategory = 'School';
  List<String> categories = ['School', 'Work', 'Hobby', 'Resting', 'Chore'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedCategory,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedCategory = newValue;
                });
                widget.onCategorySelected(newValue);
              }
            },
            items: categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),

            decoration: InputDecoration(
              label: Text(
                'Select Category',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
            )
          ),
        ],
      ),
    );
  }
}

class ChooseEventType extends StatefulWidget {
  final void Function(String category) onEventSelected;
  const ChooseEventType({Key? key, required this.onEventSelected})
      : super(key: key);

  @override
  ChooseEventTypeState createState() => ChooseEventTypeState();
}

class ChooseEventTypeState extends State<ChooseEventType> {
  String selectedCategory = 'Fixed';
  List<String> categories = ['Fixed', 'Dynamic'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [         
          DropdownButtonFormField<String>(
            value: selectedCategory,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedCategory = newValue;
                });
                widget.onEventSelected(newValue);
              }
            },
            items: categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),

            decoration: InputDecoration(
              label: Text(
                'Select Event Type',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
            )
          ),
        ],
      ),
    );
  }
}

class ChoosePriority extends StatefulWidget {
  final void Function(String category) onPrioritySelected;
  const ChoosePriority({Key? key, required this.onPrioritySelected})
      : super(key: key);

  @override
  ChoosePriorityState createState() => ChoosePriorityState();
}

class ChoosePriorityState extends State<ChoosePriority> {
  String selectedCategory = 'Low';
  List<String> categories = ['Low', 'Medium', 'High'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [         
          DropdownButtonFormField<String>(
            value: selectedCategory,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedCategory = newValue;
                });
                widget.onPrioritySelected(newValue);
              }
            },
            items: categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),

            decoration: InputDecoration(
              label: Text(
                'Select Priority Level',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
            )
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class ChooseCategory extends StatefulWidget {
//   final void Function(String category) onCategorySelected;
//   const ChooseCategory({Key? key, required this.onCategorySelected})
//       : super(key: key);

//   @override
//   ChooseCategoryState createState() => ChooseCategoryState();
// }

// class ChooseCategoryState extends State<ChooseCategory> {
//   int tag = 1;
//   List<String> categories = ['School', 'Work', 'Hobby', 'Resting', 'Chore'];

//   String get category => categories[tag];

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text("CATEGORY",
//               maxLines: 2,
//               style: TextStyle(
//                   fontFamily: 'Railway',
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold)),
//           SizedBox(height: 10),
//           Wrap(
//             spacing: 5,
//             children: [
//               ChoiceChip(
//                   label: Text(categories[0]),
//                   selected: tag == 0,
//                   onSelected: (bool selected) {
//                     setState(() {
//                       tag = selected ? 0 : 1;
//                     });
//                     widget.onCategorySelected(categories[0]);
//                   }),
//               ChoiceChip(
//                   label: Text(categories[1]),
//                   selected: tag == 1,
//                   onSelected: (bool selected) {
//                     setState(() {
//                       tag = selected ? 1 : 0;
//                     });
//                     widget.onCategorySelected(categories[1]);
//                   }),
//               ChoiceChip(
//                   label: Text(categories[2]),
//                   selected: tag == 2,
//                   onSelected: (bool selected) {
//                     setState(() {
//                       tag = selected ? 2 : 0;
//                     });
//                     widget.onCategorySelected(categories[2]);
//                   }),
//               ChoiceChip(
//                   label: Text(categories[3]),
//                   selected: tag == 3,
//                   onSelected: (bool selected) {
//                     setState(() {
//                       tag = selected ? 3 : 0;
//                     });
//                     widget.onCategorySelected(categories[3]);
//                   }),
//               ChoiceChip(
//                   label: Text(categories[4]),
//                   selected: tag == 4,
//                   onSelected: (bool selected) {
//                     setState(() {
//                       tag = selected ? 4 : 0;
//                     });
//                     widget.onCategorySelected(categories[4]);
//                   }),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

// class ChooseEventType extends StatefulWidget {
//   final void Function(String category) onEventSelected;
//   const ChooseEventType({Key? key, required this.onEventSelected})
//       : super(key: key);

//   @override
//   ChooseEventTypeState createState() => ChooseEventTypeState();
// }

// class ChooseEventTypeState extends State<ChooseEventType> {
//   int tag = 1;
//   List<String> categories = ['Fixed', 'Dynamic'];

//   String get category => categories[tag];

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text("EVENT TYPE",
//               maxLines: 2,
//               style: TextStyle(
//                   fontFamily: 'Railway',
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold)),
//           SizedBox(height: 10),
//           Center(
//             child: Wrap(
//               spacing: 5,
//               children: [
//                 for (var i = 0; i < categories.length; i++)
//                   ChoiceChip(
//                       label: Text(categories[i]),
//                       selected: tag == i,
//                       onSelected: (bool selected) {
//                         setState(() {
//                           if (selected) tag = i;
//                         });
//                         widget.onEventSelected(categories[i]);
//                       }),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }