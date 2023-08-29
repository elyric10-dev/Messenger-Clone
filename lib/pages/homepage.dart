// ignore_for_file: unused_import, prefer_const_constructors

// import 'package:ely_ai_messenger/DatabaseManager/crudExample.dart';
import 'package:ely_ai_messenger/DatabaseManager/crudOperations/create.dart';
import 'package:ely_ai_messenger/DatabaseManager/crudOperations/read.dart';
import 'package:ely_ai_messenger/components/navigation/navigationItems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ely_ai_messenger/pages/messengerChats.dart';
import 'package:ely_ai_messenger/pages/messengerCalls.dart';
import 'package:ely_ai_messenger/pages/messengerPeople/messengerPeople.dart';
import 'package:ely_ai_messenger/pages/messengerStories.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final ValueNotifier<int> pageIndex = ValueNotifier(0);

  final pages = [
    MessengerChatsPage(),
    MessengerCallsPage(),
    MessengerPeoplePage(),
    MessengerStoriesPage(),
    // CreatePage(),
    ReadPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: pageIndex,
          builder: (BuildContext content, int value, _) {
            return pages[value];
          },
        ),
        bottomNavigationBar: _BottomNavigationBar(onItemSelected: (index) {
          pageIndex.value = index;
        }),
      ),
    );
  }
}

class _BottomNavigationBar extends StatefulWidget {
  const _BottomNavigationBar({
    super.key,
    required this.onItemSelected,
  });

  final ValueChanged<int> onItemSelected;

  @override
  State<_BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<_BottomNavigationBar> {
  var selectedIndex = 0;
  void handleItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        NavigationBarItem(
          icon: CupertinoIcons.chat_bubble_fill,
          label: "Chats",
          index: 0,
          onTap: handleItemSelected,
          isSelected: (selectedIndex == 0),
        ),
        NavigationBarItem(
          icon: Icons.video_camera_back,
          label: "Calls",
          index: 1,
          onTap: handleItemSelected,
          isSelected: (selectedIndex == 1),
        ),
        NavigationBarItem(
          icon: CupertinoIcons.person_2_fill,
          label: "People",
          index: 2,
          onTap: handleItemSelected,
          isSelected: (selectedIndex == 2),
        ),
        NavigationBarItem(
          icon: CupertinoIcons.rectangle_fill_on_rectangle_fill,
          label: "Stories",
          index: 3,
          onTap: handleItemSelected,
          isSelected: (selectedIndex == 3),
        ),
        NavigationBarItem(
          icon: CupertinoIcons.check_mark_circled_solid,
          label: "Testing",
          index: 4,
          onTap: handleItemSelected,
          isSelected: (selectedIndex == 4),
        ),
      ],
    );
  }
}
