import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(BicycleApp());
}

// Reifendruck vorne hinten fehlt noch 

/*class Bicycle {
  final String brand;
  final String model;
  double pressure;
  double highSpeedRebound;
  double highSpeedDamping;
  double lowSpeedRebound;
  double lowSpeedDamping;
  bool like;
  //List<BicycleSettings> settingsHistory;
  List<ShockSettings> shocksettingsHistory;
  List<ForkSettings> forksettingsHistory;

  Bicycle({
    required this.brand,
    required this.model,
    required this.pressure,
    required this.highSpeedRebound,
    required this.highSpeedDamping,
    required this.lowSpeedRebound,
    required this.lowSpeedDamping,
    this.like = false,
    this.shocksettingsHistory = const [],
    this.forksettingsHistory = const [],
  });
} */

class Bicycle {
  final String brand;
  final String model;
  final BicycleSettings forkSettings; 
  final BicycleSettings shockSettings;
  List<BicycleSettings> settingsHistory;
  

  Bicycle({
    required this.brand,
    required this.model,
    required this.forkSettings,
    required this.shockSettings,
    this.settingsHistory = const [],    
  });
}

class BicycleSettings {
  final DateTime dateTime;
  double pressure;
  double highSpeedRebound;
  double highSpeedDamping;
  double lowSpeedRebound;
  double lowSpeedDamping;
  bool likeSetting;
  String comment;
  bool like;

  BicycleSettings({
    required this.dateTime,
    this.pressure = 0,
    this.highSpeedRebound = 0,
    this.highSpeedDamping = 0,
    this.lowSpeedRebound = 0,
    this.lowSpeedDamping = 0,
    this.likeSetting = false,
    this.comment = '',
    this.like = false,
  });
}

/*
class BicycleSettings {
  final DateTime dateTime;
  final double pressure;
  final double highSpeedRebound;
  final double highSpeedDamping;
  final double lowSpeedRebound;
  final double lowSpeedDamping;
  final bool likeSetting;
  final String comment;

  BicycleSettings({
    required this.dateTime,
    required this.pressure,
    required this.highSpeedRebound,
    required this.highSpeedDamping,
    required this.lowSpeedRebound,
    required this.lowSpeedDamping,
    required this.likeSetting,
    required this.comment,
  });
}*/






class BicycleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bicycle Settings Manager',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: BicycleList(),
    );
  }
}

class BicycleList extends StatefulWidget {
  @override
  _BicycleListState createState() => _BicycleListState();
}

