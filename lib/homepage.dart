import 'dart:async';
import 'package:eco_app_2/alertdialog.dart';
import 'package:eco_app_2/gemini_chatbot.dart';
import 'package:eco_app_2/home.dart';
import 'package:eco_app_2/to_do.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'app_bar.dart';
import 'package:eco_app_2/MapPage.dart';
import 'package:app_links/app_links.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'Places.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
   Homepage({super.key, this.selectedIndex = 0});

  int selectedIndex = 0;

  @override
  State<Homepage> createState() => HomePageState();
}

class HomePageState extends State<Homepage> {
  StreamSubscription? _sub;
  final AppLinks _appLinks = AppLinks();
  final GlobalKey<MiejscaPageState> _miejscaPageKey =
      GlobalKey<MiejscaPageState>();

  void _setNavbar(int value) {
    setState(() {
      widget.selectedIndex = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _appInitialization();
    _startNfcSession();
  }

  void _appInitialization() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? ekopunkty = prefs.getInt('ekopunkty');
    if(ekopunkty == null)
    {
      await prefs.setInt('ekopunkty', 0);
    }

    int? lastLoginTimestamp = prefs.getInt('lastLogin');
    if(lastLoginTimestamp != null)
    {
      DateTime lastLoginDateTime = DateTime.fromMillisecondsSinceEpoch(lastLoginTimestamp);
      if(lastLoginDateTime.day != DateTime.now().day)
      {
        showDialog(context: context, builder: (context) => const MyAlertDialog(title: 'Witaj w Eco app!', content: 'Witaj w aplikacji! Otrzymujesz swój dzienny bonus - 100 eko-punktów.', icon: Icons.eco_sharp),);
          int? ekopunkty = prefs.getInt('ekopunkty');
          ekopunkty = ekopunkty! + 100;
          await prefs.setInt('ekopunkty', ekopunkty);
          await prefs.setStringList('completedTasks', []);
      }
    }
    int timestampNow = DateTime.now().millisecondsSinceEpoch;
    prefs.setInt('lastLogin', timestampNow);

    List<String>? completedTasks = prefs.getStringList('completedTasks');
      print('lista com $completedTasks');

      //PO DODANIU NOWYCH ZADAN RAZ ODPALIC TEN KOD
      // String a = taskCompletionStatus.toString();
      // String b = a.substring(1, a.length - 1);
      // List<String> newList = b.split(',');
      // await prefs.setStringList('completedTasks', newList);

    if(completedTasks == null || completedTasks.isEmpty)
    {
      String a = taskCompletionStatus.toString();
      String b = a.substring(1, a.length - 1);
      List<String> newList = b.split(',');
      for(int i = 0; i < newList.length; i++)
      {
        newList[i] = newList[i].trim();
      }
      await prefs.setStringList('completedTasks', newList);
    }
    else
    {
      taskCompletionStatus = [];
      taskCompletionStatus = completedTasks.map((e) => e == 'true').toList();
      print('lista bool: $taskCompletionStatus / string: $completedTasks');
    }
  }

  void _startNfcSession() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (isAvailable) {
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          int? ekopunkty = prefs.getInt('ekopunkty');
          ekopunkty = ekopunkty! + 10;
          await prefs.setInt('ekopunkty', ekopunkty);
        Navigator.of(context).pushNamed('/park');
      });
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  // Strony do wyświetlenia
  List<Widget> _pages() {
    return [
      HomeScreen(
        setNavbar: _setNavbar,
      ),
      const MapPage(),
      const ChatbotGemini()
    ];
  }

  String get _appBarTitle {
    switch (widget.selectedIndex) {
      case 0:
        return 'Strona główna';
      case 1:
        return 'Mapa';
      case 2:
        return 'Leafy AI';
      default:
        return 'ECO APP';
    }
  }

  void _checkAlertState(int index) async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String searchedAlert = '';
    switch(index)
    {
      case 1:
      searchedAlert = 'alert_mapa';
      break;
      case 2:
      searchedAlert = 'alert_ai';
      break;
    }
    bool? alert = prefs.getBool(searchedAlert);
    print('alert bool $alert');
    if(alert == null)
    {
      await prefs.setBool(searchedAlert, true);
      if(index == 1)
      {
        showDialog(context: context, builder: (context) => const MyAlertDialog(title: 'Mapa', content: 'Na tej stronie możesz sprawdzić zanieczyszczenie powietrza w polskich miastach.\nWystarczy, że wpiszesz swoje miasto!', icon: Icons.air),);
      }
      if(index == 2)
      {
        showDialog(context: context, builder: (context) => const MyAlertDialog(title: 'Leafy AI', content: 'To jest nasz chatbot. Możesz zapytać bota o cokolwiek zechcesz.\nMożesz także spróbować dodać zdjęcie (szczególnie roślin) i sprawdzić co się stanie!', icon: Icons.app_shortcut),);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _appBarTitle,
      ),
      body: IndexedStack(
        index: widget.selectedIndex,
        children: _pages(),
      ),
      bottomNavigationBar: GNav(
        gap: 8,
        iconSize: 24,
        duration: const Duration(milliseconds: 500),
        rippleColor: const Color(0xFF21FF76),
        color: const Color(0xFF06005A),
        activeColor: const Color(0xFF06005A),
        tabBackgroundColor: const Color(0xFF21FF76),
        backgroundColor: const Color(0xFFF2F2F2),
        tabMargin: const EdgeInsets.all(10),
        curve: Curves.easeInOutExpo,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        tabs: const [
          GButton(
            icon: Icons.home,
            text: "Strona Główna",
          ),
          GButton(
            icon: Icons.map,
            text: "Mapa",
          ),
          GButton(
            icon: Icons.app_shortcut,
            text: "Leafy AI",
          ),
        ],
        selectedIndex: widget.selectedIndex,
        onTabChange: (index) {
          FocusScope.of(context).unfocus();
          _checkAlertState(index);
          setState(() {
            widget.selectedIndex = index;
          });
        },
      ),
    );
  }
}
