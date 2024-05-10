import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wolvesrun/generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'package:wolvesrun/globals.dart' as globals;
import 'package:wolvesrun/services/network/database/AuthDB.dart';
import 'package:wolvesrun/util/MainUtil.dart';
import 'package:wolvesrun/util/Preferences.dart';

import 'Notch.dart';

class SignInUi extends StatefulWidget {
  const SignInUi({super.key});

  @override
  State<SignInUi> createState() => _SignInUiState();
}

class _SignInUiState extends State<SignInUi> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false; // State variable for loading state

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const AuthNotch(),
                Divider(
                  color: Theme.of(context).dividerColor.withOpacity(0.3),
                  thickness: 0.5,
                ),
                Image.asset(
                  'assets/images/auth/login_image.png',
                  width: screenSize.width * 0.9,
                  height: 325,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Theme.of(context).canvasColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildTextField(
                            label: S.of(context).emailusername,
                            controller: _usernameController),
                        const SizedBox(height: 16),
                        buildTextField(
                            label: S.of(context).password,
                            controller: _passwordController),
                        const SizedBox(height: 32),
                        Center(
                          child: ElevatedButton(
                            onPressed: _loading ? null : () => _login(context),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: _loading
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      'Login',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      {required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: label,
            ),
          ),
        ),
      ],
    );
  }

  void _login(BuildContext context) async {
    setState(() {
      _loading = true;
    });

    http.Response response = await AuthDB.login(email: _usernameController.text, password: _passwordController.text, context: context);

    if (response.statusCode == 200) {
      globals.token = jsonDecode(response.body)['data']['token'];
      await SP().updateString('token', globals.token!);
      await MainUtil.retrieveUserInformation();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }

    setState(() {
      _loading = false;
    });

  }
}