class _BicycleListState extends State<BicycleList> {
  final List<Bicycle> bicycles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bicycle Settings Manager'),
      ),
      body: Center(
        
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: bicycles.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${bicycles[index].brand} ${bicycles[index].model}',style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    //builder: (context) => BicycleDetails(bicycle: bicycles[index]),
                    builder: (context) => SuspensionSettingsScreen(bicycle: bicycles[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addBicycle(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addBicycle(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddBicycleScreen()),
    );

    if (result != null) {
      setState(() {
        bicycles.add(result);
      });
    }
  }
}

class AddBicycleScreen extends StatefulWidget {
  @override
  _AddBicycleScreenState createState() => _AddBicycleScreenState();
}

class _AddBicycleScreenState extends State<AddBicycleScreen> {
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bicycle'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: brandController,
              decoration: InputDecoration(labelText: 'Brand'),
            ),
            TextField(
              controller: modelController,
              decoration: InputDecoration(labelText: 'Model'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveBicycle(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveBicycle(BuildContext context) {
    if (brandController.text.isNotEmpty && modelController.text.isNotEmpty) {
      final newBicycle = Bicycle(
        brand: brandController.text,
        model: modelController.text,
        forkSettings: BicycleSettings(dateTime: DateTime.now()),
        shockSettings: BicycleSettings(dateTime: DateTime.now()),
        /*pressure: 0, // Default value for pressure
        shock_pressure: 0, // Default value for pressure
        fork_HighSpeedDamping: 0, // Default value for high-speed rebound
        fork_LowSpeedDamping: 0, // Default value for high-speed damping
        fork_LowSpeedRebound: 0, // Default value for low-speed rebound
        fork_HighSpeedRebound: 0, // Default value for low-speed damping
        shock_HighSpeedRebound: 0, // Default value for high-speed rebound
        shock_LowSpeedRebound: 0, // Default value for high-speed damping
        shock_LowSpeedDamping: 0, // Default value for low-speed rebound
        shock_HighSpeedDamping: 0, // Default value for low-speed damping
        */
      );

      Navigator.pop(context, newBicycle);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter brand and model.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}


// Select between Fork and Shock 
class SuspensionSettingsScreen extends StatefulWidget {
  final Bicycle bicycle;
  

  SuspensionSettingsScreen({required this.bicycle});

  @override
  _SuspensionSettingsScreenState createState() => _SuspensionSettingsScreenState();
}

class _SuspensionSettingsScreenState extends State<SuspensionSettingsScreen> {
  late BicycleSettings currentSettings;

  late BicycleSettings currentForkSettings;
  late BicycleSettings currentShockSettings;
  
  @override
  void initState() {
    super.initState();
    currentForkSettings = widget.bicycle.forkSettings;
    currentShockSettings = widget.bicycle.shockSettings;
  } 

  // Funktion zum Aktualisieren der Einstellungen
  void updateSettings(BicycleSettings settings) {
    setState(() {
      if (settings == widget.bicycle.forkSettings) {
        currentForkSettings = settings;
      } else if (settings == widget.bicycle.shockSettings) {
        currentShockSettings = settings;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.bicycle.brand} ${widget.bicycle.model} Suspension Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fork Settings', style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 10),
                    Text('Air Pressure: ${widget.bicycle.forkSettings.pressure}'),
                    Text('LSR: ${widget.bicycle.forkSettings.lowSpeedRebound}'),
                    Text('HSR: ${widget.bicycle.forkSettings.highSpeedRebound}'),
                    Text('LSC: ${widget.bicycle.forkSettings.lowSpeedDamping}'),
                    Text('HSC: ${widget.bicycle.forkSettings.highSpeedDamping}'),
                    /*Text('Air Pressure: ${widget.bicycle.fork_pressure}'),
                    Text('LSR: ${widget.bicycle.fork_LowSpeedRebound}'),
                    Text('HSR: ${widget.bicycle.fork_HighSpeedRebound}'),
                    Text('LSC: ${widget.bicycle.fork_LowSpeedDamping}'),
                    Text('HSC: ${widget.bicycle.fork_HighSpeedDamping}'),*/
                    SizedBox(height: 20),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            currentSettings = widget.bicycle.forkSettings;
                            Navigator.push(
                              context,                          
                               MaterialPageRoute(builder: (context) => BicycleDetails(bicycle: widget.bicycle , suspensionSettings: currentForkSettings, updateSettings: updateSettings)),
                              //MaterialPageRoute(builder: (context) => BicycleDetails(bicycle: widget.bicycle , suspensionSettings: currentSettings)),
                            );
                          },
                          child: Text('Adjust Shock Settings'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    
                  ],
                ),
              ),
            ),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rear Shock Settings', style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 10),
                    Text('Air Pressure: ${widget.bicycle.shockSettings.pressure}'),
                    Text('LSR: ${widget.bicycle.shockSettings.lowSpeedRebound}'),
                    Text('HSR: ${widget.bicycle.shockSettings.highSpeedRebound}'),
                    Text('LSC: ${widget.bicycle.shockSettings.lowSpeedDamping}'),
                    Text('HSC: ${widget.bicycle.shockSettings.highSpeedDamping}'),
                    ElevatedButton(
                      onPressed: () {
                        currentSettings = widget.bicycle.shockSettings;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BicycleDetails(bicycle: widget.bicycle , suspensionSettings: currentShockSettings,updateSettings: updateSettings)),
                          //MaterialPageRoute(builder: (context) => BicycleDetails(bicycle: widget.bicycle, suspensionSettings: currentSettings ,)),
                        );
                      },
                      child: Text('Adjust Shock Settings'),
                    ),
                    SizedBox(height: 10),
                    
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                      onPressed: () {
                        _showSettingsHistory(context);
                      },
                      child: Text('View Suspension Settings History'),
                    ),
          ],
        ),
      ),
    );
  }

  void _showSettingsHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsHistoryScreen(settings: widget.bicycle.settingsHistory),
      ),
    );
  }
}

// hier muss noch Federgabel oder Dämpfer übergeben werden 
// Bisheriger Code 
class BicycleDetails extends StatefulWidget {
  final Bicycle bicycle;
  // added for differentation between shock and fork
  final BicycleSettings suspensionSettings;

  // Funktion zum Aktualisieren der Einstellungen
  final Function(BicycleSettings) updateSettings;

  BicycleDetails({required this.bicycle, required this.suspensionSettings,required this.updateSettings});

  @override
  _BicycleDetailsState createState() => _BicycleDetailsState();
}

