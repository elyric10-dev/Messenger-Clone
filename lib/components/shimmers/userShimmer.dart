import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer {
  Widget userShimmer() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.white,
        child: ListTile(
          leading: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
          ),
          title: Container(
            height: 16,
            width: 120,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
