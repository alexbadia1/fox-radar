import 'package:authentication_repository/authentication_repository.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}// SignUpScreen

class _SignUpScreenState extends State<SignUpScreen> {
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenPaddingBottom = MediaQuery.of(context).padding.bottom;
    final screenInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    final screenPaddingTop = MediaQuery.of(context).padding.top;

    final height = screenHeight -
        screenPaddingTop -
        screenPaddingBottom +
        screenInsetsBottom;

    return SafeArea(
      child: Scaffold(
        backgroundColor: cFullRedFaded,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            height: height,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: <Widget>[
                Container(
                  height: screenHeight,
                  width: screenWidth,
                  child: Image(
                      image: AssetImage("images/image1.jpg"),
                      fit: BoxFit.cover),
                ),
                FullScreenGradient(gradient: cMaristGradient),
                Container(
                  child: BlocProvider<SignUpBloc>(
                    create: (BuildContext context) => SignUpBloc(authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: SizedBox(),
                        ),

                        Builder(
                          builder: (context) {
                            final SignUpState _signUpState = context.watch<SignUpBloc>().state;

                            if (_signUpState is SignUpStateSubmitted) {
                              return Container(height: height * .10);
                            } // if

                            return Container(
                              height: height * .10,
                              width: screenWidth * .75,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.chevron_left),
                                    iconSize: 35.0,
                                    color: kHavenLightGray,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Container(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Back',
                                        style: TextStyle(
                                            fontSize: 22.0,
                                            color: kHavenLightGray),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        /// Title
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * .775,
                            child: Text(
                              'Sign Up',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w400,
                                fontSize: 44.0,
                                color: kHavenLightGray,
                              ),
                            ),
                          ),
                        ),

                        /// Subtitle
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * .75,
                            child: Text(
                              'See the latest events!',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0,
                                color: kHavenLightGray,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 15,
                          child: Builder(
                            builder: (context) {
                              final SignUpState _signUpState = context.watch<SignUpBloc>().state;

                              // Loading Widget
                              if (_signUpState is SignUpStateSubmitted) {
                                return LoadingWidget(
                                  size: 90.0,
                                  color: kHavenLightGray,
                                );
                              } // if

                              // Show Form
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: SignUpForm(controller: _scrollController),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Already have an account? ',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      InkWell(
                                        child: Text(
                                          'Sign In',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: SizedBox(),
                        ),
                        SizedBox(
                          height: screenInsetsBottom,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }// build
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }// dispose
}// _SignUpScreenState
