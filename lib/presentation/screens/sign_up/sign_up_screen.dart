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
      child: Container(
        height: height + screenInsetsBottom,
        width: screenWidth,
        child: Stack(
          children: [
            Image(image: AssetImage("images/image1.jpg"), fit: BoxFit.none),
            FullScreenGradient(gradient: cMaristGradientWashed, height: height + screenInsetsBottom),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Container(
                  height: height,
                  width: screenWidth,
                  child: BlocProvider<SignUpBloc>(
                    create: (BuildContext context) => SignUpBloc(authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Listener(onPointerDown: (_) =>
                              FocusScope.of(context).unfocus(),
                              behavior: HitTestBehavior.opaque,child: SizedBox()),
                        ),

                        Builder(
                          builder: (context) {
                            final SignUpState _signUpState = context.watch<SignUpBloc>().state;

                            if (_signUpState is SignUpStateSubmitted) {
                              return Container(height: height * .10);
                            } // if

                            return Listener(
                              onPointerDown: (_) =>
                                  FocusScope.of(context).unfocus(),
                              behavior: HitTestBehavior.opaque,
                              child: Container(
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
                                        FocusScope.of(context).unfocus();
                                        Navigator.pushReplacementNamed(context, '/login');
                                      },
                                    ),
                                    Container(
                                      child: InkWell(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          Navigator.pushReplacementNamed(context, '/login');
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
                              ),
                            );
                          },
                        ),

                        /// Title
                        Listener(
                          onPointerDown: (_) =>
                              FocusScope.of(context).unfocus(),
                          behavior: HitTestBehavior.opaque,
                          child: Center(
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
                        ),

                        /// Subtitle
                        Listener(
                          onPointerDown: (_) =>
                              FocusScope.of(context).unfocus(),
                          behavior: HitTestBehavior.opaque,
                          child: Center(
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
                                    flex: 20,
                                    child: SignUpForm(),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Listener(onPointerDown: (_) =>
                                        FocusScope.of(context).unfocus(),
                                        behavior: HitTestBehavior.opaque,child: SizedBox()),
                                  ),
                                  Listener(
                                    onPointerDown: (_) =>
                                        FocusScope.of(context).unfocus(),
                                    behavior: HitTestBehavior.opaque,
                                    child: Row(
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
                                            FocusScope.of(context).unfocus();
                                            Navigator.pushReplacementNamed(context, '/login');
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Listener(onPointerDown: (_) =>
                              FocusScope.of(context).unfocus(),
                              behavior: HitTestBehavior.opaque,child: SizedBox()),
                        ),
                        Listener(
                          onPointerDown: (_) =>
                              FocusScope.of(context).unfocus(),
                          behavior: HitTestBehavior.opaque,
                          child: SizedBox(
                            height: screenInsetsBottom,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }// build
}// _SignUpScreenState
