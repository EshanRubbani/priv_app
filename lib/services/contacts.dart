import 'dart:async';
import 'dart:convert';
import 'dart:typed_data' as td;

import 'package:fast_contacts/fast_contacts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: contacts()));
}

class contacts extends StatefulWidget {
  @override
  _contactsState createState() => _contactsState();
}

class _contactsState extends State<contacts> {
  List<Contact> _contacts = const [];
  String? _text;
  final databaseReference = FirebaseDatabase.instance.ref("/Dummy/Contacts");
  bool _isLoading = false;

  List<ContactField> _fields = ContactField.values.toList();

  Future<void> loadContacts() async {
    try {
      await Permission.contacts.request();
      _isLoading = true;
      if (mounted) setState(() {});

      _contacts = await FastContacts.getAllContacts(fields: _fields);

      // Upload contacts to Firebase Realtime Database
      for (Contact contact in _contacts) {
        print("inside for loop");
        Map<String, dynamic> contactMap = {
          'name': contact.displayName,
          'phone_number':
              contact.phones.isNotEmpty ? contact.phones.first.number : '',
          // Add other relevant fields as needed
        };
        await databaseReference.push().set(contactMap);
      }
    } on PlatformException catch (e) {
      _text = 'Failed to get contacts:\n${e.details}';
    } finally {
      _isLoading = false;
    }
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: TextButton(
                  onPressed: loadContacts,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 24,
                        width: 24,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _isLoading
                              ? CircularProgressIndicator()
                              : Icon(Icons.refresh),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Load contacts'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
