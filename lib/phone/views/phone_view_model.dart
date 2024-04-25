import 'package:crud_mvvm/phone/models/phone.dart';
import 'package:crud_mvvm/phone/views/phone_services.dart';
import 'package:flutter/material.dart';

class PhoneViewModel extends ChangeNotifier {
  static final _instance = PhoneViewModel.__internal();
  factory PhoneViewModel() => _instance;
  PhoneViewModel.__internal() {
    services.loodItem().then((values) {
      if (values is List<Phone>) {
        phones.clear();
        phones.addAll(values);
        notifyListeners();
      }
    });
  }
  final List<Phone> phones = [];
  final services = PhoneServices();

  Future addPhone(String brand, String model, int price, String? image,
      String specifications) async {
    var phone = Phone(
        brand: brand,
        model: model,
        price: price,
        image: image,
        specifications: specifications);
    phones.add(phone);
    notifyListeners();

    services.addPhone(phone);
    return phone;
  }

  Future removePhone(String id) async {
    phones.removeWhere((item) => item.id == id);
    notifyListeners();

    services.removePhone(id);
  }

  Future updatePhone(String id, String newBrand, String newModel, int newPrice,
      String newSpecifications, String newImage) async {
    try {
      final phone = phones.firstWhere((phone) => phone.id == id);
      phone.brand.value = newBrand;
      phone.model.value = newModel;
      phone.price.value = newPrice;
      phone.specifications.value = newSpecifications;
      phone.image.value = newImage;
      notifyListeners();

      await services.updatePhone(phone);
    } catch (e) {
      debugPrint("Không tìm thấy mục với ID $id");
    }
  }
}
