import 'package:eco_app_2/alertdialog.dart';
import 'package:eco_app_2/park.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MiejscaPage extends StatefulWidget {
  const MiejscaPage({super.key});

  @override
  State<MiejscaPage> createState() => MiejscaPageState();
}

class MiejscaPageState extends State<MiejscaPage> {
  int ekopunkty = 0;
  @override
  void initState() {
    super.initState();
    _checkAlertState();
  }

  void _checkAlertState() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String searchedAlert = 'alert_places';
    bool? alert = prefs.getBool(searchedAlert);
    print('alert bool $alert');
    if(alert == null)
    {
      await prefs.setBool(searchedAlert, true);
        showDialog(context: context, builder: (context) => const MyAlertDialog(title: 'Miejsca', content: 'Tutaj możesz sprawdzić liczbę ekopunktów oraz zobaczyć miejsca o walorach przyrodniczych i przeczytać o nich ciekawostki.\nJeżeli zeskanujesz kod NFC który znajduje się na tablicy informacyjnej w danym miejscu przy włączonej aplikacji to dostaniesz 100 ekopunktów', icon: Icons.map),);
    }
  }
  
  void addEkopunkty(int points) {
    setState(() {
      ekopunkty += points;
    });
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  Future<SharedPreferences> _getSharedPrefs() async
  {
    return await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Miejsca'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            const Text(
              'Twoje Eko-Punkty:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.eco_outlined,
                  size: 40.0,
                  color: Colors.green,
                ),
                const SizedBox(width: 4.0),
                FutureBuilder(future: _getSharedPrefs() , builder: (context, snapshot) {
                  if(!snapshot.hasData)
                  {
                    return const Text(
                      '--',
                  style: TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.green,
                  ),
                );
                  }
                  return Text(
                  snapshot.data!.getInt('ekopunkty').toString(),
                  style: const TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.green,
                  ),
                );
                },),
              ],
            ),
            const Text(
              'Eko-Punkty możesz zdobyć poprzez odwiedzanie miejsc natury w Twojej okolicy, takich jak parki, lasy itp. Pełną listą znajdziesz poniżej.',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  index == 0 ? 'PARK SYBIRAKÓW' : 'Już wkrótce',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'HENRYKA SIENKIEWICZA, 57-200, \nZĄBKOWICE ŚLĄSKIE',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: index == 0
                                      ? () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ParkPage()));
                                        }
                                      : null,
                                  child: Text(index == 0
                                      ? 'Przejdź do miejsca'
                                      : 'Już wkrótce'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          index == 0
                              ? Stack(
                                  children: [
                                    Container(
                                      width: 128,
                                      height: 128,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    Container(
                                      width: 128,
                                      height: 128,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: const DecorationImage(
                                          image: NetworkImage(
                                              'https://drive.google.com/uc?export=view&id=1rO4wf45bec5dOOg3WyyYdyv9UO2zRc0H'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(width: 128, height: 128),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
