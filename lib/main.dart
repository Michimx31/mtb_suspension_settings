import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(BicycleApp());
}

// Reifendruck vorne hinten fehlt noch 



class Bicycle {
  final String brand;
  final String model;
  final BicycleSettings forkSettings; 
  final BicycleSettings shockSettings;
  List<BicycleSettings> forkSettingsHistory;
  List<BicycleSettings> shockSettingsHistory;
  

  Bicycle({
    required this.brand,
    required this.model,
    required this.forkSettings,
    required this.shockSettings,
    this.forkSettingsHistory = const [],    
    this.shockSettingsHistory = const [],
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
        shockSettings: BicycleSettings(dateTime: DateTime.now()), );

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
            InkWell(
              child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fork Settings', style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 10),
                    Text('Air Pressure: ${widget.bicycle.forkSettings.pressure} psi'),
                    Text('LSR: ${widget.bicycle.forkSettings.lowSpeedRebound} clicks'),
                    Text('HSR: ${widget.bicycle.forkSettings.highSpeedRebound} clicks'),
                    Text('LSC: ${widget.bicycle.forkSettings.lowSpeedDamping} clicks'),
                    Text('HSC: ${widget.bicycle.forkSettings.highSpeedDamping} clicks'),
                                                                                                  
                    SizedBox(height: 10),
                    
                  ],
                ),
              ),
            ),
            onTap: (){
              currentSettings = widget.bicycle.forkSettings;
                            Navigator.push(
                              context,                          
                               MaterialPageRoute(builder: (context) => BicycleDetails(bicycle: widget.bicycle , suspensionSettings: currentForkSettings, updateSettings: updateSettings)),
                              );
                          },                      
            ),        
            InkWell(
              child:
                Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Shock Settings', style: Theme.of(context).textTheme.headline6),
                      SizedBox(height: 10),
                      Text('Air Pressure: ${widget.bicycle.shockSettings.pressure} psi'),
                      Text('LSR: ${widget.bicycle.shockSettings.lowSpeedRebound} clicks'),
                      Text('HSR: ${widget.bicycle.shockSettings.highSpeedRebound} clicks'),
                      Text('LSC: ${widget.bicycle.shockSettings.lowSpeedDamping} clicks'),
                      Text('HSC: ${widget.bicycle.shockSettings.highSpeedDamping} clicks'),
                      
                      SizedBox(height: 10),
                      
                    ],
                  ),
                ),
              ), 
              onTap: (){
              currentSettings = widget.bicycle.forkSettings;
                            Navigator.push(
                              context,                          
                               MaterialPageRoute(builder: (context) => BicycleDetails(bicycle: widget.bicycle , suspensionSettings: currentShockSettings, updateSettings: updateSettings)),
                                                          );
                          },  
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
        builder: (context) => SettingsHistoryScreen(forkSettings: widget.bicycle.forkSettingsHistory,shockSettings: [widget.bicycle.shockSettings],),
      ),
    );
  }
}

// hier muss noch Federgabel oder Dämpfer übergeben werden 
// Bisheriger Code 
class BicycleDetails extends StatefulWidget {
  final Bicycle bicycle;
  final BicycleSettings suspensionSettings;
  final Function(BicycleSettings) updateSettings;

  BicycleDetails({required this.bicycle, required this.suspensionSettings, required this.updateSettings});

  @override
  _BicycleDetailsState createState() => _BicycleDetailsState();
}

class _BicycleDetailsState extends State<BicycleDetails> {
  bool liked = false;
  String comment = '';

  late double pressureValue;
  late double highSpeedReboundValue;
  late double highSpeedDampingValue;
  late double lowSpeedReboundValue;
  late double lowSpeedDampingValue;

