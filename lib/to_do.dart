import 'package:eco_app_2/alertdialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Places.dart';

  List<String> tasks = [
    'Kupuj produkty lokalne i sezonowe',
    'Recyklinguj ubrania',
    'Zmniejsz zużycie energii',
    'Oszczędzaj wodę',
    'Segreguj odpady',
    'Kompostuj odpady organiczne',
    'Zrezygnuj z jednorazowych kubków i słomek',
    'Zrób przegląd swoich nawyków zakupowych',
    'Unikaj marnowania jedzenia',
    'Zainwestuj w energooszczędne urządzenia',
  ];

  List<bool?> taskCompletionStatus =
      List.filled(tasks.length, false, growable: true); // Lista do przechowywania statusu
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {

  @override
  void initState() {
    super.initState();
    _checkAlertState();
  }

  void _checkAlertState() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String searchedAlert = 'alert_todo';
    bool? alert = prefs.getBool(searchedAlert);
    print('alert bool $alert');
    if(alert == null)
    {
      await prefs.setBool(searchedAlert, true);
        showDialog(context: context, builder: (context) => const MyAlertDialog(title: 'Zadania', content: 'Każdy z nas powinnien być eko. Wprowadź nawyki do twojego życia żeby żyć bardziej zgodnie z naturą. Za wprowadzenie nawyku dostajesz ekopunkty.', icon: Icons.check_box),);
    }
  }



  void _toggleTaskCompletion(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? ekopunkty = prefs.getInt('ekopunkty');
    setState(() {
      if(taskCompletionStatus[index] == true)
      {
        taskCompletionStatus[index] = false;
        ekopunkty = ekopunkty! - 10;
      }
      else
      {
        taskCompletionStatus[index] = true;
        ekopunkty = ekopunkty! + 10;
      }
      
    });
    await prefs.setInt('ekopunkty', ekopunkty!);

      String a = taskCompletionStatus.toString();
      String b = a.substring(1, a.length - 1);
      List<String> newList = b.split(',');
      for(int i = 0; i < newList.length; i++)
      {
        newList[i] = newList[i].trim();
        //print('lista before trim: ${newList[i]} / after: ${newList[i].trim()}');
      }
      //print('lista full $newList');
      await prefs.setStringList('completedTasks', newList);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zadania codzienne'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 24.0),
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
                'Eko-Punkty możesz zdobyć poprzez wykonywanie zadań, które pomogą ci przyswoić ekologiczne nawyki. Za każde wykonane zadanie otrzymasz 10 punktów. Lista zadań resetuje się codziennie.',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text('Wykonane zadania:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),),
              Text('${taskCompletionStatus.where((item) => item == true).length}/${taskCompletionStatus.length}',
                    style: const TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w800,
                    ),),
              Text('Do końca pozostało: $_getTime', style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),),
              const SizedBox(height: 20),
            ListView.builder(
            itemCount: tasks.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: Checkbox(
                  value: taskCompletionStatus[index],
                  onChanged: (bool? value) {
                    _toggleTaskCompletion(index);
                  },
                ),
                title: Text(
                  tasks[index],
                  style: TextStyle(
                    decoration: taskCompletionStatus[index] ?? false
                        ? TextDecoration
                            .lineThrough // Przekreślenie ukończonego zadania
                        : null,
                  ),
                ),
              );
            },
          ),
            const SizedBox(height: 24.0),
          ],),
        ),
      ),
    );
  }
}
