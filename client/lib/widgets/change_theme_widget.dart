// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';
// import '../../providers/Theme_provider.dart';

// class ChangeTheme extends StatelessWidget {
//   const ChangeTheme({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return Switch.adaptive(
//       value: themeProvider.isDarkMode,
//       onChanged: (value) {
//         final provider = Provider.of<ThemeProvider>(context, listen: false);
//         provider.toggleTheme(value);
//       },
//     );
//   }
// }