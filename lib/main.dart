import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api_service.dart';
import 'api_models.dart';

void main() {
  runApp(MyApp());
}

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'SIS Mobile App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 228, 107, 102)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

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

    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

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
      body: mainArea,
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

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 25),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(width: 25),
              Text('Rithm 28 / Upcoming / breadcrumbs'),
            ],
          ),
          SizedBox(width: 10),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(width: 25),
              Text('Rithm 28 Upcoming Header'),
            ],
          ),
          SizedBox(width: 10),
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
          SizedBox(width: 10),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(width: 25),
              Text('Course: Sept - February / Course Info'),
            ],
          ),
          SizedBox(width: 10),
          FutureBuilder<List<CurriculumItems>>(
            future: futureCurriculumItems,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                    'Curriculum Items: ${snapshot.data?.length.toString()}');
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),

          // Text('count:' + futureAssessmentSessionList),
          DataTable(columns: const <DataColumn>[
            DataColumn(
              label: Expanded(
                child: Text(
                  'Date',
                  style: TextStyle(),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Title',
                  style: TextStyle(),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Assets',
                  style: TextStyle(),
                ),
              ),
            ),
          ], rows: []),
        ],
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
