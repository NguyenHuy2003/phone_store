// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';

class Phone {
  String id;
  ValueNotifier<String> brand;
  ValueNotifier<String> model;
  ValueNotifier<int> price;
  ValueNotifier<String> specifications;
  ValueNotifier<String> image;

  Phone({
    String? id,
    String? brand,
    String? model,
    required int price,
    String? image,
    String? specifications,
  })  : id = id ?? generateUuid(),
        brand = ValueNotifier(brand ?? ''),
        model = ValueNotifier(model ?? ''),
        price = ValueNotifier(price),
        specifications = ValueNotifier(specifications ?? ''),
        image = ValueNotifier(image ?? '');

  static String generateUuid() {
    return int.parse(
            '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(100000)}')
        .toRadixString(35)
        .substring(0, 9);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'brand': brand.value,
      'model': model.value,
      'price': price.value,
      'specifications': specifications.value,
      'image': image.value,
    };
  }

  factory Phone.fromMap(Map<String, dynamic> map) {
    return Phone(
      id: map['id'] as String,
      brand: map['brand'],
      model: map['model'],
      price: map['price'],
      specifications: map['specifications'],
      image: map['image'],
    );
  }
}
