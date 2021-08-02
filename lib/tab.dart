import 'package:flutter/material.dart';
import 'package:flutter_api_test/chat.dart';
import 'package:flutter_api_test/grid_photo.dart';
import 'package:flutter_riverpod/all.dart';

final selectIndexProvider = StateProvider((ref) => 0);

final Grids = [
  GridPhoto(),
  Chat(),
];

class TabView extends ConsumerWidget {
  @override
  Widget build(BuildContext context,
      T Function<T>(ProviderBase<Object, T> provider) watch) {
    final selectIndex = watch(selectIndexProvider).state;
    void indexCounter(int index) {
      context.read(selectIndexProvider).state = index;
    }

    return Scaffold(
      body: Grids[selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album_outlined),
            label: "Grid1",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Chats",
          ),
        ],
        currentIndex: selectIndex,
        onTap: indexCounter,
      ),
      // List<Widget> userGrids = [userGrid(0), userGrid(1), userGrid(2)];
      //     return userGrids[selectIndex];
    );
  }
}
