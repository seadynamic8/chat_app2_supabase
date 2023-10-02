import 'package:flutter/material.dart';

class UserImagePicker extends StatelessWidget {
  const UserImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 40,
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.image),
          label: const Text('Add Image'),
        ),
      ],
    );
  }
}
