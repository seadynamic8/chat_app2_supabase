import 'dart:io';

import 'package:chat_app2_supabase/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:chat_app2_supabase/utils/constants.dart';
import 'package:chat_app2_supabase/screens/chat.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredUsername = '';
  var _enteredPassword = '';
  var _isLogin = true;
  File? _selectedImage;

  void _submit() async {
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();

    try {
      if (_isLogin) {
        await supabase.auth.signInWithPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final response = await supabase.auth.signUp(
          email: _enteredEmail,
          password: _enteredPassword,
          data: {'username': _enteredUsername},
        );

        if (_selectedImage == null) return; // Image can be not selected.

        final userId = response.user!.id;
        final imagePath = '$userId.jpg';

        // Store image in storage bucket
        await supabase.storage
            .from('avatars')
            .upload(imagePath, _selectedImage!);

        // Get public image url
        final imageUrl =
            supabase.storage.from('avatars').getPublicUrl(imagePath);

        // Store public image url in supabase profile
        await supabase
            .from('profiles')
            .update({'avatar_url': imageUrl}).eq('id', userId);
      }

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const ChatScreen()),
        (route) => false,
      );
    } on AuthException catch (error) {
      context.showErrorSnackBar(error.message);
    } catch (error) {
      context.showErrorSnackBar(
          'Something went wrong with the authentication process. Try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Log In' : 'Sign Up'),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 30,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              child: Image.asset(
                'assets/images/chat.png',
                width: 200,
              ),
            ),
            Card(
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      if (!_isLogin)
                        UserImagePicker(
                          onPickImage: (pickedImage) =>
                              _selectedImage = pickedImage,
                        ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Email Address'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                        onSaved: (newValue) => _enteredEmail = (newValue!),
                      ),
                      if (!_isLogin)
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Username'),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.trim().length < 4) {
                              return 'Please enter at least 4 characters';
                            }
                            return null;
                          },
                          onSaved: (newValue) => _enteredUsername = (newValue!),
                        ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.trim().length < 6) {
                            return 'Password must be at least 6 characeters long.';
                          }
                          return null;
                        },
                        onSaved: (newValue) => _enteredPassword = newValue!,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: Text(_isLogin ? 'Login' : 'Sign Up'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create an account.'
                            : 'I already have an account.'),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
