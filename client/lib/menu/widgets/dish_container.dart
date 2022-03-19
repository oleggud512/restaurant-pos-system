import 'package:client/menu/widgets/photo.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../services/models.dart';


class DishContainer extends StatelessWidget {
  DishContainer({Key? key, required this.dish, required this.group, required this.onTap}) : super(key: key);

  Dish dish;
  DishGroup group;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            width: 250,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Photo(dish: dish, height: 30, edit: false,),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          Text(dish.dishName),
                          const Spacer(),
                          Text(dish.dishId.toString())
                        ],
                      ),
                      Text(group.groupName),
                      const Spacer(),
                      Row(
                        children: [
                          const Spacer(),
                          Text('\$ ' + dish.dishPrice.toString())
                        ]
                      )
                    ]
                  )
                )
              ]
            )
          ),
        ),
      )
    );
  }
}