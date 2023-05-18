/*

import 'package:flutter/material.dart';

class Event extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade500,
      appBar: AppBar(
        title: Text('Event'),
        backgroundColor: Colors.deepPurple.shade300,
        centerTitle: true,
      ),
      body: Center(
        child: Text('Event Tab Content'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent.shade700,
      //deepPurpleAccent.shade700,
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color.fromARGB(255, 135, 18, 194),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Event Tab Content'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({super.key});

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {

}



// import 'package:flutter/material.dart';

// class Home extends StatefulWidget {
//   @override
//   _ExpandableListViewState createState() => _ExpandableListViewState();
// }

// class _ExpandableListViewState extends State<Home> {
//   List<String> parentItems = ['Active Times', 'Location'];
//   Map<String, List<String>> childItems = {
//     'Active Times': ['Child 1', 'Child 2'],
//     'Location': ['Child 4', 'Child 5'],
//   };

//   List<bool> isExpandedList = List<bool>.filled(3, false);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: parentItems.length,
//       itemBuilder: (context, index) {
//         final parentItem = parentItems[index];
//         final children = childItems[parentItem];

//         return ExpansionTile(
//           title: Text(parentItem),
//           initiallyExpanded: isExpandedList[index],
//           onExpansionChanged: (value) {
//             setState(() {
//               isExpandedList[index] = value;
//             });
//           },
//           children: children!.map<Widget>((childItem) {
//             return ListTile(
//               title: Text(childItem),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
// }
/*
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _ExpandableListViewState createState() => _ExpandableListViewState();
}

class _ExpandableListViewState extends State<Home> {
  String inputValue = '';
  List<String> parentItems = ['Upcoming Events', 'Suggested Events', 'Completed Events'];
  Map<String, List<Widget>> childItems = {
    'Active Times': [
      Container(
        color: Colors.deepPurple,
        padding: EdgeInsets.all(8.0),
        child: const Column(
          children: [
            Text('Child 1'),
            SizedBox(height: 10),
          ],
        ),
      ),
      Container(
        color: Colors.deepPurple,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text('Child 2'),
          ],
        ),
      ),
    ],
    'Location': [
      Container(
        color: Colors.deepPurple,
        padding: EdgeInsets.all(8.0),
        child: Text('Child 4'),
      ),
      Container(
        color: Colors.deepPurple,
        padding: EdgeInsets.all(8.0),
        child: Text('Child 5'),
      ),
    ],
    'Completed Events': [
      Container(
        color: Colors.deepPurple,
        padding: EdgeInsets.all(8.0),
        child: Text('Child 4'),
      ),
      Container(
        color: Colors.deepPurple,
        padding: EdgeInsets.all(8.0),
        child: Text('Child 5'),
      ),
    ],
  };

  List<bool> isExpandedList = List<bool>.filled(3, false);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: parentItems.length,
      itemBuilder: (context, index) {
        final parentItem = parentItems[index];
        final children = childItems[parentItem];

        return ExpansionTile(
          title: Text(parentItem),
          initiallyExpanded: isExpandedList[index],
          onExpansionChanged: (value) {
            setState(() {
              isExpandedList[index] = value;
            });
          },
          children: children!.toList(),
        );
      },
    );
  }
}
*/

*/


/*

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.purple.shade700,
                ),
                height: 30,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Get Started'),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                height: 30,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                        child: Container(
                          height: 130,
                          padding: const EdgeInsets.symmetric(
                              vertical: 30.0, horizontal: 20.0),
                          color: Colors.purple.shade700,
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Navigation()),
                                  );
                                },
                                child: Container(
                                  height: 30,
                                  width: 200,
                                  child: Row(
                                    children: [
                                      LineIcon(
                                        LineIcons.googlePlus,
                                        size: 20.0,
                                        color: Colors.red.shade700,
                                      ),
                                      SizedBox(width: 10.0),
                                      Text('Sign In With Google'),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              ElevatedButton(
                                onPressed: () {},
                                child: Container(
                                  height: 30,
                                  width: 200,
                                  child: Row(
                                    children: [
                                      LineIcon(
                                        LineIcons.mailBulk,
                                        size: 20.0,
                                        color: Colors.red.shade700,
                                      ),
                                      SizedBox(width: 10.0),
                                      Text('Sign In With Email'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        );
                      },
                    );
                  },
                  child: Text('Sign In'),
                ),
              ),
            ],
          ),
  






*/