import 'package:flutter/material.dart';

class ParkPage extends StatefulWidget {
  const ParkPage({super.key});

  @override
  State<ParkPage> createState() => _ParkPageState();
}

class _ParkPageState extends State<ParkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artykuł o Parku'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [

            Container(
              width: double.infinity,
              height: 200.0,
              decoration: const BoxDecoration(color: Colors.grey,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
              child: Image.network(
                'https://drive.google.com/uc?export=view&id=1kQd_-zY-mgUmF4NvD1iKeGKwGAzhLmpO',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200.0,
                loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
              ),
            ),
              ],
            ),
            const SizedBox(
                height: 16.0), 

            // Duży tekst nagłówka
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Park Sybiraków',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Ikona miejsca i adres
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.location_on, size: 24.0),
                  SizedBox(width: 8.0), // Przerwa między ikoną a tekstem
                  Text(
                    'Ząbkowice Śląskie, ul. Sybiraków',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Opis parku
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Park im. Sybiraków to największa i najpopularniejsza zielona enklawa w Ząbkowicach Śląskich. To miejsce, które w ostatnich latach przeszło znaczącą metamorfozę, stając się ulubionym miejscem spotkań mieszkańców i turystów.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
