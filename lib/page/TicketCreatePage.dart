import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:worldskill_module1/model/ticket.dart';
import 'package:worldskill_module1/services/ApiService.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({super.key});

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  List<String> typelist = [
    'Opening Ceremony Tickets',
    'Closing Ceremony Tickets'
  ];
  String selectType = '';
  TextEditingController nameController = TextEditingController();

  File? image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectType = typelist[0];
    setState(() {});
  }

  Future<void> pickImage() async {
    ImagePicker ip = ImagePicker();
    var temp = await ip.pickImage(source: ImageSource.gallery);
    if (temp != null) {
      image = File(temp.path);
      setState(() {});
    }
  }

  Future<void> createTicket() async {
    String type = selectType;
    String name = nameController.text;

    if (name.isEmpty || image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('You need to fill all data')));
      return;
    }
    //Ticket t = Ticket(id: id, created_at: created_at, updated_at: updated_at, type: type, seat: seat, name: name, image: image)
    var ticket = await ApiService.storeTicket(type, name, image!);
    if (ticket == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error')));
      return;
    }
    Navigator.pop(context, ticket);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Center(
          child: Text('Ticket Create'),
        )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 90),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Center(
              child: DropdownButton(
                // Initial Value
                value: selectType,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: typelist.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectType = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: nameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(hintText: 'Input your name'),
            ),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
              onPressed: pickImage,
              child: Text(
                'Choose one picture',
                style: TextStyle(color: Colors.black),
              ),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12), // Change the radius here
                ),
                side: BorderSide(
                    color: Colors.black), // Optional: Customize border color
                padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12), // Optional: Customize padding
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                height: 200,
                width: 300,
                child: image != null ? Image.file(image!) : SizedBox()),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: OutlinedButton(
                  onPressed: createTicket,
                  child: Text(
                    'Create',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.black),
                    padding: EdgeInsets.symmetric(horizontal: 75, vertical: 12),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ]),
        ));
  }
}
