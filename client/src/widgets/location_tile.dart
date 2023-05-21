
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile({
    required Key key,
    required this.press,
    required this.location
    // super(key: key);
  }) : super(key: key);

  final Function press;
  final String location;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: press(),
          leading: const Icon(LineIcons.mapMarker),
          title: Text(location,
          maxLines: 2,
          overflow: TextOverflow.ellipsis
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1,
          height: 4,
        ),
      ],
    );
  }
}

