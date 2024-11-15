import 'package:eco_app_2/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:air_quality/air_quality.dart';

class HomePageTopSection extends StatefulWidget {
  final Function(String airQualityAdvice) onAirQualityAdviceChanged;
  const HomePageTopSection(
      {super.key, required this.onAirQualityAdviceChanged});

  @override
  State<HomePageTopSection> createState() => _HomePageTopSectionState();
}

class _HomePageTopSectionState extends State<HomePageTopSection>
    with SingleTickerProviderStateMixin {
  String _airQualityText = 'Nieznana'; // STAN WCZYTYWANIE
  Color _airQualityColor = Colors.grey; // KOLOR WCZYTWANIE
  String _location = 'Pobieranie lokalizacji...';
  final AirQuality airQuality =
      AirQuality(AIR_QUALITY_API_KEY); // API KEY

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    }

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    final Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    if (!mounted) return;

    // ZAMIANA NA MIASTO
    final List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final String cityName = placemarks[0].locality ?? 'Miasto nieznane';

    setState(() {
      _location = cityName;
    });

    _fetchAirQuality(position.latitude, position.longitude);
  }

  Future<void> _fetchAirQuality(double latitude, double longitude) async {
    try {
      final airQualityData =
          await airQuality.feedFromGeoLocation(latitude, longitude);

      if (!mounted) return;

      int aqi = airQualityData.airQualityIndex;
      setState(() {
        _airQualityText = _getAirQualityText(aqi);
        _airQualityColor = _getAirQualityColor(aqi);
      });

      String advice = _getAirQualityAdvice(aqi);
      widget.onAirQualityAdviceChanged(advice);
    } catch (e) {
      setState(() {
        _airQualityText = 'Błąd pobierania danych';
        _airQualityColor = Colors.grey;
      });
      widget.onAirQualityAdviceChanged("Błąd pobierania danych");
    }
  }

  String _getAirQualityText(int aqi) {
    if (aqi <= 50) return 'Dobra';
    if (aqi <= 100) return 'Umiarkowana';
    if (aqi <= 150) return 'Niezdrowa dla wrażliwych';
    if (aqi <= 200) return 'Niezdrowa';
    if (aqi <= 300) return 'Bardzo Niezdrowa';
    return 'Niebezpieczna';
  }

  Color _getAirQualityColor(int aqi) {
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.yellow;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.red;
    if (aqi <= 300) return Colors.purple;
    return Colors.brown;
  }

  String _getAirQualityAdvice(int aqi) {
    if (aqi <= 50) return "Powietrze jest czyste, więc wyjście na zewnątrz jest bezpieczne dla wszystkich. To świetna okazja na aktywności na świeżym powietrzu.";
    if (aqi <= 100) return "Jakość powietrza jest akceptowalna, choć osoby bardzo wrażliwe mogą odczuwać niewielki dyskomfort. Można wyjść na zewnątrz, ale osoby z problemami oddechowymi powinny zachować ostrożność.";
    if (aqi <= 150) return "Osoby starsze, dzieci i chorujące na astmę mogą odczuwać skutki zanieczyszczenia powietrza. Warto ograniczyć aktywność na zewnątrz, szczególnie dla osób wrażliwych.";
    if (aqi <= 200) return "Powietrze jest szkodliwe dla zdrowia, a wszyscy mogą odczuwać negatywne skutki. Zaleca się pozostanie w domu i unikanie aktywności na świeżym powietrzu.";
    if (aqi <= 300) return "Powietrze jest silnie zanieczyszczone, co może wpływać na zdrowie każdego. Lepiej zostać w pomieszczeniu i szczelnie zamknąć okna, by ograniczyć kontakt ze smogiem.";
    return "Zagrożenie zdrowia, Unikaj wyścia.";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Jakość Powietrza',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _airQualityText,
                    style: const TextStyle(
                        fontSize: 36.0, fontWeight: FontWeight.w800),
                  ),
                  if(_airQualityText == 'Nieznana')
                    const SizedBox(width: 16.0),
                  if(_airQualityText == 'Nieznana')
                    const CircularProgressIndicator(),
                 
                ],
              ),
              const SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                color: const Color.fromARGB(255, 237, 237, 237),
                borderRadius: BorderRadius.circular(50.0)),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.place, size: 18.0, color: Colors.black),
                    const SizedBox(width: 4.0),
                    Text(
                      _location,
                      style: const TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
                      SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if(_airQualityText != 'Nieznana')
                            CircleAvatar(
                            radius: 50,
                            backgroundColor: _airQualityColor.withAlpha(32),
                                                      ).animate(onPlay: (controller) => controller.repeat())
                                                      .fadeOut(delay: 1750.ms, duration: 1000.ms, curve: Curves.easeOutQuart)
                                                      .scale(delay: 1500.ms, duration: 1000.ms, curve: Curves.easeOutQuart),
                            CircleAvatar(
                            radius: 20,
                            backgroundColor: _airQualityColor,
                                                    ),
                          ],
                          
                        ),
                      ),
        ],
      ),
    );
  }
}
