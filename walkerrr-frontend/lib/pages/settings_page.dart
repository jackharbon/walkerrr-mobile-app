import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:walkerrr/auth.dart';
import 'package:walkerrr/common/styling_variables.dart';
import 'package:walkerrr/pages/quests_tab.dart';
import 'package:walkerrr/pages/steps_main_page.dart';
import 'package:walkerrr/providers/user_provider.dart';
import 'package:walkerrr/services/api_connection.dart';
import 'package:walkerrr/services/user_data_storage.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController controller = PageController();

// ==================== User MongoDB data edit ====================>

  Widget _userUid() {
    return Text(user?.email ?? "User Email");
  }

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Future<void> deleteUser() async {
    showAlertDialog(context);
  }

  Future<void> updateUserName() async {
    final newUsername = _controllerDisplayName.text;
    patchUsername(userObject['uid'], newUsername);
    _secureStorage.setDisplayName(newUsername);
    await FirebaseAuth.instance.currentUser!.updateDisplayName(newUsername);
    await FirebaseAuth.instance.currentUser!.reload();
  }

  Future<void> updateEmail() async {
    final newEmail = _controllerEmail.text;
    patchEmail(userObject['uid'], newEmail);
    _secureStorage.setEmail(newEmail);
    await FirebaseAuth.instance.currentUser!.updateEmail(newEmail);
    await FirebaseAuth.instance.currentUser!.reload();
  }

  Future<void> updatePassword() async {
    final newPassword = _controllerPassword.text;
    // patchPassword(userObject['password'], newPassword);
    _secureStorage.setPassword(newPassword);
    await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
    await FirebaseAuth.instance.currentUser!.reload();
  }

  // <=============

  // ---- Pages title ----
  Widget _title() {
    if (_selectedIndex == 0) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Steps'),
        Text('Coins: ${userObject["coins"]}'),
      ]);
    } else if (_selectedIndex == 1) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Settings'),
        Text('Coins: ${userObject["coins"]}'),
      ]);
    } else {
      return const Text('Settings');
    }
  }

// ==================== USER SETTINGS PAGE ====================

// --------- Secure storage ---------

  final TextEditingController _controllerDisplayName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPasswordConfirm =
      TextEditingController();

  final SecureStorage _secureStorage = SecureStorage();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchSecureStorageData();
  }

  Future<void> fetchSecureStorageData() async {
    _controllerDisplayName.text = await _secureStorage.getDisplayName() ?? '';
    _controllerEmail.text = await _secureStorage.getEmail() ?? '';
    _controllerPassword.text = await _secureStorage.getPassword() ?? '';
  }

// --------- Form flutter's validators ---------

  final AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;

  final _displayNameValidator = MultiValidator([
    RequiredValidator(errorText: 'Enter new display name'),
    MinLengthValidator(2, errorText: 'Min. 2 letters'),
  ]);
  final _emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Required'),
    MinLengthValidator(5, errorText: 'Min. 5 letters'),
    EmailValidator(errorText: "Invalid email address"),
  ]);
  final _passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Required'),
    MinLengthValidator(4, errorText: 'Min. 4 letters'),
    MaxLengthValidator(20,
        errorText: "Password cannot be longer than 20 characters"),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'Password must contain at least one special character')
  ]);
  final _passwordConfirmValidator = MultiValidator([
    RequiredValidator(errorText: 'Required'),
  ]);

// --------- Form fields states ---------

  // ---- Enabled field is underlined, icon toggle_on ----
  bool isDisplayNameEditingEnabled = false;
  bool isEmailEditingEnabled = false;
  bool isPasswordEditingEnabled = false;
  bool isPasswordConfirmEditingEnabled = false;
  bool isFormEditingEnabled = false;

  // ---- Focused field has grey background ----
  bool isDisplayNameFocused = false;
  bool isEmailFocused = false;
  bool isPasswordFocused = false;
  bool isPasswordConfirmFocused = false;

  // ---- Changed field state changes icon to save ----
  bool isDisplayNameChanged = false;
  bool isEmailChanged = false;
  bool isPasswordChanged = false;
  bool isPasswordConfirmChanged = false;
  bool isFormChanged = false;

  // ---- Saved state changes icon to toggle_off, locks the field ----
  bool isDisplayNameSaved = true;
  bool isEmailSaved = true;
  bool isPasswordSaved = true;
  bool isFormSaved = false;

  // ---- Password field and icon visibility ----
  bool isObscure = true;

  // ---- New field value after saving input ----
  String _newDisplayName = '';
  String _newEmail = '';
  String _newPassword = '';

  // ---- Field current value from onChange ----
  String _displayNameCurrent = '';
  String _currentEmail = '';
  String _currentPassword = '';
  String _currentPasswordConfirm = '';

  String _oldPassword = '';
