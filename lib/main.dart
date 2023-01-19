// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/services/api_service.dart';
import 'models/curriculum-items.dart';

void main() {
  runApp(MyApp());
}

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
        padding: const EdgeInsets.all(32),
        child: Row(
          children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: const Text(
                        'Rithm 28 / Upcoming / Breadcrumbs',
                        style: TextStyle(
                          color: Color.fromARGB(255, 160, 159, 159),
                        ),
                      ),
                    ),
                    Text(
                      'Rithm 28 Header',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ]),
            )
          ],
        ));
    Column _buildButtonColumn(Color color, IconData icon, String label) {
      return Column(children: [
        ElevatedButton.icon(
          onPressed: () {
            print('Pressed button $label');
          },
          icon: Icon(icon, color: color),
          label: Text(label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w400, fontSize: 12)),
        ),
      ]);
    }

    //  ElevatedButton.icon(
    //           onPressed: () {
    //             print("pressed button 2");
    //           },
    //           icon: Icon(Icons.videocam),
    //           label: Text('Video meeting'),
    //         ),

    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(color, Icons.calendar_month, 'CALENDAR'),
        _buildButtonColumn(color, Icons.videocam, 'ZOOM'),
      ],
    );

    return MaterialApp(
      title: 'SIS Mobile App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 228, 107, 102)),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('{R} Rithm'),
        ),
        body: ListView(
          children: [titleSection, buttonSection],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    String dropdownValue = list.first;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = CohortDetailPage();
        break;
      case 1:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rithm SIS Mobile'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {},
              tooltip: 'Show homepage'),
          // IconButton(
          //     icon: const Icon(Icons.dehaze_outlined),
          //     onPressed: () {},
          //     tooltip: 'Show homepage'),
          DropdownButton(
              value: dropdownValue,
              icon: const Icon(Icons.dehaze_outlined),
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
              }),
        ],
      ),
      body: CohortDetailPage(),
    );
  }
}

class CohortDetailPage extends StatefulWidget {
  @override
  State<CohortDetailPage> createState() => _CohortDetailPageState();
}

class _CohortDetailPageState extends State<CohortDetailPage> {
  late Future<List<CurriculumItems>> futureCurriculumItems;

  @override
  void initState() {
    super.initState();
    futureCurriculumItems = fetchCurriculumItems();
  }

  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(width: 25),
            Text('Rithm 28 / Upcoming / breadcrumbs'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(width: 25),
            Text('Rithm 28 Upcoming Header'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(width: 25),
            ElevatedButton.icon(
              onPressed: () {
                print("pressed button 1");
              },
              icon: Icon(Icons.calendar_month),
              label: Text('Calendar'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                print("pressed button 2");
              },
              icon: Icon(Icons.videocam),
              label: Text('Video meeting'),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(width: 25),
            Text('Course: Sept - February / Course Info'),
          ],
        ),
        FutureCurric(futureCurriculumItems: futureCurriculumItems),
      ],
    );
  }
}

class FutureCurric extends StatelessWidget {
  const FutureCurric({
    Key? key,
    required this.futureCurriculumItems,
  }) : super(key: key);

  final Future<List<CurriculumItems>> futureCurriculumItems;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CurriculumItems>>(
      future: futureCurriculumItems,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
              padding: const EdgeInsets.all(5),
              child:
                  DataClass(datalist: snapshot.data as List<CurriculumItems>));
          // return Text(
          //     'Curriculum Items: ${snapshot.data?.length.toString()}');
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class DataClass extends StatelessWidget {
  const DataClass({Key? key, required this.datalist}) : super(key: key);
  final List<CurriculumItems> datalist;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: FittedBox(
        child: DataTable(
          sortColumnIndex: 1,
          showCheckboxColumn: false,
          // border: TableBorder.all(width: .5),
          columns: const [
            DataColumn(
              label: Text(
                "Date",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                "Title",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                "Assets",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: datalist
              .map(
                (data) => DataRow(
                  cells: [
                    DataCell(
                      Text(
                        data.startDate.toString(),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                    DataCell(
                      Text(
                        data.title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                    DataCell(
                      Text(
                        data.type.toString(),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}




/// =======
///     //   body: LayoutBuilder(
    //     builder: (context, constraints) {
    //       if (constraints.maxWidth < 450) {
    //         // Use a more mobile-friendly layout with BottomNavigationBar
    //         // on narrow screens.
    //         return Column(
    //           children: [
    //             Expanded(child: mainArea),
    //             SafeArea(
    //               child:
    //               // child: BottomNavigationBar(
    //               //   items: [
    //               //     BottomNavigationBarItem(
    //               //       icon: Icon(Icons.home),
    //               //       label: 'Home',
    //               //     ),
    //               //     BottomNavigationBarItem(
    //               //       icon: Icon(Icons.favorite),
    //               //       label: 'Favorites',
    //               //     ),
    //               //   ],
    //               //   currentIndex: selectedIndex,
    //               //   onTap: (value) {
    //               //     setState(() {
    //               //       selectedIndex = value;
    //               //     });
    //               //   },
    //               // ),
    //             )
    //           ],
    //         );
    //       // } else {
    //       //   return Row(
    //       //     children: [
    //       //       SafeArea(
    //       //         child: NavigationRail(
    //       //           extended: constraints.maxWidth >= 600,
    //       //           destinations: [
    //       //             NavigationRailDestination(
    //       //               icon: Icon(Icons.home),
    //       //               label: Text('Home'),
    //       //             ),
    //       //             NavigationRailDestination(
    //       //               icon: Icon(Icons.favorite),
    //       //               label: Text('Favorites'),
    //       //             ),
    //       //           ],
    //       //           selectedIndex: selectedIndex,
    //       //           onDestinationSelected: (value) {
    //       //             setState(() {
    //       //               selectedIndex = value;
    //       //             });
    //       //           },
    //       //         ),
    //       //       ),
    //       //       Expanded(child: mainArea),
    //       //     ],
    //       //   );
    //       }
    //     },
    //   ),
    // );
    // }
