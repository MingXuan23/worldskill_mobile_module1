import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:worldskill_module1/model/ticket.dart';


class TicketDetailPage extends StatefulWidget {
  const TicketDetailPage({super.key, required this.ticket});
  final Ticket ticket;
  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  ScreenshotController screenshotController = ScreenshotController();

  String DateToString(DateTime date) {
    String twoDigit(int n) => n.toString().padLeft(2, '0');

    return '${date.year}-${twoDigit(date.month)}-${twoDigit(date.day)} ${twoDigit(date.hour)}:${twoDigit(date.minute)}';
  }

  @override
  void initState() {

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    //if(Permission.storage.)
    
    super.initState();
  }

  triggerNotification() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: 'Image Download',
            body: 'Your ticket was downloaded!'));
  }

Future<void> requestPermissions() async {
  if (Platform.isAndroid) {
    if (await Permission.storage.isGranted &&
        await Permission.accessMediaLocation.isGranted) {
      // Permissions are already granted
      return;
    }

    if (await Permission.storage.request().isGranted &&
        await Permission.accessMediaLocation.request().isGranted) {
      // Permissions are granted
      return;
    }

    // For Android 11 and above
    if (await Permission.manageExternalStorage.isGranted) {
      // MANAGE_EXTERNAL_STORAGE permission is granted
      return;
    }

    if (await Permission.manageExternalStorage.request().isGranted) {
      // MANAGE_EXTERNAL_STORAGE permission is granted
      return;
    }

    // If permissions are denied
    openAppSettings();
  } else {
    // For iOS, request photos permission
    if (await Permission.photos.request().isGranted) {
      // Photos permission is granted
      return;
    } else {
      // If permission is denied
      openAppSettings();
    }
  }
}
  Future<void> downloadImage() async {
    // Request permissions
    triggerNotification();
    await requestPermissions();
    
     final image = await screenshotController.capture();
      if (image != null) {
        await ImageGallerySaver.saveImage(image);
      }
    // if (status.isGranted) {
    //   // Capture screenshot
     
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Storage permission denied')),
    //   );
    // }
  }

  // Future<void> downloadImage() async {
  //   final image = await screenshotController.capture();

  //    final directory = await getExternalStorageDirectory();
  //    if(directory == null || image == null){
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Error')));
  //    }
  //     final imagePath = '${directory!.path}/ticket_${DateTime.now().millisecondsSinceEpoch}.png';
  //     final imageFile = File(imagePath);
  //     await imageFile.writeAsBytes(image!);

  //      ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Success')));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Center(
          child: Text('Ticket Details'),
        )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Screenshot(
              controller: screenshotController,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 2)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        widget.ticket.image,
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width * 0.8,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Ticket type: ' + widget.ticket.type,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text("Audience's name: " + widget.ticket.name,
                          style: TextStyle(fontSize: 16)),
                      Text('Time: ' + DateToString(widget.ticket.created_at),
                          style: TextStyle(fontSize: 16)),
                      Text('Seat: ' + widget.ticket.seat,
                          style: TextStyle(fontSize: 16)),
                    ]),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: OutlinedButton(
                  onPressed: downloadImage,
                  child: Text(
                    'Download',
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
