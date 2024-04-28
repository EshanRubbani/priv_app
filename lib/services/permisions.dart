// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:priv_app/services/apps.dart';
import 'package:priv_app/services/contacts.dart';
import 'package:priv_app/services/device_info.dart';
import 'package:priv_app/services/notification.dart';

class Permissions extends StatefulWidget {
  const Permissions({super.key});

  @override
  State<Permissions> createState() => _PermissionsState();
}

class _PermissionsState extends State<Permissions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => notification()),
            );
          },
          label: Text("Next")),
      appBar: AppBar(
        title: const Text("Permissions"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.location_on),
              ),
              title: const Text("Location Permission"),
              subtitle: const Text("Status of Permission: "),
              onTap: () async {
                PermissionStatus locationStatus =
                    await Permission.location.request();
                if (locationStatus == PermissionStatus.granted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Granted")));
                }
                if (locationStatus == PermissionStatus.denied) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Denied")));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("This Permission is required")));
                }
                if (locationStatus == PermissionStatus.permanentlyDenied) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Required")));
                  openAppSettings();
                }
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.camera_alt),
              ),
              onTap: () async {
                PermissionStatus cameraStatus =
                    await Permission.camera.request();
                if (cameraStatus == PermissionStatus.granted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Granted")));
                }
                if (cameraStatus == PermissionStatus.denied) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Denied")));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("This Permission is required")));
                }
                if (cameraStatus == PermissionStatus.permanentlyDenied) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Required")));
                  openAppSettings();
                }
              },
              title: const Text("Camera Permission"),
              subtitle: const Text("Status of Permission: "),
            ),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.contacts),
              ),
              onTap: () async {
                PermissionStatus contactsStatus =
                    await Permission.contacts.request();
                if (contactsStatus == PermissionStatus.granted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Granted")));
                }
                if (contactsStatus == PermissionStatus.denied) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Denied")));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("This Permission is required")));
                }
                if (contactsStatus == PermissionStatus.permanentlyDenied) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Required")));
                  openAppSettings();
                }
              },
              title: const Text("Contacts Permission"),
              subtitle: const Text("Status of Permission: "),
            ),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.phone),
              ),
              onTap: () async {
                PermissionStatus phoneStatus = await Permission.phone.request();
                if (phoneStatus == PermissionStatus.granted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Granted")));
                }
                if (phoneStatus == PermissionStatus.denied) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Denied")));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("This Permission is required")));
                }
                if (phoneStatus == PermissionStatus.permanentlyDenied) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Required")));
                  openAppSettings();
                }
              },
              title: const Text("Phone Logs Permission"),
              subtitle: const Text("Status of Permission: "),
            ),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.storage),
              ),
              onTap: () async {
                PermissionStatus storageStatus =
                    await Permission.storage.request();
                if (storageStatus == PermissionStatus.granted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Granted")));
                }
                if (storageStatus == PermissionStatus.denied) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Denied")));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("This Permission is required")));
                  openAppSettings();
                }
                if (storageStatus == PermissionStatus.permanentlyDenied) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Required")));
                  openAppSettings();
                }
              },
              title: const Text("Storage Permission"),
              subtitle: const Text("Status of Permission: "),
            ),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.sms),
              ),
              onTap: () async {
                PermissionStatus smsStatus = await Permission.sms.request();
                if (smsStatus == PermissionStatus.granted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Granted")));
                }
                if (smsStatus == PermissionStatus.denied) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Denied")));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("This Permission is required")));
                }
                if (smsStatus == PermissionStatus.permanentlyDenied) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Required")));
                  openAppSettings();
                }
              },
              title: const Text("SMS Permission"),
              subtitle: const Text("Status of Permission: "),
            ),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.mic),
              ),
              onTap: () async {
                PermissionStatus micStatus =
                    await Permission.microphone.request();
                if (micStatus == PermissionStatus.granted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Granted")));
                }
                if (micStatus == PermissionStatus.denied) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Denied")));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("This Permission is required")));
                }
                if (micStatus == PermissionStatus.permanentlyDenied) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission Is Required")));
                  openAppSettings();
                }
              },
              title: const Text("Mic Permission"),
              subtitle: const Text("Status of Permission: "),
            ),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.notification_add),
              ),

              // onTap: () async{
              //   bool notiStatus = await NotificationListenerService
              //               .requestPermission();
              //   if(notiStatus == true)
              //   {
              //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              //       content: Text("Permission Is Granted")
              //        ));
              //   }
              //   if(notiStatus == false)
              //   {
              //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              //       content: Text("Permission Is Denied")
              //        ));
              //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              //       content: Text("This Permission is required")
              //        ));
              //     NotificationListenerService
              //               .requestPermission();
              //   }

              // },
              title: const Text("Notification Permission"),
              subtitle: const Text("Status of Permission: "),
            ),
          ],
        ),
      ),
    );
  }
}