  @override
  void initState() {
    super.initState();
    pressureValue = widget.suspensionSettings.pressure;
    highSpeedReboundValue = widget.suspensionSettings.highSpeedRebound;
    highSpeedDampingValue = widget.suspensionSettings.highSpeedDamping;
    lowSpeedReboundValue = widget.suspensionSettings.lowSpeedRebound;
    lowSpeedDampingValue = widget.suspensionSettings.lowSpeedDamping;
  }

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
          children: <Widget>[
            _buildSettingRow('Pressure', pressureValue, (value) {
              setState(() {
                pressureValue = value;
                widget.suspensionSettings.pressure = value;
              });
            }),
            _buildSettingRow('High-Speed Rebound', highSpeedReboundValue, (value) {
              setState(() {
                highSpeedReboundValue = value;
                widget.suspensionSettings.highSpeedRebound = value;
              });
            }),
            _buildSettingRow('High-Speed Damping', highSpeedDampingValue, (value) {
              setState(() {
                highSpeedDampingValue = value;
                widget.suspensionSettings.highSpeedDamping = value;
              });
            }),
            _buildSettingRow('Low-Speed Rebound', lowSpeedReboundValue, (value) {
              setState(() {
                lowSpeedReboundValue = value;
                widget.suspensionSettings.lowSpeedRebound = value;
              });
            }),
            _buildSettingRow('Low-Speed Damping', lowSpeedDampingValue, (value) {
              setState(() {
                lowSpeedDampingValue = value;
                widget.suspensionSettings.lowSpeedDamping = value;
              });
            }),
            SizedBox(height: 25),
            Row(
              children: [
                IconButton(
                  icon: Icon(liked ? Icons.favorite : Icons.favorite_border),
                  onPressed: () {
                    setState(() {
                      liked = !liked;
                      widget.suspensionSettings.like = liked;
                    });
                  },
                ),
                Text('Do you like this Setting: ${widget.suspensionSettings.like}'),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: TextEditingController(text: comment),
              decoration: InputDecoration(
                labelText: 'Leave a comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  comment = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveSettings();
              },
              child: Text('Save Settings'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(String label, double value, Function(double) onChanged) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
        ),
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            setState(() {
              value -= 1;
              if (value < 0) value = 0;
              onChanged(value);
            });
          },
        ),
        Text(value.toString(), style: TextStyle(fontSize: 16)),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              value += 1;
              onChanged(value);
            });
          },
        ),
      ],
    );
  }

  void _saveSettings() {
  final dateTime = DateTime.now();
  final settings = BicycleSettings(
    dateTime: dateTime,
    pressure: widget.suspensionSettings.pressure,
    highSpeedRebound: widget.suspensionSettings.highSpeedRebound,
    highSpeedDamping: widget.suspensionSettings.highSpeedDamping,
    lowSpeedRebound: widget.suspensionSettings.lowSpeedRebound,
    lowSpeedDamping: widget.suspensionSettings.lowSpeedDamping,
    likeSetting: widget.suspensionSettings.like,
    comment: comment,
  );

  widget.updateSettings(widget.suspensionSettings);

  if (widget.suspensionSettings == widget.bicycle.forkSettings) {
    widget.bicycle.forkSettingsHistory = [...widget.bicycle.forkSettingsHistory, settings];
  } else if (widget.suspensionSettings == widget.bicycle.shockSettings) {
    widget.bicycle.shockSettingsHistory = [...widget.bicycle.shockSettingsHistory, settings];
  }

  Navigator.pop(context, widget.suspensionSettings);
}
}



class SettingsHistoryScreen extends StatelessWidget {
  final List<BicycleSettings> forkSettings;
  final List<BicycleSettings> shockSettings;

  SettingsHistoryScreen({required this.forkSettings, required this.shockSettings});

  @override
  Widget build(BuildContext context) {
    final itemCount = forkSettings.length < shockSettings.length ? forkSettings.length : shockSettings.length;
    int maxItemCount = max(forkSettings.length, shockSettings.length);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings History'),
      ),
      body: ListView.builder(
        
        itemCount: maxItemCount,
        
        itemBuilder: (context, index) {
          final forkSetting = forkSettings[index];
          final shockSetting = shockSettings[index];
          return ListTile(
            title: Text('Date: ${forkSetting.dateTime.toString().substring(0,19)}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Fork Settings', style: Theme.of(context).textTheme.headline6),
                Text('Pressure: ${forkSetting.pressure}'),
                Text('High-Speed Rebound: ${forkSetting.highSpeedRebound}'),
                Text('High-Speed Damping: ${forkSetting.highSpeedDamping}'),
                Text('Low-Speed Rebound: ${forkSetting.lowSpeedRebound}'),
                Text('Low-Speed Damping: ${forkSetting.lowSpeedDamping}'),
                Text('Setting was good: ${forkSetting.likeSetting}'),
                Text('Comment: ${forkSetting.comment}'),
                Divider(),
                Text('Shock Settings', style: Theme.of(context).textTheme.headline6),
                Text('Date: ${shockSetting.dateTime.toString().substring(0,19)}'),
                Text('Pressure: ${shockSetting.pressure}'),
                Text('High-Speed Rebound: ${shockSetting.highSpeedRebound}'),
                Text('High-Speed Damping: ${shockSetting.highSpeedDamping}'),
                Text('Low-Speed Rebound: ${shockSetting.lowSpeedRebound}'),
                Text('Low-Speed Damping: ${shockSetting.lowSpeedDamping}'),
                Text('Setting was good: ${shockSetting.likeSetting}'),
                Text('Comment: ${shockSetting.comment}'),
              ],
            ),
          );
        },
      ),
    );
  }
}