import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
// import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'services/api_service.dart';
import 'models/curriculum-items.dart';
import 'models/cohort.dart';

Future main() async {
  await dotenv.load();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: const Text(
                        'Rithm 28 / Upcoming',
                        style: TextStyle(
                          color: Color.fromARGB(255, 160, 159, 159),
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Rithm r28 ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                        Text(
                          'Upcoming',
                          style: TextStyle(
                            color: Color.fromARGB(255, 124, 122, 122),
                            fontSize: 25,
                          ),
                        ),
                      ],
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 228, 107, 102),
        ),
        textTheme: GoogleFonts.sourceSerifProTextTheme(),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('{R} Rithm'),
          centerTitle: false,
          actions: [
            IconButton(
              icon: Icon(Icons.dehaze),
              tooltip: "Menu",
              onPressed: () {
                print('Pressed button Menu');
              },
            )
          ],
        ),
        body: ListView(
          children: [titleSection, buttonSection, CohortDetailPage()],
        ),
      ),
    );
  }
}

class CohortDetailPage extends StatefulWidget {
  @override
  State<CohortDetailPage> createState() => _CohortDetailPageState();
}

class _CohortDetailPageState extends State<CohortDetailPage> {
  late Future<List<CurriculumItems>> futureCurriculumItems;
  late Future<Cohort> futureCohortData;

  @override
  void initState() {
    super.initState();
    futureCohortData = fetchCohortData();
    futureCurriculumItems = fetchCurriculumItems();
  }

  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<Cohort>(
          future: futureCohortData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                  padding: const EdgeInsets.all(5),
                  child: Text('Course: [Mon, Sep 26, 2022 - Fri, Feb 3, 2023]',
                      style: TextStyle(
                        fontSize: 18,
                      )));
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
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
            child: DataClass(datalist: snapshot.data as List<CurriculumItems>),
          );
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
    DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
    DateTime today = DateTime.now();
    DateTime startOfWeek =
        getDate(today.subtract(Duration(days: today.weekday)));
    DateTime endOfWeek = getDate(
        today.add(Duration(days: DateTime.daysPerWeek - today.weekday)));

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
              Row(children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    "Date",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Text(
                    "Title",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Assets",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]),
              Divider(
                height: 0,
                thickness: 2,
                color: Colors.black,
              ),
            ] +
            datalist
                .where((data) => data.startDate.isAfter(startOfWeek))
                .map((data) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      DateFormat('EEE, MM/dd h:mm a').format(data.startAt),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.title,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 30, 33, 222)),
                        ),
                        Text(
                          "(${data.getTypeDisplayString()})",
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                        Text(
                          data.description,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "", // TODO: display the assets here as clickable icons
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Divider(
                    height: 8,
                    thickness: 5,
                    color: Colors.grey,
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }
}


// DataTable(
//         dataRowHeight: 50,
//         sortColumnIndex: 1,
//         showCheckboxColumn: false,
//         // border: TableBorder.all(width: .5),
//         columns: const [
//           DataColumn(
//             label: Text(
//               "Date",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           DataColumn(
//             label: Text(
//               "Title",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           DataColumn(
//             label: Text(
//               "Assets",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//         rows: datalist
//             .where((data) => data.startDate.isAfter(startOfWeek))
//             .map((data) {
//           return DataRow(
//             cells: [
//               DataCell(
//                 Text(
//                   DateFormat('EEE, MM/dd h:mm a').format(data.startAt),
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.w500),
//                 ),
//               ),
//               DataCell(
//                 Text(
//                   data.description,
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.w500),
//                 ),
//               ),
//               DataCell(
//                 Text(
//                   data.type.toString(),
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.w500),
//                 ),
//               ),
//             ],
//           );
//         }).toList(),
//       ),
