import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
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
    Widget titleSection =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Breadcrumbs(),
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
            style: TextStyle(fontWeight: FontWeight.w100, fontSize: 25),
          ),
        ],
      ),
    ]);

    // Constructs a single button. Accepts icon, label
    Column createButton(IconData icon, String label) {
      Color color = Colors.black54;

      return Column(children: [
        ElevatedButton.icon(
          onPressed: () {
            print('Pressed button $label');
          },
          icon: Icon(icon, color: color),
          label: Text(
            label,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w400, fontSize: 12),
          ),
        ),
      ]);
    }

    // Constructs row for buttons.
    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        createButton(Icons.calendar_month, 'CALENDAR'),
        createButton(Icons.videocam, 'ZOOM'),
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
          backgroundColor: Color.fromARGB(255, 228, 107, 102),
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
          padding: const EdgeInsets.all(25),
          children: [titleSection, buttonSection, CohortDetailPage()],
        ),
      ),
    );
  }
}

// TODO: Make functional.
class Breadcrumbs extends StatelessWidget {
  const Breadcrumbs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Rithm 28 / Upcoming',
      style: TextStyle(
        color: Color.fromARGB(255, 160, 159, 159),
        fontSize: 18,
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////

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
    return Column(
      children: [
        FutureCourseInfo(futureCohortData: futureCohortData),
        CurriculumItemsHeader(),
        Divider(
          height: 1,
          thickness: 2,
          color: Colors.black45,
        ),
        FutureCurriculumItems(futureCurriculumItems: futureCurriculumItems),
      ],
    );
  }
}

//TODO: Move state up for usage in upper levels.

class FutureCourseInfo extends StatelessWidget {
  const FutureCourseInfo({
    Key? key,
    required this.futureCohortData,
  }) : super(key: key);

  final Future<Cohort> futureCohortData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Cohort>(
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
    );
  }
}

////////////////////////////////////////////////////////////////////////

class CurriculumItemsHeader extends StatelessWidget {
  const CurriculumItemsHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
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
      ],
    );
  }
}

class FutureCurriculumItems extends StatelessWidget {
  const FutureCurriculumItems({
    Key? key,
    required this.futureCurriculumItems,
  }) : super(key: key);

  final Future<List<CurriculumItems>> futureCurriculumItems;

  @override
  Widget build(BuildContext context) {
    DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
    DateTime today = DateTime.now();
    DateTime startOfWeek =
        getDate(today.subtract(Duration(days: today.weekday)));
    // DateTime endOfWeek = getDate(
    //     today.add(Duration(days: DateTime.daysPerWeek - today.weekday)));

    return FutureBuilder<List<CurriculumItems>>(
      future: futureCurriculumItems,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: snapshot.data!
                .where((data) => data.startDate.isAfter(startOfWeek))
                .map((data) => CurricItem(data: data))
                .toList(),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

// Constructs a single Row for listView display

class CurricItem extends StatelessWidget {
  const CurricItem({Key? key, required this.data}) : super(key: key);
  final CurriculumItems data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  DateFormat('EEE, MM/dd h:mm a').format(data.startAt),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 8,
                child: InkWell(
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
              ),
              Expanded(
                flex: 2,
                child: Icon(Icons.folder, color: Colors.black54),
              ),
            ],
          ),
          Divider(height: 1, thickness: 1),
        ],
      ),
    );
  }
}
