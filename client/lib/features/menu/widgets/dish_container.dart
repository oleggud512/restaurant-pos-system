import 'package:client/services/entities/dish.dart';
import 'package:client/services/entities/dish_group.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/sizes.dart';
import 'package:flutter/material.dart';


class DishContainer extends StatelessWidget {
  const DishContainer({Key? key, required this.dish, required this.group, required this.onTap}) : super(key: key);

  final Dish dish;
  final DishGroup group;
  final void Function()? onTap;

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
                  child: dish.dishPhotoUrl.isNotEmpty
                    ? Image.network(dish.dishPhotoUrl)
                    : Image.asset(Constants.dishPlaceholderAsset)
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(dish.dishName, overflow: TextOverflow.ellipsis)),
                          w4gap,
                          Text(dish.dishId.toString())
                        ],
                      ),
                      Text(group.groupName),
                      const Spacer(),
                      Row(
                        children: [
                          const Spacer(),
                          Text('\$ ${dish.dishPrice}')
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