// --------- Form fields widgets ---------

  Widget _entryFieldDisplayName(
    String displayName,
    TextEditingController _controllerDisplayName,
  ) {
    return Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            setState(() {
              isDisplayNameFocused = true;
              _displayNameCurrent = _controllerDisplayName.text;
            });
          } else {
            setState(() {
              isDisplayNameFocused = false;
            });
          }
        },
        child: TextFormField(
          enabled: isDisplayNameEditingEnabled,
          validator: _displayNameValidator,
          onChanged: ((value) => {
                setState(
                  () {
                    isDisplayNameChanged = true;
                    isDisplayNameSaved = false;
                    isFormChanged = true;
                    if (value.isNotEmpty) _displayNameCurrent = value;
                  },
                )
              }),
          controller: _controllerDisplayName,
          cursorColor: GlobalStyleVariables.primaryAccentColor,
          decoration: InputDecoration(
            hintText: 'Enter new display name',
            hintStyle: const TextStyle(
              color: GlobalStyleVariables.primaryTextDarkColour,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
            filled: isDisplayNameFocused,
            fillColor: GlobalStyleVariables.formActive,
            focusedBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: GlobalStyleVariables.primaryAccentColor),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: GlobalStyleVariables.primaryTextDarkColour,
              ),
            ),
            disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: GlobalStyleVariables.primaryTextLightColour,
              ),
            ),
            icon: const Icon(Icons.person_outline_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                !isDisplayNameEditingEnabled
                    ? Icons.toggle_off_outlined
                    : !isDisplayNameChanged
                        ? Icons.toggle_on_rounded
                        : !isDisplayNameSaved
                            ? Icons.save_outlined
                            : Icons.toggle_off_outlined,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  saveDisplayName();
                  _newDisplayName = _displayNameCurrent;
                  _controllerDisplayName.text = _newDisplayName;
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        duration: Duration(seconds: 2),
                        backgroundColor: GlobalStyleVariables.buttonRedActive,
                        content: Text("Check form fields before saving!")),
                  );
                }
              },
            ),
          ),
        ));
  }

  Widget _entryFieldEmail(
    String email,
    TextEditingController _controllerEmail,
  ) {
    return Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            setState(() {
              isEmailFocused = true;
              _currentEmail = _controllerEmail.text;
            });
          } else {
            setState(() {
              isEmailFocused = false;
            });
          }
        },
        child: TextFormField(
          enabled: isEmailEditingEnabled,
          validator: _emailValidator,
          onChanged: ((value) => {
                setState(
                  () {
                    isEmailChanged = true;
                    isEmailSaved = false;
                    isFormChanged = true;
                    if (value.isNotEmpty) _currentEmail = value;
                  },
                )
              }),
          controller: _controllerEmail,
          cursorColor: GlobalStyleVariables.primaryAccentColor,
          decoration: InputDecoration(
            hintText: 'Enter new email',
            hintStyle: const TextStyle(
              color: GlobalStyleVariables.primaryTextDarkColour,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
            filled: isEmailFocused,
            fillColor: GlobalStyleVariables.formActive,
            focusedBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: GlobalStyleVariables.primaryAccentColor),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: GlobalStyleVariables.primaryTextDarkColour,
              ),
            ),
            disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: GlobalStyleVariables.primaryTextLightColour,
              ),
            ),
            icon: const Icon(Icons.alternate_email_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                !isEmailEditingEnabled
                    ? Icons.toggle_off_outlined
                    : !isEmailChanged
                        ? Icons.toggle_on_rounded
                        : !isEmailSaved
                            ? Icons.save_outlined
                            : Icons.toggle_off_outlined,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  saveEmail();
                  _newEmail = _currentEmail;
                  _controllerEmail.text = _newEmail;
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        duration: Duration(seconds: 2),
                        backgroundColor: GlobalStyleVariables.buttonRedActive,
                        content: Text("Check form fields before saving!")),
                  );
                }
              },
            ),
          ),
        ));
  }

  Widget _entryFieldPassword(
    String password,
    TextEditingController _controllerPassword,
  ) {
    return Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            setState(() {
              isPasswordFocused = true;
              _oldPassword = _controllerPassword.text;
            });
            if (_currentPassword.isEmpty) {
              _controllerPassword.text = '';
            } else {
              _controllerPassword.text = _currentPassword;
            }
          } else {
            if (!isPasswordChanged && !isPasswordSaved) {
              _controllerPassword.text = _oldPassword;
            } else if (isPasswordChanged && !isPasswordSaved) {
              _controllerPassword.text = _currentPassword;
            } else if (isPasswordChanged && isPasswordSaved) {
              _controllerPassword.text = _newPassword;
            }
            setState(() {
              isPasswordFocused = false;
            });
          }
        },
        child: TextFormField(
          enabled: isPasswordEditingEnabled,
          obscureText: isObscure,
          validator: _passwordValidator,
          onChanged: ((value) => {
                if (value.isNotEmpty)
                  {
                    setState(
                      () {
                        isPasswordChanged = true;
                        isPasswordConfirmEditingEnabled = true;
                        isPasswordSaved = false;
                        isFormChanged = true;
                        _currentPassword = value;
                      },
                    ),
                  }
              }),
          controller: _controllerPassword,
          cursorColor: GlobalStyleVariables.primaryAccentColor,
          decoration: InputDecoration(
            hintText: 'Enter new password',
            hintStyle: const TextStyle(
              color: GlobalStyleVariables.primaryTextDarkColour,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
            filled: isPasswordFocused,
            fillColor: GlobalStyleVariables.formActive,
            focusedBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: GlobalStyleVariables.primaryAccentColor),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: GlobalStyleVariables.primaryTextDarkColour,
              ),
            ),
            disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: GlobalStyleVariables.primaryTextLightColour,
              ),
            ),
            icon: const Icon(Icons.password_outlined),
            suffixIcon: IconButton(
              icon: Icon(!isPasswordEditingEnabled
                  ? Icons.toggle_off_outlined
                  : !isPasswordChanged
                      ? Icons.toggle_on_rounded
                      : isObscure
                          ? Icons.visibility
                          : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  isObscure = !isObscure;
                });
              },
            ),
          ),
        ));
  }

  Widget _entryFieldPasswordConfirm(
    String passwordConfirm,
    TextEditingController _controllerPasswordConfirm,
  ) {
    return Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            _controllerPasswordConfirm.text = '';
            setState(() {
              isPasswordConfirmFocused = true;
              isObscure = true;
            });
          } else {
            _controllerPasswordConfirm.text = '';
            setState(() {
              isPasswordConfirmFocused = false;
            });
          }
        },
        child: TextFormField(
          enabled: isPasswordConfirmEditingEnabled,
          obscureText: isObscure,
          validator: _passwordConfirmValidator,
          onChanged: ((value) => {
                setState(
                  () {
                    isPasswordConfirmChanged = true;
                    isPasswordSaved = false;
                    _currentPasswordConfirm = value;
                  },
                )
              }),
          controller: _controllerPasswordConfirm,
          cursorColor: GlobalStyleVariables.primaryAccentColor,
          decoration: InputDecoration(
            hintText: 'Re-type your new password',
            hintStyle: const TextStyle(
              color: GlobalStyleVariables.primaryTextDarkColour,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
            filled: isPasswordConfirmFocused,
            fillColor: GlobalStyleVariables.formActive,
            focusedBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: GlobalStyleVariables.primaryAccentColor),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: GlobalStyleVariables.primaryTextDarkColour,
              ),
            ),
            disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: GlobalStyleVariables.primaryTextLightColour,
              ),
            ),
            icon: const Icon(
              Icons.password_outlined,
            ),
            suffixIcon: IconButton(
              icon: Icon(!isPasswordConfirmChanged
                  ? Icons.toggle_on_outlined
                  : !isPasswordSaved
                      ? Icons.save_outlined
                      : Icons.toggle_off_outlined),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_currentPasswordConfirm == _currentPassword) {
                    savePassword();
                    _newPassword = _currentPassword;
                    _controllerPassword.text = _newPassword;
                    _controllerPasswordConfirm.text = '';
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          duration: Duration(seconds: 2),
                          backgroundColor: GlobalStyleVariables.buttonRedActive,
                          content: Text("Passwords are not equal!")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        duration: Duration(seconds: 2),
                        backgroundColor: GlobalStyleVariables.buttonRedActive,
                        content: Text("Check form fields before saving!")),
                  );
                }
              },
            ),
          ),
        ));
  }

