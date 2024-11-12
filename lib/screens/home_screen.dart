// 1.7.10

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traveldiary/components/travel_card.dart';
import 'package:traveldiary/database/local/database_helper.dart';
import 'package:traveldiary/model/travel_destination.dart';
import 'package:traveldiary/screens/travel_description_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper dbRef = DBHelper.getInstance;
  // TEXT EDITING CONTROLLERS
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  //IMAGE PICKER
  String? _imagePath;
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  // ADD ENTRY IN DATABASE
  Future<void> _saveEntry() async {
    if (_titleController.text.isNotEmpty &&
        _descController.text.isNotEmpty &&
        _imagePath != null) {
      // TravelEntry newEntry = TravelEntry(
      //     title: _titleController.text,
      //     desc: _descController.text,
      //     img: _imagePath);

      //updated code
      final now = DateTime.now();
      TravelDestination newDestination = TravelDestination(
          title: _titleController.text,
          desc: _descController.text,
          createdAt: now,
          updatedAt: now);

      await dbRef.insertEntry(newDestination);
      clearControllers();
      setState(() {
        _imagePath = null;
      });
    }
  }

  // FETCH THE RECORDS FROM DB
  Future<List<TravelDestination>> fetchEntries() async {
    return await dbRef.getEntries();
  }

  // DELETE THE RECORD FROM DB
  Future<void> deleteEntry(TravelDestination destination) async {
    await dbRef.deleteEntry(destination);
  }

  // CLEAR CONTROLLERS
  void clearControllers() {
    _titleController.clear();
    _descController.clear();
    setState(() {
      _imagePath = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MY TRAVEL DIARY'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder(
          future: fetchEntries(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text(
                      'Begin your travel journey by pressing the + button.'));
            } else {
              final destinations = snapshot.data!;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: destinations.length,
                itemBuilder: (context, index) {
                  final destination = destinations[index];

                  // return TravelCard(
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => TravelDetailScreen(
                  //             path: entry.img!,
                  //             title: entry.title,
                  //             description: entry.desc,
                  //             onDelete: () => deleteEntry(entry),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //     path: entry.img!,
                  //     title: entry.title);
                  return TravelCard(destination: destination, onTap: () {});
                },
              );
            }
          },
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showModalBottomSheet(
          //   isScrollControlled: true,
          //   context: context,
          //   builder: (context) => _showModalSheetBottom(),
          // );

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TravelDescriptionNoteScreen(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // BOTTOM MODAL SHEET
  // Widget _showModalSheetBottom() {
  //   return Container(
  //     padding: const EdgeInsets.all(14.0),
  //     width: double.infinity,
  //     child: Column(
  //       children: [
  //         const SizedBox(height: 30),
  //         Text('ADD YOUR TRAVEL MEMORY',
  //             style: Theme.of(context).textTheme.titleMedium),
  //         const SizedBox(height: 20),
  //         CTextField(
  //           controller: _titleController,
  //           label: 'Title',
  //           hintText: 'Where did you travel',
  //         ),
  //         const SizedBox(height: 10),
  //         CTextField(
  //           maxLines: 10,
  //           controller: _descController,
  //           label: 'Describe',
  //           hintText: 'Describe the place',
  //         ),
  //         const SizedBox(height: 10),
  //         ElevatedButton(
  //           onPressed: () {
  //             showDialog(
  //               context: context,
  //               builder: (context) => AlertDialog(
  //                 title: const Text('Select Souce'),
  //                 content: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     TextButton.icon(
  //                       onPressed: () async {
  //                         await pickImage();
  //                         Navigator.pop(context);
  //                       },
  //                       icon: const Icon(Icons.image),
  //                       label: const Text('Gallery'),
  //                     ),
  //                     TextButton.icon(
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                       },
  //                       icon: const Icon(Icons.camera),
  //                       label: const Text('Camera'),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //           child: const Text('Pick Image'),
  //         ),
  //         const SizedBox(height: 10),
  //         _imagePath != null && _imagePath!.isNotEmpty
  //             ? SizedBox(
  //                 width: 150,
  //                 height: 150,
  //                 child: Image.file(
  //                   File(_imagePath!),
  //                   fit: BoxFit.cover,
  //                 ))
  //             : const SizedBox(height: 20),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             OutlinedButton.icon(
  //               onPressed: () async {
  //                 await _saveEntry();
  //                 clearControllers();
  //                 Navigator.pop(context);
  //               },
  //               label: const Text('Save'),
  //               icon: const Icon(Icons.save),
  //             ),
  //             const SizedBox(width: 20),
  //             OutlinedButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 clearControllers();
  //               },
  //               child: const Text('Cancel'),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
