import 'dart:math';

import 'package:eco_app_2/HomePageTop.dart';
import 'package:eco_app_2/Places.dart';
import 'package:eco_app_2/eco_container.dart';
import 'package:eco_app_2/to_do.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _airQualityAdvice = "Ładowanie danych o jakości powietrza...";

class HomeScreen extends StatefulWidget
{
  const HomeScreen({required this.setNavbar, super.key});

  final void Function(int) setNavbar;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    GenerateRandomEcoTip(); // Losowa porada przy uruchomieniu aplikacji
  }

  final List<String> ecoTips = [
    "Oszczędzaj wodę, zakręcając kran podczas mycia zębów. Dzięki temu możesz zaoszczędzić do 15 litrów wody dziennie!",
    "Zbieraj deszczówkę do podlewania roślin. Woda opadowa jest naturalna i darmowa, a dodatkowo zmniejszysz zużycie wody pitnej.",
    "Używaj bawełnianych toreb na zakupy zamiast plastikowych. Wielorazowe torby są bardziej wytrzymałe i możesz z nich korzystać przez wiele lat.",
    "Unikaj jednorazowych plastikowych słomek. Zastąp je metalowymi, szklanymi lub bambusowymi, które możesz myć i ponownie wykorzystywać.",
    "Przesiądź się na rower lub korzystaj z transportu publicznego. Ograniczając jazdę samochodem, zmniejszasz emisję CO₂ i hałas w mieście.",
    "Gdy wychodzisz z pokoju, wyłączaj światło. Oszczędzanie energii zmniejsza jej produkcję, a co za tym idzie – emisję gazów cieplarnianych.",
    "Przejdź na energooszczędne żarówki LED. Są bardziej efektywne i wytrzymują dłużej niż tradycyjne żarówki, co przekłada się na niższe rachunki za prąd.",
    "Stosuj naturalne środki czystości, takie jak ocet i soda oczyszczona. Chemiczne detergenty trafiają do wód i są trudne do usunięcia, co negatywnie wpływa na ekosystemy wodne.",
    "Kupuj produkty lokalne i sezonowe. Importowane jedzenie zostawia duży ślad węglowy, ponieważ trzeba je transportować na duże odległości.",
    "Korzystaj z termoizolacji domu, by zmniejszyć zużycie energii na ogrzewanie. Dobrze izolowany budynek potrzebuje mniej energii do utrzymania ciepła.",
  ];

  String randomEcoTip = '';

  void _updateAirQualityAdvice(String advice) {
    setState(() {
      _airQualityAdvice = advice;
    });
  }

  // Losowe generowanie porady dnia
  void GenerateRandomEcoTip() {
    randomEcoTip = ecoTips[Random().nextInt(ecoTips.length)];
  }

  String get _getTodoPanelString
  {
    String panelString = '';
    
    if(taskCompletionStatus.contains(false))
    {
      panelString += 'Do wykonania zostało jeszcze ${taskCompletionStatus.where((item) => item == false).length} zadań, czyli aż ${taskCompletionStatus.where((item) => item == false).length * 10} eko-punktów!';
    }
    else
    {
      panelString += 'Wszystkie zadania ukończone!';
    }

      panelString += '\nDo końca pozostało $_getTime.';
      return panelString;
    }

  String get _getTime
  {
    DateTime a = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,23,59,59);
    DateTime b = DateTime.now();

    Duration difference = a.difference(b);

    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  Future<SharedPreferences> _getSharedPrefs() async
  {
    return await SharedPreferences.getInstance();
  }
  
  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24.0),
                HomePageTopSection(
                    onAirQualityAdviceChanged: _updateAirQualityAdvice),
                const SizedBox(height: 16.0),
              Row(children: [
               Expanded(child: ElevatedButton(onPressed: () {
                   FocusScope.of(context).unfocus();
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => const MiejscaPage()),
                   );},
                              style: ButtonStyle(
               shape: WidgetStatePropertyAll(
                 RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(10.0),
                   side: const BorderSide(color: Color(0xFF06005A))
                 )
               )
                             ),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Column(
                   children: [
                     Icon(Icons.map),
                     SizedBox(height: 8.0),
                      FittedBox(fit:BoxFit.fitWidth, child: Text('Miejsca', style: TextStyle(fontSize: 12.0), textAlign: TextAlign.center,)),
                   ],
                                ),
                ),),
                ),
                const SizedBox(width: 8.0),
                Expanded(child: ElevatedButton(onPressed: () {
                   FocusScope.of(context).unfocus();
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => const TodoPage()),
                   );},
                              style: ButtonStyle(
               shape: WidgetStatePropertyAll(
                 RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(10.0),
                   side: const BorderSide(color: Color(0xFF06005A))
                 )
               )
                             ),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Column(
                   children: [
                     Icon(Icons.check_box),
                     SizedBox(height: 8.0),
                      FittedBox(fit:BoxFit.fitWidth, child: Text('Zadania', style: TextStyle(fontSize: 12.0), textAlign: TextAlign.center,)),
                   ],
                                ),
                ),),
                ),
                const SizedBox(width: 8.0),
                Expanded(child: ElevatedButton(onPressed: () {
                  setState(() {
                    widget.setNavbar(1);
                  });
                },
                               style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Color(0xFF06005A))
                  )
                )
                              ),
                 child: const Padding(
                   padding: EdgeInsets.all(4.0),
                   child: Column(
                    children: [
                      Icon(Icons.air),
                      SizedBox(height: 8.0),
                      FittedBox(fit:BoxFit.fitWidth, child: Text('Mapa', style: TextStyle(fontSize: 12.0), textAlign: TextAlign.center,)),
                    ],
                                 ),
                 ),),
                ),
                const SizedBox(width: 8.0),
                Expanded(child: ElevatedButton(onPressed: () {
                  setState(() {
                    widget.setNavbar(2);
                  });},
                               style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Color(0xFF06005A))
                  )
                )
                              ),
                 child: const Padding(
                   padding: EdgeInsets.all(4.0),
                   child: Column(
                    children: [
                      Icon(Icons.app_shortcut),
                      SizedBox(height: 8.0),
                      FittedBox(fit:BoxFit.fitWidth, child: Text('Leafy AI', style: TextStyle(fontSize: 12.0), textAlign: TextAlign.center,)),
                    ],
                                 ),
                 ),),
                ),
              ],),
                const SizedBox(height: 16.0),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    color: Colors.green.withAlpha(4),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.eco_outlined), 
                          SizedBox(width: 8), 
                          Text(
                            'Eko-punkty',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                        ],
                      ),
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
                    return RichText(
                      text: TextSpan(
                        text: 'Obecnie posiadasz ',
                        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 16.0),
                        children: <TextSpan>[
                          TextSpan(text: snapshot.data!.getInt('ekopunkty').toString(), style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.green, fontSize: 18.0)),
                          const TextSpan(text: ' eko-punktów!'),
                        ],
                      ),
                    );
                  },),
                    ],
                  ),
                ),
                EcoContainer(
                  title: "Jakość powietrza",
                  icon: Icons.air,
                  child: Text(_airQualityAdvice,
                    style: const TextStyle(fontSize: 16.0),),
                ),
                EcoContainer(
                  title: "Porada na dziś",
                  icon: Icons.lightbulb,
                  child: Text(randomEcoTip,
                    style: const TextStyle(fontSize: 16.0),), // Wyświetlanie losowej porady
                ),
                EcoContainer(
                  title: "Zadania codzienne",
                  icon: Icons.check_box,
                  child: Text(_getTodoPanelString,
                    style: const TextStyle(fontSize: 16.0),),
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      );
  }
}