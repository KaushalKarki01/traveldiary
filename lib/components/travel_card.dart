import 'dart:io';

import 'package:flutter/material.dart';
import 'package:traveldiary/model/travel_destination.dart';

class TravelCard extends StatelessWidget {
  final TravelDestination destination;
  final void Function() onTap;
  const TravelCard({super.key, required this.destination, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black45, width: 2.0),
          borderRadius: BorderRadius.circular(16.0),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          children: [
            Flexible(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                child: destination.mediaPaths != null &&
                        destination.mediaPaths!.isNotEmpty &&
                        File(destination.mediaPaths![0]).existsSync()
                    ? Image.file(
                        File(destination.mediaPaths![0]),
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/default_img.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/default_img.jpg', //default image
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              destination.title.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
