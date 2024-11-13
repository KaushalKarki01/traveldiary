import 'package:flutter/material.dart';
import 'package:traveldiary/components/travel_card.dart';
import 'package:traveldiary/database/local/database_helper.dart';
import 'package:traveldiary/model/travel_destination.dart';
import 'package:traveldiary/screens/travel_description_note_screen.dart';
import 'package:traveldiary/screens/travel_detail_screen.dart';

class DemoHomeScreen extends StatefulWidget {
  const DemoHomeScreen({super.key});

  @override
  State<DemoHomeScreen> createState() => _DemoHomeScreenState();
}

class _DemoHomeScreenState extends State<DemoHomeScreen> {
  final DBHelper dbHelper = DBHelper.getInstance;
  List<TravelDestination> destinations = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadDestinations();
  }

  //fetch destinations
  Future<void> _loadDestinations() async {
    final data = await dbHelper.getEntries();
    setState(() {
      destinations = data;
    });
  }

  //navigate to formscreen and refresh on return
  Future<void> _navigateToNoteScreen() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TravelDescriptionNoteScreen(),
        ));
    _loadDestinations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TRAVEL DIARY',
        ),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      body: destinations.isNotEmpty
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0),
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final destination = destinations[index];
                return TravelCard(
                    destination: destination,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TravelDetailScreen(
                                title: destination.title,
                                description: destination.desc,
                                onDelete: () {}),
                          ));
                      print(destination.desc);
                    });
              },
            )
          : const Center(
              child: Text('No Destinations Added Yet...'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNoteScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
