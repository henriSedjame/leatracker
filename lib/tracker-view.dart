import 'package:flutter/material.dart';
import 'package:leatracker/position-view.dart';
import 'package:leatracker/services/db.service.dart';
import 'package:leatracker/models/position.dart';

class TrackerView extends StatefulWidget {
  const TrackerView({Key? key}) : super(key: key);

  @override
  State<TrackerView> createState() => _TrackerViewState();
}

class _TrackerViewState extends State<TrackerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(
            width: 250,
              child:  Image(image: AssetImage("assets/logo.png"))),
          const SizedBox(height: 25,),
          const Text("Léa est passée par : ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.purple
          ),),
          const SizedBox(height: 25,),
          StreamBuilder<List<LeaPosition>>(
              stream: DbService.watch(),
              builder: (ctx, snap) {
                if (snap.hasData) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 2 / 3,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.deepPurpleAccent,
                          Colors.transparent
                        ]
                      )
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: snap.data!
                            .map((e) => PositionView(position: e))
                            .toList(),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        ],
      ),
    );
  }
}
