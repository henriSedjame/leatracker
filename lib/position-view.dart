import 'package:flutter/material.dart';
import 'package:leatracker/models/position.dart';

class PositionView extends StatefulWidget {
  final LeaPosition position;
  const PositionView({Key? key, required this.position}) : super(key: key);

  @override
  State<PositionView> createState() => _PositionViewState();
}

class _PositionViewState extends State<PositionView> {
  @override
  Widget build(BuildContext context) {
    var e = widget.position;
    return FutureBuilder<String>(
      future: e.address(),
      builder: (ctx, fsnap) {
        if (fsnap.hasData) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              color: Colors.white.withOpacity(0.7),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.deepPurpleAccent,
                        ),
                        const SizedBox(width: 10,),
                        Text(e.date()),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.place,
                          color: Colors.deepPurpleAccent,
                        ),
                        const SizedBox(width: 10,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 45,
                          child: Text(fsnap.data ?? "",
                            maxLines: 4,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Text("No address found");
        }
      },
    );
  }
}
