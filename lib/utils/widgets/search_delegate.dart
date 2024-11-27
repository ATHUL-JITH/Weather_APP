import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/weather_controller.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    WeatherController weatherController =
        Provider.of<WeatherController>(context);
    return FutureBuilder(
        future: weatherController.searchLocation(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
              "No results found",
              style: TextStyle(color: Colors.white),
            ));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    weatherController.assignLocation(
                        lat: snapshot.data![index].lat,
                        long: snapshot.data![index].lon);
                    close(context, null);
                  },
                  title: Text(snapshot.data![index].name!),
                  subtitle: Text(
                      "${snapshot.data![index].region}, ${snapshot.data![index].country}"),
                );
              },
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
    // throw UnimplementedError();
  }
}
