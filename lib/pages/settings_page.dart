import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('S E T T I N G S'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Container(

        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //dark mode
            Text('Dark Mode', style: TextStyle(fontWeight:FontWeight.bold),)
            ,
            //switch
            CupertinoSwitch(value:
                Provider.of<ThemeProvider>(context,listen:false).isDarkMode,
                onChanged: (value)=>
            Provider.of<ThemeProvider>(context,listen: false).toggleTheme()
            )
          ],
        )
      ),
    );
  }
}
