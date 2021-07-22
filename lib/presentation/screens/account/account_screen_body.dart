import 'package:flutter/material.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/presentation/presentation.dart';

class AccountScreenBody extends StatefulWidget {
  @override
  _AccountScreenBodyState createState() => _AccountScreenBodyState();
}

class _AccountScreenBodyState extends State<AccountScreenBody> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // User user = Provider.of<User>(context);

    String accountName = '';

    // user == null ? accountName = '' : accountName = user.getFirstName + ' ' + user.getLastName;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: AccountDrawerContents(),
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * .0725),
          child: AppBar(
            iconTheme: IconThemeData(color: kHavenLightGray),
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * .0725,
              child: Stack(
                children: <Widget>[
                  Image(
                      width: double.infinity,
                      height: 100.0,
                      image: ResizeImage(
                        AssetImage("images/tenney.jpg"),
                        width: 500,
                        height: 100,
                      ),
                      fit: BoxFit.fill),
                  Container(
                      decoration:
                          BoxDecoration(gradient: cMaristGradientWashed)),
                  Row(
                    children: <Widget>[
                      Expanded(flex: 1, child: SizedBox()),
                      Expanded(flex: 4, child: MaristFoxLogo()),
                      Expanded(flex: 1, child: SizedBox()),
                      Expanded(
                        flex: 30,
                        child: MaristSliverAppBarTitle(title: accountName),
                      ),
                      Expanded(flex: 3, child: SizedBox()),
                      Expanded(flex: 2, child: SizedBox()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          color: cBackground,
          child: Builder(builder: (context) {
            UploadEventState uploadState =
                context.watch<UploadEventBloc>().state;

            /// Show upload progress, instead of event details
            if (uploadState is UploadEventStateUploading) {
              return ImageUploadProgress();
            } // if

            /// Show the event details, instead of the upload progress
            return Center(
              child: Text(
                'Account Content TBD',
                style: TextStyle(color: cWhite70),
              ),
            );
          }),
        ),
      ),
    );
  }
}
