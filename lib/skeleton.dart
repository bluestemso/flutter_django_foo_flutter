import 'package:flutter/material.dart';
import 'pages/get_page.dart';
import 'pages/post_page.dart';

class Skeleton extends StatefulWidget {
  const Skeleton({super.key});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  int currentIndex = 0;
  List pages = [
    GetPage(),
    const PostPage(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Get",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Post",
          ),
        ],
      ),
    );
  }
}
