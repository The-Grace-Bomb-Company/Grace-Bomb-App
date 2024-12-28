import 'package:flutter/material.dart';
import 'package:grace_bomb/app_styles.dart';
import 'package:grace_bomb/app_methods.dart';
import 'package:grace_bomb/app_settings.dart';
import 'package:latlong2/latlong.dart';
import 'package:grace_bomb/apis/save_new_bomb.dart';

class NewBombPage extends StatefulWidget {
  final LatLng location;

  const NewBombPage({super.key, required this.location});

  @override
  State<NewBombPage> createState() => _NewBombPageState();
}

class _NewBombPageState extends State<NewBombPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void saveBomb() async {
    final String title = nameController.text.trim().isEmpty
        ? ''
        : AppMethods.createHashtag(nameController.text);

    final String description = descriptionController.text.trim();
    if (title.isNotEmpty && title.length > AppSettings.maxBombTitleLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please pick a name shorter than ${AppSettings.maxBombTitleLength} characters.')),
      );
      return;
    }

    if (description.isNotEmpty &&
        description.length > AppSettings.maxBombStoryLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please write a story shorter than ${AppSettings.maxBombStoryLength} characters.')),
      );
      return;
    }

    // Sending New Bomb Saving request to the API
    final request = SaveNewBombRequest(
      latitude: widget.location.latitude,
      longitude: widget.location.longitude,
      title: title,
      description: description,
      locationName: '', // Temporarily empty
    );

    try {
      await saveNewBomb(request);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bomb saved successfully!")),
      );
      Navigator.pop(context, {
        'title': title,
        'description': description,
        'success': true,
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving bomb: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            //   'Location: ${widget.location.latitude}, ${widget.location.longitude}',
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
