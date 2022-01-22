import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/data/model/restaurants.dart';
import 'package:restaurant_app/data/model/restaurants_detail.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/provider/restaurants_detail_provider.dart';
import 'package:restaurant_app/ui/review_customer.dart';
import 'package:restaurant_app/utils/request_state.dart';
import 'package:share/share.dart';

class DetailScreen extends StatefulWidget {
  final Restaurant restaurants;
  final String id;

  DetailScreen({
    Key? key,
    required this.id,
    required this.restaurants,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    print(widget.id);
    Future.microtask(
      () => Provider.of<RestaurantDetailProvider>(context, listen: false)
          .fetchRestaurantDetail(widget.id),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildDetail() {
      return Consumer<RestaurantDetailProvider>(
        builder: (context, state, _) {
          if (state.state == RequestState.Loading) {
            print(state.state);

            return Center(child: CircularProgressIndicator());
          } else if (state.state == RequestState.HasData) {
            print(state.state);

            print(state.result!.restaurant);
            return _buildBody(
              context: context,
              restaurant: state.result!.restaurant,
            );
          } else if (state.state == RequestState.NoData) {
            print(state.state);

            return Center(
              child: Text(state.message),
            );
          } else if (state.state == RequestState.Error) {
            print(state.state);

            return Center(child: Text('ERROR'));
          } else {
            print(state.state);

            return Center(
              child: Text('ERRORS'),
            );
          }
        },
      );
    }

    return Scaffold(
      body: _buildDetail(),
      floatingActionButton:
          Consumer<DatabaseProvider>(builder: (context, provider, _) {
        return FutureBuilder<bool>(
            future: provider.isFavorited(widget.restaurants.id),
            builder: (context, snapshot) {
              var isFavorited = snapshot.data ?? false;

              return Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: isFavorited
                      ? IconButton(
                          onPressed: () =>
                              provider.removeFavorite(widget.restaurants.id),
                          icon: Icon(Icons.favorite),
                          iconSize: 30,
                          color: Colors.red)
                      : IconButton(
                          icon: Icon(Icons.favorite_border),
                          iconSize: 30,
                          color: Colors.white,
                          onPressed: () =>
                              provider.addFavorites(widget.restaurants),
                        ),
                ),
              );
            });
      }),
    );
  }

  String imageUrl = 'https://restaurant-api.dicoding.dev/images/medium/';
  bool isbooked = false;
  SafeArea _buildBody({
    required BuildContext context,
    required RestaurantDetail restaurant,
  }) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Detail Restaurant',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        Share.share(
                          "${restaurant.name} \n\n${restaurant.city} \n\n${restaurant.description}",
                        );
                      },
                      icon: Icon(
                        Icons.share,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              width: 315,
              height: 370,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                    image: NetworkImage('$imageUrl${restaurant.pictureId}'),
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                child: Text(
                  restaurant.name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                margin: EdgeInsets.only(left: 20),
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
                      restaurant.city,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.orange,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.orange,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.orange,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.orange,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          restaurant.rating.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                'Description',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                restaurant.description,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                'Food',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                children: restaurant.menus.foods.map(
                  (foods) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "images/dot.png",
                              width: 8,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              foods.name,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                'Drink',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                children: restaurant.menus.drinks.map(
                  (drinks) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "images/dot.png",
                              width: 8,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              drinks.name,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ReviewCustomer(
                      restaurant: restaurant,
                    );
                  }));
                },
                child: Text('Review Restaurant'),
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
