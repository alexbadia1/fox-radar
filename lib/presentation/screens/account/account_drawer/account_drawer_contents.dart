import 'dart:typed_data';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:fox_radar/presentation/presentation.dart';

class AccountDrawerContents extends StatefulWidget {
  @override
  _AccountDrawerContentsState createState() => _AccountDrawerContentsState();
} // AccountDrawerContents

class _AccountDrawerContentsState extends State<AccountDrawerContents> {
  final double topPadding = WidgetsBinding.instance.window.padding.top / WidgetsBinding.instance.window.devicePixelRatio;

  Future<dynamic> showEditAccount(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      builder: (modalContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: BlocProvider.of<AuthenticationBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<UpdateProfileBloc>(context)),
          ],
          child: RepositoryProvider<AuthenticationRepository>.value(
            value: RepositoryProvider.of<AuthenticationRepository>(context),
            child: EditAccountScreen(),
          ),
        );
      },
    );
  } // showEditAccount

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(24, 24, 24, 1.0),
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: topPadding),
          ModalActionMenu(
            bottomActionsTitle: "",
            maxHeight: double.infinity,
            featureWidget: GestureDetector(
              onTap: () => this.showEditAccount(context),
              child: CustomListTile(
                enableBorders: false,
                leading: Builder(
                  builder: (circleAvatarContext) {
                    final _auth = circleAvatarContext.watch<AuthenticationBloc>().state;

                    if (_auth is AuthenticationStateAuthenticated) {
                      final Uint8List _imageBytes = _auth.imageBytes;

                      /// Try to show profile image
                      if (_imageBytes != null) {
                        return CircleAvatar(
                          backgroundImage: MemoryImage(_imageBytes),
                        );
                      } // if

                      /// Show initials, if no profile image
                      final String firstInitial = _auth.user.firstName[0]?.toUpperCase() ?? '';
                      final String lastInitial = _auth.user.lastName[0]?.toUpperCase() ?? '';
                      return CircleAvatar(
                        child: Text('$firstInitial$lastInitial'),
                      );
                    } // if
                    return IconButton(
                      color: kHavenLightGray,
                      onPressed: () => Navigator.of(circleAvatarContext).pop(),
                      icon: Icon(Icons.account_circle_outlined, color: kHavenLightGray),
                    );
                  },
                ),
                subtitle: Builder(builder: (userTypeContext) {
                  final _auth = userTypeContext.watch<AuthenticationBloc>().state;

                  if (_auth is AuthenticationStateAuthenticated) {
                    return Text(
                      'Type: User',
                      style: TextStyle(color: cWhite70, fontSize: 12.0),
                    );
                  } // if

                  return Text(
                    'Type: Admin',
                    style: TextStyle(color: cWhite70, fontSize: 12.0),
                  );
                }),
                description: Builder(builder: (emailContext) {
                  final _auth = emailContext.watch<AuthenticationBloc>().state;

                  if (_auth is AuthenticationStateAuthenticated) {
                    return Text(
                      _auth.user.email ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(color: cWhite70, fontSize: 12.0),
                    );
                  } // if

                  return Text(
                    'example.com@marist.edu',
                    style: TextStyle(color: cWhite70, fontSize: 12.0),
                  );
                }),
                trailing: IconButton(
                  color: cWhite70,
                  icon: Icon(Icons.chevron_right),
                  onPressed: () {
                    this.showEditAccount(context);
                  },
                ),
              ),
            ),
            bottomActions: [
              ModalActionMenuButton(
                icon: Icons.settings_outlined,
                description: "Settings",
              ),
              ModalActionMenuButton(
                icon: Icons.lightbulb_outline,
                description: "Help & Feedback",
              ),
              ModalActionMenuButton(
                icon: Icons.logout_outlined,
                description: "Sign Out",
                onPressed: () {
                  BlocProvider.of<LoginBloc>(context).add(LoginEventLogout());
                },
              ),
            ],
          ),
        ],
      ),
    );
  } // build
} // _AccountDrawerContentsState
