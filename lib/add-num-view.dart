import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:leatracker/services/num.service.dart';

class AddNumView extends StatefulWidget {
  const AddNumView({Key? key}) : super(key: key);

  @override
  State<AddNumView> createState() => _AddNumViewState();
}

class _AddNumViewState extends State<AddNumView> {
  final TextEditingController _controller = TextEditingController();
  late NumService _numService;

  @override
  void initState() {
    _numService = GetIt.I<NumService>();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _numService.getNums(),
      builder: (ctx, snapshot) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "Numéros enregistrés",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
        content: snapshot.hasData ? SizedBox(
          width: MediaQuery.of(context).size.width * 2/3,
          height: MediaQuery.of(context).size.height * 2/3 ,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      prefixText: "+33 ",
                      suffixIcon: isValid(_controller.text)
                          ? const Icon(Icons.check, color: Colors.green,)
                          : const Icon(Icons.clear, color: Colors.red,),
                      labelText: "Ajouter un numéro"
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) {
                    setState(() {});
                  },
                  onFieldSubmitted: isValid(_controller.text)
                      ? (_) {
                    _numService.addNum(num()).then((added) {
                      if (added) {
                        setState(() {
                          _controller.clear();
                        });
                      }
                    });
                  }
                      : null,
                  controller: _controller,
                ),
                if(snapshot.data!.isNotEmpty) ... [
                  const SizedBox(height: 25,),
                  Column(
                    children: [
                      if(snapshot.data!.isNotEmpty) ... [
                        const SizedBox(height: 15,)
                      ],

                      if (snapshot.data!.isNotEmpty)
                        ...snapshot.data!
                            .map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Container(
                            color: Colors.deepPurpleAccent.withOpacity(0.6),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                const Icon(
                                  Icons.phone_android,
                                  color: Colors.amber,
                                ),
                                Text(e),
                                IconButton(
                                    onPressed: () async {
                                      await _numService.delete(e);
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ))
                              ],
                            ),
                          ),
                        ))
                            .toList(),

                    ],
                  ),
                ],
              ],
            ),
          ),
        ) : Container(),
      ),
    );
  }

  bool isValid(String text) {
    return text.isNotEmpty &&
        text.characters.every((element) => int.tryParse(element) != null) &&
        text.length == (text.startsWith("0") ? 10 : 9);
  }

  String num() {
    var text = _controller.text;
    if (text.startsWith("0")) {
      text = text.substring(1);
    }
    return "0033$text";
  }
}
