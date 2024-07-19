import 'package:flutter/material.dart';
import 'package:worldskill_module1/model/photo.dart';
import 'package:worldskill_module1/services/ApiServiceM2.dart';

class Photo_Page extends StatefulWidget {
  const Photo_Page({super.key});

  @override
  State<Photo_Page> createState() => _Photo_Page_PageState();
}

class _Photo_Page_PageState extends State<Photo_Page> {
  int page = 0;
  int selectPage = 1;
  int limit = 6;
  List<Photo> images = [];

  Future<void> getPageLimit() async {
    page = await ApiM2.getPhotoPagination(limit);
    images = await ApiM2.getPhoto(limit, selectPage - 1);
    setState(() {});
  }

  void updatePage(int i) async {
    selectPage = i;
    images =[];
    setState(() {});
    images = await ApiM2.getPhoto(limit, selectPage - 1);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPageLimit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo'),
      ),
      body: Column(
        children: [
          Flexible(
            child: GridView.count(
              primary: false,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 5,
              crossAxisCount: 2,
              children: <Widget>[
                for (int i = 0; i < images.length; i++)
                  Container(
                    height: MediaQuery.of(context).size.height * 0.10,
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: Image.network(
                      images[i].link,
                      fit: BoxFit.fill,
                    ),
                  )
              ],
            ),
          ),
          Pagination_Control(
            pages: page,
            selectedPages: selectPage,
            func: updatePage,
          ),
          //SizedBox(height: 100,)
        ],
      ),
    );
  }
}

class Pagination_Control extends StatefulWidget {
  Pagination_Control(
      {super.key,
      required this.pages,
      required this.selectedPages,
      required this.func});
  final int pages;
  final int selectedPages;
  final Function func;

  @override
  State<Pagination_Control> createState() => _Pagination_ControlState();
}

class _Pagination_ControlState extends State<Pagination_Control> {
  List<int> displayPage = [];
  void initialisePage() {
    displayPage = [];
    displayPage.add(1);
    displayPage.add(widget.pages);
    displayPage.add(widget.selectedPages);

    if (widget.selectedPages == 1) {
      displayPage.add(widget.selectedPages + 1);
      displayPage.add(widget.selectedPages + 2);
    } else if (widget.selectedPages == widget.pages) {
      displayPage.add(widget.selectedPages - 1);
      displayPage.add(widget.selectedPages - 2);
    } else {
      displayPage.add(widget.selectedPages - 1);
      displayPage.add(widget.selectedPages + 1);
    }

    displayPage =
        displayPage.where((e) => e >= 1 && e <= widget.pages).toList();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialisePage();
  }

  @override
  Widget build(BuildContext context) {
    initialisePage();
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < widget.pages; i++)
            (displayPage.any((e) => e == i + 1))
                ? PageBox(
                    color: (i + 1 == widget.selectedPages)
                        ? Colors.black12
                        : Colors.white,
                    page: i + 1,
                    func: widget.func,
                  )
                : (displayPage.any((e) => e == i))
                    ? const DotBox()
                    : Container()
        ],
      ),
    );
  }
}

class PageBox extends StatelessWidget {
  const PageBox(
      {super.key, required this.color, required this.page, required this.func});
  final Color color;
  final int page;
  final Function func;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        func(page);
      },
      child: Container(
        height: 50,
        width: 50,
        color: color,
        child: Text(
          page.toString(),
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}

class DotBox extends StatelessWidget {
  const DotBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      color: Colors.white,
      child: Text(
        '...',
        style: TextStyle(fontSize: 40),
      ),
    );
  }
}
