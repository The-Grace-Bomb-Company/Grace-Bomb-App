import 'package:flutter/material.dart';
import 'package:grace_bomb/app_styles.dart';
import 'package:grace_bomb/app_methods.dart';
import 'package:grace_bomb/app_settings.dart';
import 'package:latlong2/latlong.dart';

class NewBombPage extends StatelessWidget {
  final LatLng location;

  const NewBombPage({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    void saveBomb() {
      final String title = nameController.text.trim().isEmpty
          ? ''
          : AppMethods.createHashtag(nameController.text);

      final String description = descriptionController.text.trim();

      if (title.isNotEmpty && title.length > AppSettings.maxBombTitleLength) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Please pick a name shorter than ${AppSettings.maxBombTitleLength} symbols.')),
        );
        return;
      }

      if (description.isNotEmpty &&
          title.length > AppSettings.maxBombStoryLength) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Please write a strory shorter than ${AppSettings.maxBombStoryLength} symbols.')),
        );
        return;
      }

      // Simulate sending to API
      final bombData = {
        'latitude': location.latitude,
        'longitude': location.longitude,
        'title': title,
        'description': description,
      };

      // TEST DEBUG
      print('latitude: ${location.latitude}');
      print('longitude: ${location.longitude}');
      print('title: --$title--');
      print('desc: --$description--');
      // API CALL -->!!!

      // TODO after success
      // go to previous page and show bomb added - explosion and animation!
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saved")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('NEW GRACE BOMB', maxLines: 1, style: AppStyles.heading),
        backgroundColor: const Color(0xFFE85124),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16.0),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Text(
            //   'Location: ${location.latitude}, ${location.longitude}',
            //   textAlign: TextAlign.center,
            // ),
            const SizedBox(height: 16.0),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Give your bomb a #Name (optional)',
                hintText: 'No spaces and rather short (skip the #)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Story is optional, but it is fun to hear it!',
                hintText: 'Share your story here',
                border: OutlineInputBorder(),
              ),
              maxLines: 5, // Multi-line input
            ),
            const SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: saveBomb,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE85124),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text('SAVE', maxLines: 1, style: AppStyles.heading),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
