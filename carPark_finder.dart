import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
const String baseUrl = 'http://localhost:3000';

void main() {
  runApp(MaterialApp(
    home: CarParkApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class CarPark {
  final String name;
  final String? carSpaces;
  final String? motorcycleSpaces;
  final String? disabledSpaces;
  final String? electricVehicleSpaces;
  final String? electricMotorcycleSpaces;

  CarPark({
    required this.name, 
    required this.carSpaces, 
    required this.motorcycleSpaces,
    required this.disabledSpaces,
    required this.electricVehicleSpaces,
    required this.electricMotorcycleSpaces});

  factory CarPark.fromJson(Map<String, dynamic> json) {
    return CarPark(
      name: (json['name'] ?? 'No Name').toString(),
      carSpaces: (json['carSpaces'] ?? 'null').toString(),
      motorcycleSpaces: (json['motorcycleSpaces'] ?? 'null').toString(),
      disabledSpaces: (json['disabledSpaces'] ?? 'null').toString(),
      electricVehicleSpaces: (json['electricVehicleSpaces'] ?? 'null').toString(),
      electricMotorcycleSpaces: (json['electricMotorcycleSpaces'] ?? 'null').toString(),
    );
  }
}

class CarParkApp extends StatefulWidget {
  @override
  _CarParkAppState createState() => _CarParkAppState();
}

class _CarParkAppState extends State<CarParkApp> {
  List<CarPark> _carParks = [];
  List<CarPark> _filteredCarParks = [];
  TextEditingController searchController = TextEditingController();

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/carpark/vacancy'),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        final List<dynamic> jsonList = decodedData['data'];
        setState(() {
          _carParks = jsonList.map((item) => CarPark.fromJson(item)).toList();
          _filteredCarParks = _carParks;
        });
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print("CONNECTION ERROR: $e");
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $e')),
      );
    }
  }

  void _filterSearchResults(String query) {
  setState(() {
    _filteredCarParks = _carParks
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Park Finder'),
        actions: [
          IconButton(
            onPressed: fetchPosts,
            icon: Icon(Icons.cached),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) => _filterSearchResults(value),
              decoration: InputDecoration(labelText: 'What car parks are you looking for?'),
            ),),
            Expanded(
              child:
                ListView.builder(
                  itemCount: _filteredCarParks.length,
                  itemBuilder: (context, index) {
                    final carPark = _filteredCarParks[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(carPark.name, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Spaces: ${carPark.carSpaces}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CarParkDetails(carPark: carPark),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
            )
          ],
        ),
      )
    );
  }
}

class CarParkDetails extends StatelessWidget {
  final CarPark carPark;

  CarParkDetails({required this.carPark});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(carPark.name)),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${carPark.name}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Available Spaces: ${carPark.carSpaces}', style: TextStyle(fontSize: 16, color: Colors.blue)),
            SizedBox(height: 10),
            Text('Motorcycle Spaces: ${carPark.motorcycleSpaces}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Disabled Spaces: ${carPark.disabledSpaces}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Electric Vehicle Spaces: ${carPark.electricVehicleSpaces}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Electric Motorcycle Spaces: ${carPark.electricMotorcycleSpaces}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
