import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StoriesCircle extends StatelessWidget {
  final String childAvatar;
  final bool childStatus, childStories;

  const StoriesCircle(
      {super.key,
      required this.childAvatar,
      required this.childStatus,
      required this.childStories});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: childStories
              ? BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                )
              : const BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(childAvatar),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 42,
          child: Container(
            width: 18,
            height: 18,
            decoration: childStatus
                ? BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 3,
                      color: Colors.white,
                    ),
                  )
                : const BoxDecoration(),
          ),
        ),
      ],
    );
  }
}