// <=============

// ============= Buttons =============>

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              GlobalStyleVariables.buttonGreyInactive)),
      child: const Text("Cancel"),
    );
    Widget continueButton = ElevatedButton(
      onPressed: () async {
        Navigator.of(context).pop();
        await Auth()
            .deleteUser(_controllerEmail.text, _controllerPassword.text);
        _secureStorage.deleteDisplayName();
        _secureStorage.deleteEmail();
        _secureStorage.deletePassword();
        signOut();
      },
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(GlobalStyleVariables.buttonRedActive)),
      child: const Text("DELETE"),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Account Permanently"),
      content: const Text(
          "This will delete your account permenantly. \n\nDo you wish to continue?"),
      actions: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              cancelButton,
              continueButton,
            ],
          ),
        )
      ],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // ---- Initial state after enabling editing from profile menu ----
  void enableEditing() {
    setState(() {
      isDisplayNameFocused = false;
      isEmailFocused = false;
      isPasswordFocused = false;
      isPasswordConfirmFocused = false;

      isDisplayNameChanged = false;
      isEmailChanged = false;
      isPasswordChanged = false;
      isPasswordConfirmChanged = false;
      isFormChanged = false;

      isDisplayNameSaved = true;
      isEmailSaved = true;
      isPasswordSaved = true;
      isFormSaved = false;

      isObscure = true;
      isDisplayNameEditingEnabled = true;
      isEmailEditingEnabled = true;
      isPasswordEditingEnabled = true;
      isFormEditingEnabled = true;
    });
  }

  // ---- Resetting states after canceling/closing edit mode ----
  void cancelEditing() async {
    fetchSecureStorageData();

    setState(() {
      isDisplayNameEditingEnabled = false;
      isEmailEditingEnabled = false;
      isPasswordEditingEnabled = false;
      isPasswordConfirmEditingEnabled = false;
      isDisplayNameSaved = true;
      isEmailSaved = true;
      isPasswordSaved = true;
      isFormEditingEnabled = false;
      isDisplayNameFocused = false;
      isEmailFocused = false;
      isPasswordFocused = false;
      isPasswordConfirmFocused = false;
      isObscure = true;
      _newDisplayName = '';
      _newEmail = '';
      _newPassword = '';
      _currentPassword = '';
      _currentPasswordConfirm = '';
      _oldPassword = '';
    });
  }

  // ---- Update Mongo DB username ----
  void saveDisplayName() {
    updateUserName();
    setState(() {
      isDisplayNameSaved = true;
      isDisplayNameEditingEnabled = false;
      isDisplayNameFocused = false;
      if (!isDisplayNameEditingEnabled &&
          !isEmailEditingEnabled &&
          !isPasswordEditingEnabled &&
          !isPasswordConfirmEditingEnabled) isFormEditingEnabled = false;
    });
    FirebaseAuth.instance.currentUser!.reload();
  }

  // ---- Update Mongo DB email ----
  void saveEmail() {
    updateEmail();
    setState(() {
      isEmailSaved = true;
      isEmailEditingEnabled = false;
      isEmailFocused = false;
      if (!isDisplayNameEditingEnabled &&
          !isEmailEditingEnabled &&
          !isPasswordEditingEnabled &&
          !isPasswordConfirmEditingEnabled) isFormEditingEnabled = false;
    });
    FirebaseAuth.instance.currentUser!.reload();
  }

  // ---- Update Mongo DB password ----
  void savePassword() {
    updatePassword();
    setState(() {
      isPasswordSaved = true;
      isPasswordEditingEnabled = false;
      isPasswordConfirmEditingEnabled = false;
      isPasswordFocused = false;
      isPasswordConfirmFocused = false;
      isObscure = true;
      if (!isDisplayNameEditingEnabled &&
          !isEmailEditingEnabled &&
          !isPasswordEditingEnabled &&
          !isPasswordConfirmEditingEnabled) isFormEditingEnabled = false;
    });
    FirebaseAuth.instance.currentUser!.reload();
  }

  // ---- Update Mongo DB fields ----
  void saveChanges() {
    if (isDisplayNameChanged == true) saveDisplayName();
    if (isEmailChanged == true) saveEmail();
    if (isPasswordChanged == true) savePassword();
    setState(() => {
          isFormSaved = true,
          isFormEditingEnabled = false,
        });
    cancelEditing();
    FirebaseAuth.instance.currentUser!.reload();
  }

  // <=============

  // ============= Pages =============>

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // print(height);
    List<Widget> _pages = <Widget>[
      const MainPedometer(), //Page 0
      const QuestList(),
      // Page 2
      SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: GlobalStyleVariables.primaryBackgroundColour,
          height: MediaQuery.of(context).size.height - 145,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // --- Header ---
                      Container(
                        height: 50,
                        child: const Text(
                          'Welcome to Walkerrr',
                          style: TextStyle(
                            color: GlobalStyleVariables.primaryAccentColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      // --- Form fields ---
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // --- displayName form entry ---
                            Container(
                              height: 80,
                              width: double.infinity,
                              child: _entryFieldDisplayName(
                                  "New display name", _controllerDisplayName),
                            ),
                            // --- email form entry ---
                            Container(
                              height: 80,
                              width: double.infinity,
                              child: _entryFieldEmail(
                                  "Your email", _controllerEmail),
                            ),
                            // --- password form entry ---
                            Container(
                              height: 80,
                              width: double.infinity,
                              child: _entryFieldPassword(
                                  "Enter password", _controllerPassword),
                            ),
                            // --- passwordConfirm form entry ---
                            Visibility(
                              visible: isPasswordConfirmEditingEnabled,
                              child: Container(
                                  height: 80,
                                  width: double.infinity,
                                  child: _entryFieldPasswordConfirm(
                                      "Re-type password",
                                      _controllerPasswordConfirm)),
                            ),
                          ],
                        ),
                      ),
                      // --- saveAll button ---
                      Container(
                        padding: const EdgeInsets.all(6),
                        child: Visibility(
                          visible: isFormChanged && isFormEditingEnabled,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              OutlinedButton.icon(
                                icon: const Icon(
                                  color: GlobalStyleVariables.buttonGreenActive,
                                  Icons.save_outlined,
                                  size: 24.0,
                                ),
                                label: const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    color:
                                        GlobalStyleVariables.buttonGreenActive,
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (!isPasswordChanged ||
                                        _currentPasswordConfirm ==
                                            _currentPassword) {
                                      saveChanges();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            duration: Duration(seconds: 2),
                                            backgroundColor:
                                                GlobalStyleVariables
                                                    .buttonRedActive,
                                            content: Text(
                                                "Passwords are not equal!")),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          duration: Duration(seconds: 2),
                                          backgroundColor: GlobalStyleVariables
                                              .primaryAccentColor,
                                          content: Text(
                                              "Check form fields before saving!")),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
              Visibility(
                // --- delete Account button ---
                visible: isFormEditingEnabled,
                child: Container(
                  color: GlobalStyleVariables.buttonRedBackground,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('DANGER ZONE:',
                          style: TextStyle(
                              color: GlobalStyleVariables.buttonRedActive,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: GlobalStyleVariables.buttonRedActive,
                        ),
                        icon: const Icon(
                          Icons.delete_forever_outlined,
                          color: GlobalStyleVariables.primaryTextLightColour,
                          size: 24.0,
                        ),
                        label: const Text('Delete Account',
                            style: TextStyle(
                                color: GlobalStyleVariables
                                    .primaryTextLightColour)),
                        onPressed: (() => deleteUser()),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: _title(),
        backgroundColor: GlobalStyleVariables.primaryAppBarColour,
        actions: <Widget>[
          if (_selectedIndex == 2)
            PopupMenuButton<int>(
              enabled: true,
              elevation: 4,
              offset: const Offset(0, 58),
              shape: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: GlobalStyleVariables.primaryTextLightColour,
                      width: 1)),
              onCanceled: () {
                cancelEditing();
              },
              onSelected: (value) {
                if (value == 1) {
                  !isFormEditingEnabled ? enableEditing() : cancelEditing();
                } else if (value == 2) {
                  signOut();
                }
              },
              icon: const Icon(
                Icons.account_circle,
                color: GlobalStyleVariables.primaryTextLightColour,
              ),
              color: GlobalStyleVariables.primaryAppBarColour,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      !isFormEditingEnabled
                          ? const Icon(Icons.edit_outlined)
                          : const Icon(Icons.edit_off_outlined),
                      const SizedBox(
                        width: 10,
                      ),
                      !isFormEditingEnabled
                          ? const Text("Edit profile",
                              style: TextStyle(
                                color:
                                    GlobalStyleVariables.primaryTextLightColour,
                              ))
                          : const Text("Cancel",
                              style: TextStyle(
                                color:
                                    GlobalStyleVariables.primaryTextLightColour,
                              )),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      const Icon(Icons.logout_outlined),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "Sign Out",
                        style: TextStyle(
                          color: GlobalStyleVariables.primaryTextLightColour,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: PageView(
        controller: controller,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: GlobalStyleVariables.primaryBottomBarColour,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/icon_Lightning.png",
              height: 24,
              fit: BoxFit.cover,
            ),
            label: "Steps",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/icon_Flag.png",
              height: 24,
              fit: BoxFit.cover,
            ),
            label: "Quests",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/icon_Settings.png",
              height: 24,
              fit: BoxFit.cover,
            ),
            label: "Settings",
          )
        ],
        onTap: (index) {
          controller.jumpToPage(index);

          /// Switching the PageView tabs
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
