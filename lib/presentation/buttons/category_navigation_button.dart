import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/cubits/cubits.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';

class CategoryNavigationItem extends StatelessWidget {
  final String option;
  final String gradient;
  final IconData icon;
  final String nextPage;
  Image maristArtImage;

  CategoryNavigationItem({@required this.nextPage, @required this.gradient, this.option, this.icon}) {
    maristArtImage = Image.asset(gradient);
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(maristArtImage.image, context);
    return GestureDetector(
      onTap: () {
        BlocProvider.of<CategoryTitleCubit>(context).setCategory(nextPage);
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
          // Container(
          //   decoration: BoxDecoration(gradient: cShadowGradient),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(flex: 5, child: SizedBox()),
              Container(
                alignment: Alignment.centerLeft,
                child: Icon(icon, color: Colors.white),
              ),
              Expanded(flex: 3, child: SizedBox()),
              Center(
                child: Container(
                  child: Text(
                    option,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                      fontSize: 16.0
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
  } // build
} // CategoryNavigationItem
