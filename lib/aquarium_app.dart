import 'package:flutter/material.dart';
import 'aquarium_storage.dart'; 
import 'fish.dart';             

class AquariumApp extends StatefulWidget {
  @override
  _AquariumAppState createState() => _AquariumAppState();
}

class _AquariumAppState extends State<AquariumApp> with SingleTickerProviderStateMixin {
  List<Fish> fishList = [];
  Color selectedColor = Colors.blue;
  double selectedSpeed = 2.0;
  late AquariumStorage storage;

  @override
  void initState() {
    super.initState();
    storage = AquariumStorage();      
    storage.initDatabase().then((_) { 
      _loadFishFromStorage();
    });
  }

  // Load fish settings 
  Future<void> _loadFishFromStorage() async {
    List<Fish> loadedFish = await storage.loadFish();
    setState(() {
      fishList = loadedFish;
    });
  }

  // Add new fish 
  void _addFish() {
    if (fishList.length < 10) {
      setState(() {
        fishList.add(Fish(selectedColor, selectedSpeed));
        storage.saveFish(fishList);  // Save settings 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Aquarium")),
        body: Column(
          children: [
            buildAquariumContainer(),
            buildControlPanel(),
            buildSpeedSlider(),
            buildColorDropdown(),
          ],
        ),
      ),
    );
  }

  // aquarium containter
  Widget buildAquariumContainer() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
      ),
      child: Stack(
        children: fishList.map((fish) => FishWidget(fish: fish)).toList(),
      ),
    );
  }

  // control panel
  Widget buildControlPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: _addFish,
          child: Text("Add Fish"),
        ),
        ElevatedButton(
          onPressed: () => storage.saveFish(fishList),
          child: Text("Save Settings"),
        ),
      ],
    );
  }

  //speed slider 
  Widget buildSpeedSlider() {
    return Slider(
      value: selectedSpeed,
      min: 1.0,
      max: 5.0,
      divisions: 4,
      label: selectedSpeed.toString(),
      onChanged: (value) {
        setState(() {
          selectedSpeed = value;
        });
      },
    );
  }

  // color dropdown 
  Widget buildColorDropdown() {
    return DropdownButton<Color>(
      value: selectedColor,
      items: [
        DropdownMenuItem(child: Text("Blue"), value: Colors.blue),
        DropdownMenuItem(child: Text("Red"), value: Colors.red),
        DropdownMenuItem(child: Text("Green"), value: Colors.green),
      ],
      onChanged: (Color? value) {
        setState(() {
          if (value != null) selectedColor = value;
        });
      },
    );
  }
}
