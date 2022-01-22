import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurants.dart';
import 'package:restaurant_app/provider/searching_restaurant_provider.dart';
import 'package:restaurant_app/ui/detail_screen.dart';
import 'package:restaurant_app/utils/request_state.dart';

class SearchingScreen extends StatefulWidget {
  SearchingScreen({Key? key}) : super(key: key);

  @override
  _SearchingScreenState createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {
  Widget _buildTextField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4,
            offset: Offset(0, 4),
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: TextField(
        onSubmitted: (query) {
          Provider.of<RestaurantSearchProvider>(context, listen: false)
              .fecthRestaurantSearch(query);
        },
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: 17),
          hintText: 'Search',
          suffixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(14),
        ),
      ),
    );
  }

  _buildSearchResult() {
    return Consumer<RestaurantSearchProvider>(
      builder: (context, restaurant, child) {
        if (restaurant.state == RequestState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (restaurant.state == RequestState.HasData) {
          if (restaurant.result!.restaurants.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 250),
              child: Center(
                child: Text(
                  'Restaurant Not Found',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          } else {
            return Expanded(
              child: ListView.builder(
                itemCount: restaurant.result!.restaurants.length,
                itemBuilder: (context, index) {
                  return CardListRestaurant(
                    restaurants: restaurant.result!.restaurants[index],
                    index: index,
                  );
                },
              ),
            );
          }
        } else {
          return Center(
            child: Text(restaurant.message),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Search Restaurant'),
        backgroundColor: Colors.grey.shade800,
      ),
      body: Column(
        children: [
          _buildTextField(),
          SizedBox(
            height: 10,
          ),
          _buildSearchResult()
        ],
      ),
    );
  }
}

class CardListRestaurant extends StatelessWidget {
  final Restaurant restaurants;
  final int index;

  const CardListRestaurant({
    Key? key,
    required this.restaurants,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = 'https://restaurant-api.dicoding.dev/images/medium/';
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailScreen(
            id: restaurants.id,
            restaurants: restaurants,
          );
        }));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          margin: EdgeInsets.only(bottom: 10, top: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Container(
            height: 270,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    image: DecorationImage(
                        image:
                            NetworkImage('$imageUrl${restaurants.pictureId}'),
                        fit: BoxFit.cover),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        restaurants.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        restaurants.description,
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.room,
                            color: Colors.red,
                            size: 20,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            restaurants.city,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 20,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            restaurants.rating.toString(),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
