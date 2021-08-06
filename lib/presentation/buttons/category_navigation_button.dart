import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';

class CategoryNavigationButton extends StatefulWidget {
  final String category;
  final String imagePath;
  final IconData icon;

  CategoryNavigationButton({@required this.category, @required this.imagePath, @required this.icon});
  @override
  _CategoryNavigationButtonState createState() => _CategoryNavigationButtonState();
}

class _CategoryNavigationButtonState extends State<CategoryNavigationButton> {
  Image maristArtImage;

  @override
  void initState() {
    super.initState();
    maristArtImage = Image.asset(this.widget.imagePath);
  }// initState

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(maristArtImage.image, context);
  }// didChangeDependencies

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<CategoryPageCubit>(context).setCategory(widget.category);
        BlocProvider.of<HomePageViewCubit>(context).animateToCategoryPage();
      },
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: maristArtImage.image,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Color.fromRGBO(31, 31, 31, .2), BlendMode.darken),
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(flex: 5, child: SizedBox()),
              Container(
                alignment: Alignment.centerLeft,
                child: Icon(widget.icon, color: Colors.white),
              ),
              Expanded(flex: 3, child: SizedBox()),
              Center(
                child: Container(
                  child: Text(
                    widget.category,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                      fontSize: 14.0
                    ),
                  ),
                ),
              ),
              Expanded(flex: 30, child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  } } // CategoryNavigationItem