class _BicycleDetailsState extends State<BicycleDetails> {
  bool highSpeedEnabled = false;
  bool liked = false;
  String comment = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.bicycle.brand}  ${widget.bicycle.model} Suspension Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: 
          <Widget>[
            Text('Pressure: ${widget.suspensionSettings.pressure}'),
            Text('High-Speed Rebound: ${widget.suspensionSettings.highSpeedRebound}'),
            Text('High-Speed Damping: ${widget.suspensionSettings.highSpeedDamping}'),
            Text('Low-Speed Rebound: ${widget.suspensionSettings.lowSpeedRebound}'),
            Text('Low-Speed Damping: ${widget.suspensionSettings.lowSpeedDamping}'),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                _showSettingsDialog(context);
              },
              child: Text('Adjust Settings'),
            ),
            SizedBox(height: 25),
            Row(
              children: [
                IconButton(
                  icon: Icon(liked ? Icons.favorite : Icons.favorite_border),
                  onPressed: () {
                    setState(() {
                      liked = !liked;
                      if (liked) {
                        widget.suspensionSettings.like = true;
                      } else {
                        widget.suspensionSettings.like = false;
                      }
                    });
                  },
                ),
                Text('Do you like this Setting: ${widget.suspensionSettings.like}'),
              ],
            ),
            SizedBox(height: 20), 
            SizedBox(
              width: 500,
              child: 
                TextField(
                //selectionWidthStyle: BoxWidthStyle.values,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Leave a comment',
                  /*labelText: 'Comment'*/),
                onChanged: (value) {
                  setState(() {
                    comment = value;
                  });
                },
              ),
            ),

            
            SizedBox(height: 20), 
            ElevatedButton(
              onPressed: () {
                _saveSettings(context);
                final updatedSettings = widget.suspensionSettings;
                Navigator.pop(context,updatedSettings);
              },
              child: Text('Save to history'),
            ),  
            SizedBox(height: 20),           
            /*ElevatedButton(
              onPressed: () {
                _showSettingsHistory(context);
              },
              child: Text('View History'),
            ),*/
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adjust Suspension Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Pressure'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    widget.suspensionSettings.pressure = double.tryParse(value) ?? 0;
                  });
                },
              ),

                TextField(
                  decoration: InputDecoration(labelText: 'High-Speed Rebound'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      widget.suspensionSettings.highSpeedRebound = double.tryParse(value) ?? 0;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'High-Speed Damping'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      widget.suspensionSettings.highSpeedDamping = double.tryParse(value) ?? 0;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Low-Speed Rebound'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      widget.suspensionSettings.lowSpeedRebound = double.tryParse(value) ?? 0;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Low-Speed Damping'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      widget.suspensionSettings.lowSpeedDamping = double.tryParse(value) ?? 0;
                    });
                  },
                ),
                
              ],

          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);                
              },
              child: Text('Ok'),
            ),
            /*TextButton(
              onPressed: () {
                _saveSettings(context);
                Navigator.pop(context );
              },
              child: Text('Save actual settings to history'),
            ),*/
          ],
        );
      },
    );
  }

  void _saveSettings(BuildContext context) {
    final dateTime = DateTime.now();
    final settings = BicycleSettings(
    dateTime: dateTime,
    pressure: widget.suspensionSettings.pressure,
    highSpeedRebound: widget.suspensionSettings.highSpeedRebound,
    highSpeedDamping: widget.suspensionSettings.highSpeedDamping,
    lowSpeedRebound: widget.suspensionSettings.lowSpeedRebound,
    lowSpeedDamping: widget.suspensionSettings.lowSpeedDamping,
    likeSetting: widget.suspensionSettings.like,

    /*pressure: widget.bicycle.pressure,
    highSpeedRebound: widget.bicycle.highSpeedRebound,
    highSpeedDamping: widget.bicycle.highSpeedDamping,
    lowSpeedRebound: widget.bicycle.lowSpeedRebound,
    lowSpeedDamping: widget.bicycle.lowSpeedDamping,
    likeSetting: widget.bicycle.like,*/
    comment: comment,
    
    );

    setState(() {   
      widget.updateSettings(widget.suspensionSettings); // Aufruf der Update-Funktion
      //widget.bicycle.forkSettings.pressure =  widget.suspensionSettings.pressure;
      widget.bicycle.settingsHistory = [...widget.bicycle.settingsHistory,settings];
    });
  }

  // implementieren das man in Historie sieht ob Gabel oder Dämpfer verändert wurde
  void _showSettingsHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsHistoryScreen(settings: widget.bicycle.settingsHistory),
      ),
    );
  }
}

class SettingsHistoryScreen extends StatelessWidget {
  final List<BicycleSettings> settings;

  SettingsHistoryScreen({required this.settings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings History'),
      ),
      body: ListView.builder(
        itemCount: settings.length,
        itemBuilder: (context, index) {
          final setting = settings[index];
          return ListTile(
            title: Text('Date: ${setting.dateTime.toString()}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Pressure: ${setting.pressure}'),
                Text('High-Speed Rebound: ${setting.highSpeedRebound}'),
                Text('High-Speed Damping: ${setting.highSpeedDamping}'),
                Text('Low-Speed Rebound: ${setting.lowSpeedRebound}'),
                Text('Low-Speed Damping: ${setting.lowSpeedDamping}'),
                Text('Setting was good: ${setting.likeSetting}'),
                Text('Comment: ${setting.comment}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
