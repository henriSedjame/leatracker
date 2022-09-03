
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:leatracker/tracked-view.dart';
import 'package:leatracker/tracker-view.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  final bool tracked;
  const Home({Key? key, required this.tracked}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.tracked ? const TrackedView() : const TrackerView();
  }
}