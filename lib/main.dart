import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(BicycleApp());
}

// Reifendruck vorne hinten fehlt noch 



class Bicycle {
  final String brand;
  final String model;
  final SuspensionSettings forkSettings; 
  final SuspensionSettings shockSettings;
  List<SuspensionSettings> forksettingsHistory;
  List<SuspensionSettings> shocksettingsHistory;
  

  Bicycle({
    required this.brand,
    required this.model,
    required this.forkSettings,
    required this.shockSettings,
    this.forksettingsHistory = const [], 
    this.shocksettingsHistory = const [],   
  });
}

class SuspensionSettings {
  final DateTime dateTime;
  double pressure;
  double highSpeedRebound;
  double highSpeedDamping;
  double lowSpeedRebound;
  double lowSpeedDamping;
  bool likeSetting;
  String comment;
  bool like;

  SuspensionSettings({
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



String getLikeSettingDisplay(bool likeSetting) {
  return likeSetting ? 'Yes' : 'No';
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
        forkSettings: SuspensionSettings(dateTime: DateTime.now()),
        shockSettings: SuspensionSettings(dateTime: DateTime.now()), );

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
  late SuspensionSettings currentSettings;

  late SuspensionSettings currentForkSettings;
  late SuspensionSettings currentShockSettings;

  
  
  @override
  void initState() {
    super.initState();
    currentForkSettings = widget.bicycle.forkSettings;
    currentShockSettings = widget.bicycle.shockSettings;
  } 

  // Funktion zum Aktualisieren der Einstellungen
  void updateSettings(SuspensionSettings settings) {
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
              currentSettings = widget.bicycle.shockSettings;
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
        builder: (context) => SuspensionHistoryScreen(forkSettingsHistory: widget.bicycle.forksettingsHistory,shockSettingsHistory: widget.bicycle.shocksettingsHistory),
      ),
    );
  }
}

// hier muss noch Federgabel oder Dämpfer übergeben werden 
// Bisheriger Code 
class BicycleDetails extends StatefulWidget {
  final Bicycle bicycle;
  final SuspensionSettings suspensionSettings;
  final Function(SuspensionSettings) updateSettings;

  BicycleDetails({required this.bicycle, required this.suspensionSettings, required this.updateSettings});

  @override
  _BicycleDetailsState createState() => _BicycleDetailsState();
}

class _BicycleDetailsState extends State<BicycleDetails> {
  final TextEditingController commentController = TextEditingController();
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
                Text('Do you like this Setting: ${getLikeSettingDisplay(widget.suspensionSettings.like)}'),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: commentController,
              decoration: InputDecoration(labelText: 'Comment'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveSettings();
              },
              child: Text('Save to history'),
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
    final comment = commentController.text;
    final dateTime = DateTime.now();
    final settings = SuspensionSettings(
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
    //widget.bicycle.settingsHistory = [...widget.bicycle.settingsHistory, settings];
     if (widget.suspensionSettings == widget.bicycle.forkSettings) {
      widget.bicycle.forksettingsHistory = [...widget.bicycle.forksettingsHistory, settings];
      } else if (widget.suspensionSettings == widget.bicycle.shockSettings) {
      widget.bicycle.shocksettingsHistory = [...widget.bicycle.shocksettingsHistory, settings];
     }

    Navigator.pop(context, widget.suspensionSettings);
  }   

    
}



class SuspensionHistoryScreen extends StatefulWidget {
  final List<SuspensionSettings> forkSettingsHistory;
  final List<SuspensionSettings> shockSettingsHistory;

  SuspensionHistoryScreen({
    required this.forkSettingsHistory,
    required this.shockSettingsHistory,
  });

  @override
  _SuspensionHistoryScreenState createState() => _SuspensionHistoryScreenState();
}

class _SuspensionHistoryScreenState extends State<SuspensionHistoryScreen> {
  List<String> _filters = ['All', 'Fork', 'Shock'];
  String _selectedFilter = 'All'; // 'All', 'Fork', 'Shock'

  /*List<SuspensionSettings> getFilteredSettings() {
    if (_selectedFilter == 'Fork') {
      return widget.forkSettingsHistory;
    } else if (_selectedFilter == 'Shock') {
      return widget.shockSettingsHistory;
    } else {
      return [...widget.forkSettingsHistory, ...widget.shockSettingsHistory];
    }
  }*/ 
  
  List<SuspensionSettings> getFilteredSettings() {
  if (_selectedFilter == 'Fork') {
    return widget.forkSettingsHistory;
  } else if (_selectedFilter == 'Shock') {
    return widget.shockSettingsHistory;
  } else {
    if (_selectedFilter == 'All') {
      // Wenn der Filter "All" ist, kombinieren Sie die Gabel- und Stoßdämpfereinstellungen nicht.
      List<SuspensionSettings> allSettings = [];
      allSettings.addAll(widget.forkSettingsHistory);
      allSettings.addAll(widget.shockSettingsHistory);
      return allSettings;
      
    }
  }  
      throw Exception() ;  
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suspension Settings History'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _filters.map((filter) {
                return FilterChip(
                  label: Text(filter),
                  selected: _selectedFilter == filter,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          Expanded(
  child: ListView.builder(
    itemCount: getFilteredSettings().length,
    itemBuilder: (context, index) {
      final setting = getFilteredSettings()[index];
      return ListTile(
        title: Text('Date: ${setting.dateTime.toString()}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if ((_selectedFilter == 'All' || _selectedFilter == 'Fork') && widget.forkSettingsHistory.contains(setting)) ...[
              Text('Fork Settings:'),
              Text('Pressure: ${setting.pressure}'),
              Text('High-Speed Rebound: ${setting.highSpeedRebound}'),
              Text('High-Speed Damping: ${setting.highSpeedDamping}'),
              Text('Low-Speed Rebound: ${setting.lowSpeedRebound}'),
              Text('Low-Speed Damping: ${setting.lowSpeedRebound}'),
              //Text('Fork Setting was good: ${setting.likeSetting}'),
              Text('Fork Setting was good: ${getLikeSettingDisplay(setting.likeSetting)}'),
              Text('Fork Comment: ${setting.comment}'),
              SizedBox(height: 10),
            ],
            if ((_selectedFilter == 'All' || _selectedFilter == 'Shock') && widget.shockSettingsHistory.contains(setting)) ...[
              Text('Shock Settings:'),
              Text('Pressure: ${setting.pressure}'),
              Text('High-Speed Rebound: ${setting.highSpeedRebound}'),
              Text('High-Speed Damping: ${setting.highSpeedDamping}'),
              Text('Low-Speed Rebound: ${setting.lowSpeedRebound}'),
              Text('Low-Speed Damping: ${setting.lowSpeedDamping}'),
              Text('Fork Setting was good: ${getLikeSettingDisplay(setting.likeSetting)}'),
              Text('Shock Comment: ${setting.comment}'),
              SizedBox(height: 10),
            ],
          ],
        ),
      );
    },
  ),
),
        ],
      ),
    );
  }
}

