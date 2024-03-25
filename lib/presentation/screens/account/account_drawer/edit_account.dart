import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:fox_radar/presentation/presentation.dart';

class EditAccountScreen extends StatefulWidget {
  final Uint8List? imageBytes;
  const EditAccountScreen({Key? key, this.imageBytes}) : super(key: key);

  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late Completer<bool> _profileUpdateCompleter = new Completer();
  late ImagePicker? _picker;

  Future getImageFromDeviceGallery(BuildContext context) async {
    try {
      Navigator.of(context).pop();
      XFile? image = await this._picker?.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1080,
          maxHeight: 1350
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        BlocProvider.of<UpdateProfileBloc>(context).add(UpdateProfileEventSetImage(bytes));
        this._profileUpdateCompleter = new Completer();
        _showSnackBar(context, bytes);
      }
    }
    catch (e) {}
  }

  Future getImageFromCamera(BuildContext context) async {
    try {
      Navigator.of(context).pop();
      XFile? image = await this._picker?.pickImage(
          source: ImageSource.camera,
          maxWidth: 1080,
          maxHeight: 1350
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        BlocProvider.of<UpdateProfileBloc>(context).add(UpdateProfileEventSetImage(bytes));
        this._profileUpdateCompleter = new Completer();
        _showSnackBar(context, bytes);
      }
    }

    /// Error opening the camera
    catch (platformException) {
      PlatformException e = platformException as PlatformException;
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error Accessing Camera'),
          content: Text(e.message ?? ''),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        ),
      );
    }
  }

  /// Can't call showSnackbar in a Build() widget, so must use a completer instead
  Future<void> _showSnackBar(BuildContext context, Uint8List retryImageBytes) async {
    final bool success = await this._profileUpdateCompleter.future;
    this._profileUpdateCompleter = new Completer();
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profile image failed to update!"),
          action: SnackBarAction(
            label: "TRY AGAIN",
            onPressed: () async {
              BlocProvider.of<UpdateProfileBloc>(context).add(
                UpdateProfileEventSetImage(retryImageBytes),
              );
              this._showSnackBar(context, retryImageBytes);
            },
          ),
        ),
      );
    }

    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profile image successfully updated!"),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    this._picker = new ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = WidgetsBinding.instance.window.padding.top / WidgetsBinding.instance.window.devicePixelRatio;

    return Scaffold(
      key: this._scaffoldKey,
      body: Container(
        color: Color.fromRGBO(24, 24, 24, 1.0),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: topPadding),
            ModalActionMenu(
              bottomActionsTitle: "Edit Account",
            ),
            cVerticalMarginSmall(context),
            Builder(
              builder: (avatarContext) {
                final _auth = avatarContext.watch<AuthenticationBloc>().state;

                if (_auth is AuthenticationStateAuthenticated) {
                  return CircleAvatar(
                    radius: 40,
                    child: Builder(
                      builder: (BuildContext context) {
                        final _updateProfileState = avatarContext.watch<UpdateProfileBloc>().state;

                        if (_updateProfileState is UpdateProfileStateUpdating) {
                          return CustomCircularProgressIndicator();
                        }

                        /// Profile Successfully uploaded
                        if (_updateProfileState is UpdateProfileStateSuccess) {
                          this._profileUpdateCompleter.complete(true);
                        }

                        if (_updateProfileState is UpdateProfileStateFailed) {
                          this._profileUpdateCompleter.complete(false);
                        }

                        /// Try to show profile image
                        if (_updateProfileState.imageBytes != null) {
                          return Image.memory(_updateProfileState.imageBytes, fit: BoxFit.cover);
                        }

                        /// Show initials, if no profile image
                        else {
                          final String firstInitial = _auth.user.firstName[0]?.toUpperCase() ?? '';
                          final String lastInitial = _auth.user.lastName[0]?.toUpperCase() ?? '';
                          return Text('$firstInitial$lastInitial');
                        }
                      },
                    ),
                  );
                }
                return Icon(Icons.account_circle_outlined, color: kHavenLightGray);
              },
            ),
            TextButton(
              child: Text(
                'Update Image',
                style: TextStyle(color: Colors.blueAccent, fontSize: 16.0),
              ),
              onPressed: () {
                final _updateProfileState = BlocProvider.of<UpdateProfileBloc>(context).state;

                if (_updateProfileState is UpdateProfileStateUpdating) {
                  // Profile picture already being uploaded
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("A Profile picture is already uploading!"),
                    ),
                  );
                }
                else {
                  // Update profile picture
                  showModalBottomSheet(
                      context: context,
                      builder: (chooseImageContext) {
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider.value(value: BlocProvider.of<AuthenticationBloc>(context)),
                            BlocProvider.value(value: BlocProvider.of<UpdateProfileBloc>(context)),
                          ],
                          child: ModalActionMenu(
                            actions: [
                              ModalActionMenuButton(
                                icon: Icons.camera_alt_outlined,
                                description: "Camera",
                                onPressed: () {},
                              ),
                              ModalActionMenuButton(
                                icon: Icons.image_outlined,
                                description: "From Device",
                                onPressed: () => getImageFromDeviceGallery(context),
                              ),
                            ],
                            cancel: true,
                          ),
                        );
                      });
                }
              },
            ),
            Builder(builder: (userTypeContext) {
              final _auth = userTypeContext.watch<AuthenticationBloc>().state;

              if (_auth is AuthenticationStateAuthenticated) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Account Type: User',
                    style: TextStyle(color: cWhite70, fontSize: 14.0),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Account Type: Admin',
                  style: TextStyle(color: cWhite70, fontSize: 14.0),
                ),
              );
            }),
            Builder(builder: (emailContext) {
              final _auth = emailContext.watch<AuthenticationBloc>().state;

              if (_auth is AuthenticationStateAuthenticated) {
                return Text(
                  "Email: ${_auth.user.email}" ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(color: cWhite70, fontSize: 14.0),
                );
              }

              return Text(
                'email: example.com@marist.edu',
                style: TextStyle(color: cWhite70, fontSize: 14.0),
              );
            }),
          ],
        ),
      ),
    );
  }
}
