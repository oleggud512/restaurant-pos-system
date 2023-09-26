import 'dart:io';

import 'package:client/services/entities/grocery/grocery.dart';
import 'package:equatable/equatable.dart';



sealed class AddDishEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class AddDishLoadEvent extends AddDishEvent { }


class AddDishGroupSelectedEvent extends AddDishEvent { }


class AddDishFindGroceryEvent extends AddDishEvent { 
  final String like;
  AddDishFindGroceryEvent(this.like);
}

// add a grocery to dish
class AddDishAddGroceryEvent extends AddDishEvent {
  final Grocery groc;

  AddDishAddGroceryEvent(this.groc);
}


class AddDishDishGrocCountChangedEvent extends AddDishEvent {
  final int grocId;
  final double newCount;

  AddDishDishGrocCountChangedEvent(this.grocId, String newCount)
      : newCount = double.parse(newCount.isEmpty ? '0.0' : newCount);
}


class AddDishRemoveDishGroceryEvent extends AddDishEvent {
  final int grocId;

  AddDishRemoveDishGroceryEvent(this.grocId);
}


class AddDishGroupChangedEvent extends AddDishEvent {
  AddDishGroupChangedEvent(this.groupId);
  final int groupId;
}


class AddDishPriceChangedEvent extends AddDishEvent {
  final double price;
  AddDishPriceChangedEvent(String pr)
      : price = double.parse(pr.isEmpty? "0.0" : pr);
}


class AddDishNameChangedEvent extends AddDishEvent {
  final String name;
  AddDishNameChangedEvent(this.name);
}


class AddDishLoadPrimeCostEvent extends AddDishEvent { }


class AddDishDishDescriptionChangedEvent extends AddDishEvent {
  final String descr;
  AddDishDishDescriptionChangedEvent(this.descr);
}


class AddDishUpdateDishPhotoEvent extends AddDishEvent {
  final File dishPhoto;
  AddDishUpdateDishPhotoEvent(this.dishPhoto);

  @override
  List<Object?> get props => [dishPhoto];
}

class AddDishDeleteDishPhotoEvent extends AddDishEvent { }

class AddDishSubmitEvent extends AddDishEvent {
  final void Function() onSuccess;

  AddDishSubmitEvent({required this.onSuccess});
}