import 'package:flutter/material.dart';
import 'package:worldskill_module1/model/event.dart';
import 'package:worldskill_module1/widget/thumbtail.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({super.key, required this.event});

  final Event event;
  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  int count = 0;

void showPic(int index) {
  var list = widget.event.image.map((e) => 'lib/assets/$e').toList();
  showDialog(
    context: context,
    barrierDismissible: true, // This makes the dialog dismissible when tapping outside
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // Set your desired width
          height: MediaQuery.of(context).size.width * 0.8, // Set your desired height
          child: ThumbTail(
            images: list,
            index: index,
          ),
        ),
      );
    },
  );
}


  void getCount() async {
    count = await widget.event.updateCount();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text('Event Details'),
      )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.event.title,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.black12),
          ),
          Text('View count: ' + count.toString()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < 3; i++)
                GestureDetector(
                  onTap: () =>{
                    showPic(i)
                  },
                  child: Image.asset(
                    'lib/assets/${widget.event.image[i]}',
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.height * 0.15,
                    fit: BoxFit.fill,
                  ),
                )
            ],
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(color: Colors.black12),
                child: Text(
                  widget.event.desc +
                      'asdasd asdasd adadasda dasda adasdad adadad adasdasd',
                ),
              )),
        ],
      ),
    );
  }
}
