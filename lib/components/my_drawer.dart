import 'package:flutter/material.dart';
import 'package:music_player/pages/home_page.dart';
import 'package:music_player/pages/settings_page.dart';
class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          //logo
          DrawerHeader(child: Center(
            child: Icon(
              Icons.music_note,
              size: 40,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          )),
          //home title
          Padding(
            padding:  EdgeInsets.only(left: 25, top: 25),
            child: ListTile(
              title: Text("H O M E"),
              leading: Icon(Icons.home),
              onTap: (){
                //pop the drawer
                Navigator.pop(context);
                // navigate to home page
                Navigator.push(context,
                    MaterialPageRoute(
                    builder: (context)=> HomePage(),
                ));

              },
            ),
          ),
          //setting title
          Padding(
            padding:  EdgeInsets.only(left: 25, top: 25),
            child: ListTile(
              title: Text("S E T T I N G S"),
              leading: Icon(Icons.settings),
              onTap: (){
                //pop the drawer
                Navigator.pop(context);
                // navigate to settings page
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context)=> SettingsPage(),
                ));

              },
            ),
          )
        ],

      ),
    );


  }
}
