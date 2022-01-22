import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/ui/searching_screen.dart';
import 'package:restaurant_app/utils/request_state.dart';

class Favorite extends StatelessWidget {
  Widget _buildList() {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == RequestState.HasData) {
          return ListView.builder(
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              return CardListRestaurant(
                restaurants: provider.favorites[index],
                index: index,
              );
            },
          );
        } else {
          return Center(child: Text("Tidak ada data"));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: Center(
          child: Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Text('Favorite Restaurant'),
            ],
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 8),
        child: _buildList(),
      ),
    );
  }
}
