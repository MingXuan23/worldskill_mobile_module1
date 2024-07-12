import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:worldskill_module1/widget/dot.dart';

class ThumbTail extends StatefulWidget {
  const ThumbTail({super.key, required this.images, required this.index});
  final List<String> images;
  final int index;
  @override
  State<ThumbTail> createState() => _ThumbTailState();
}

class _ThumbTailState extends State<ThumbTail> {
  late int currrent_index;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currrent_index = widget.index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage:currrent_index );

    List<Widget> image = <Widget>[
      for (int i = 0; i < 3; i++)
        Image.asset(
          widget.images[i],
          fit: BoxFit.fill,
        )
    ];


    return Expanded(
      child: Stack(
        children: [
          PageView(
            children: image,
            scrollDirection: Axis.horizontal,
            controller: controller,
            onPageChanged: (num) {
              setState(() {
                currrent_index = num;
              });
            },
          ),
          Positioned(
            bottom: 10.0, // Adjust this value to change the position of the dots
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < image.length; i++)
                  Dot(color: currrent_index == i ? Colors.red : Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
