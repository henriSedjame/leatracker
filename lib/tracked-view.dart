import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:get_it/get_it.dart';
import 'package:leatracker/add-num-view.dart';
import 'package:leatracker/constants.dart';
import 'package:leatracker/services/num.service.dart';
import 'package:permission_handler/permission_handler.dart';

class TrackedView extends StatefulWidget {
  const TrackedView({Key? key}) : super(key: key);

  @override
  State<TrackedView> createState() => _TrackedViewState();
}

class _TrackedViewState extends State<TrackedView> {
  Offset okOffset = const Offset(3, 3);
  Offset koOffset = const Offset(3, 3);

  late NumService _numService;

  @override
  void initState() {
    _numService = GetIt.I<NumService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 35,
              ),
              const SizedBox(
                  width: 250, child: Image(image: AssetImage("assets/logo.png"))),
              SizedBox(
                height: MediaQuery.of(context).size.height * 2 / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Today, I feel ...",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        button(true),
                        const SizedBox(
                          width: 15,
                        ),
                        button(false)
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: add,
                  icon: const Icon(
                    Icons.phone_android,
                    color: Colors.deepPurpleAccent,
                    size: 45,
                  ))
            ],
          )),
        ));
  }

  ElevatedButton button(bool ok) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                ok ? Colors.lightGreen : Colors.redAccent),
            elevation: MaterialStateProperty.all(15),
            fixedSize: MaterialStateProperty.all(const Size(150, 100)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ))),
        onPressed: () {
          _sendSMS(ok);
        },
        child: Text(ok ? "GOOD 👍" : "BAD 👎",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)));
  }

  Future<void> _sendSMS(bool ok) async {
    List<String> numbers = await _numService.getNums();

    if (numbers.isEmpty) {
      final snackBar = SnackBar(
        elevation: 10,
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 5),
        content: const Text(
          'Aucun numéro enregistré',
          style: TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          label: 'ADD ☎️',
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            add();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    try {
      var smsPermissionStatus = await Permission.sms.status;

      if (smsPermissionStatus.isDenied) {
        smsPermissionStatus = await Permission.sms.request();
      }

      if (!smsPermissionStatus.isDenied) {
        var result = await sendSMS(
          message: ok ? okMessage : koMessage,
          recipients: numbers,
          sendDirect: true,
        );
        print(result);
      }
    } catch (error) {
      print(error);
    }
  }

  add() async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return const AddNumView();
        });
  }
}
