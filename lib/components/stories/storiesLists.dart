import 'package:ely_ai_messenger/components/stories/storiesCircle.dart';
import 'package:flutter/material.dart';

class StoriesLists extends StatelessWidget {
  final String childName, childLastname, childAvatar;
  final bool childStatus, childStories;
  final int statusNumber;

  StoriesLists({
    required this.childName,
    required this.childLastname,
    required this.childAvatar,
    required this.childStatus,
    required this.childStories,
    required this.statusNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: statusNumber == 0
            ? [
                const StoriesCircle(
                  childAvatar:
                      'https://raw.githubusercontent.com/elyric10-dev/Files/main/smiley.png',
                  childStatus: false,
                  childStories: false,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "Set\nStatus",
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ]
            : [
                Container(),
                StoriesCircle(
                  childAvatar: childAvatar,
                  childStatus: childStatus,
                  childStories: childStories,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "$childName\n$childLastname",
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
      ),
    );
  }
}
