import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


import '../../controller/dropdown_button_controller.dart';
import '../../controller/forecast_weather_controller.dart';
import 'forecast_weather_details.dart';
// import 'forecast_listview.dart';

class TodayForecast extends StatelessWidget {
  final double lat;
  final double long;

  const TodayForecast({super.key, required this.lat, required this.long});

  @override
  Widget build(BuildContext context) {
    ForecastController forecastController =
        Provider.of<ForecastController>(context, listen: false);
    return Consumer<DropDownButtonController>(
        builder: (context, dropDownButtonController, child) {
      return FutureBuilder(
          future: forecastController.forecastWeather(3, lat, long),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                  width: MediaQuery.sizeOf(context).height / 2,
                  height: MediaQuery.sizeOf(context).height / 2.5,
                  child: const Center(child: CircularProgressIndicator()));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text("Error Getting data..!!"),
              );
            } else {
              var forecastData = snapshot.data!.forecast
                  .forecastday[dropDownButtonController.initial].hour;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).height / 2,
                    height: MediaQuery.sizeOf(context).height / 6,
                    child: ListView.builder(
                      controller: forecastController.scrollToCurrentTIme(
                          hourlyData: forecastData,
                          cardWidth: MediaQuery.sizeOf(context).height / 9,
                          timeNow: DateTime.now()),
                      scrollDirection: Axis.horizontal,
                      itemCount: forecastData.length,
                      itemBuilder: (BuildContext context, int index) {
                        // forecastController.scrollToCurrentHour(
                        //     // timeNow: DateTime.parse(snapshot.data!.location.localtime),
                        //     timeNow: DateTime.now(),
                        //     hourlyData: forecastData,
                        //     cardWidth: MediaQuery.sizeOf(context).height / 9);
                        return SizedBox(
                          // height: MediaQuery.sizeOf(context).height / 9,
                          width: MediaQuery.sizeOf(context).height / 9,
                          child: GestureDetector(
                            onTap: () {
                              forecastController.changeIndex(index);
                            },
                            child: Consumer<ForecastController>(
                                builder: (context, forecastController, child) {
                              return Card(
                                color: index ==
                                        forecastController.currentHourIndex
                                    ? const Color.fromARGB(230, 170, 225, 238)
                                    : null,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Text(forecastData[index].time!.substring(10)),
                                    Text(DateFormat.jm().format(DateTime.parse(
                                        forecastData[index].time))),
                                    Image.network(
                                        "https:${forecastData[index].condition.icon}"),
                                    Text("${forecastData[index].tempC} °C")
                                  ],
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                  ),
                  ForecastWeatherDetails(
                      data: snapshot.data!.forecast.forecastday),
                ],
              );
            }
          });
    });
  }
}
