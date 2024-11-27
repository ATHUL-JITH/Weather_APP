import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_new/controller/dropdown_button_controller.dart';
import 'package:weather_app_new/utils/constants/constants.dart';
import 'package:weather_app_new/utils/widgets/today_forecast.dart';
import '../controller/forecast_weather_controller.dart';
import '../controller/weather_controller.dart';
import '../model/weather_model.dart';
import '../utils/widgets/search_delegate.dart';
import '../utils/widgets/weather_card.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ForecastController forecastController =
        Provider.of<ForecastController>(context, listen: false);
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 51, 28, 113),
      body: Consumer<WeatherController>(
          builder: (context, weatherController, child) {
        return FutureBuilder<WeatherModel?>(
          future: weatherController.getWeather(),
          builder: (context, snapshot) {
            if (weatherController.latitude == null &&
                    weatherController.longitude == null ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset(
                  "assets/lottie animation/waiting_animation.json",
                ),
              );
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text("Error..!!"),
              );
            } else {
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 30,
                                // color: Colors.black,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(snapshot.data!.location!.country!),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          " , ${snapshot.data!.location!.region}",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(snapshot.data!.location!.name!,
                                      style: const TextStyle(
                                        fontSize: 25,
                                      )),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () => showSearch(
                                      context: context,
                                      delegate: CustomSearchDelegate()),
                                  icon: const Icon(
                                    Icons.search,
                                    size: 30,
                                  )),
                              PopupMenuButton(
                                iconSize: 30,
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      onTap: () => weatherController
                                          .getCurrentLocation(),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.gps_fixed_rounded,
                                            color: Colors.black,
                                          ),
                                          SizedBox(width: 10),
                                          Text("Reset Location")
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: () => weatherController.refresh(),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.refresh,
                                            color: Colors.black,
                                          ),
                                          SizedBox(width: 10),
                                          Text("Refresh")
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      WeatherCard(data: snapshot.data!),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FutureBuilder(
                            future: forecastController.forecastWeather(
                                3,
                                snapshot.data!.location!.lat!,
                                snapshot.data!.location!.lon!),
                            builder: (context, forecastSnapshot) {
                              if (forecastSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              } else if (forecastSnapshot.data == null ||
                                  !forecastSnapshot.hasData) {
                                return Container();
                              } else {
                                return Consumer<DropDownButtonController>(
                                    builder: (context, dropdownDuttonController,
                                        child) {
                                  return DropdownButton(
                                    iconEnabledColor: Colors.white,
                                    underline: Container(),
                                    borderRadius: BorderRadius.circular(10),
                                    dropdownColor: Constants.cardBg,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 17),
                                    value: dropdownDuttonController.initial,
                                    items: forecastSnapshot
                                        .data!.forecast.forecastday
                                        .map((e) => DropdownMenuItem(
                                            alignment: Alignment.center,
                                            value: dropdownDuttonController
                                                .setDropdownValue(
                                                    currentTime: DateTime.now(),
                                                    date:
                                                        DateTime.parse(e.date)),
                                            child: Text(e.date)))
                                        .toList(),
                                    onChanged: (value) {
                                      dropdownDuttonController
                                          .toggleMenuButton(value);
                                    },
                                  );
                                });
                              }
                            },
                          ),
                          const Text("Forecast Weather",
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.left),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TodayForecast(
                        lat: snapshot.data!.location!.lat!,
                        long: snapshot.data!.location!.lon!,
                      ),
                      // WeatherDetails(data: snapshot.data!)
                    ],
                  ),
                ),
              );
            }
          },
        );
      }),
    );
  }
}
