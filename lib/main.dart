// import 'dart:html';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
// import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'services/api_service.dart';
import 'models/curriculum-items.dart';

Future main() async {
  await dotenv.load();

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
                      'Rithm r28 Upcoming',
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
              .where((data) => data.startDate.isAfter(startOfWeek))
              .map((data) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    DateFormat('EEE, MM/dd h:mm a').format(data.startAt),
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
            );
          }).toList(),
        ),
      ),
    );
  }
}
