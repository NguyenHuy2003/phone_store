import 'package:crud_mvvm/phone/models/phone.dart';
import 'package:localstore/localstore.dart';

class PhoneServices {
  Future loodItem() async {
    var db = Localstore.getInstance(useSupportDir: true);
    var mapPhones = await db.collection('phones').get();
    if (mapPhones != null && mapPhones.isNotEmpty) {
      var phones = List<Phone>.from(
          mapPhones.entries.map((e) => Phone.fromMap(e.value)));
      return phones;
    }
    return null;
  }

  Future addPhone(Phone phone) async {
    var db = Localstore.getInstance(useSupportDir: true);
    db.collection('phones').doc(phone.id).set(phone.toMap());
  }

  Future removePhone(String id) async {
    var db = Localstore.getInstance(useSupportDir: true);
    db.collection('phones').doc(id).delete();
  }

  Future updatePhone(Phone phone) async {
    var db = Localstore.getInstance(useSupportDir: true);
    await db
        .collection('phones')
        .doc(phone.id)
        .set(phone.toMap(), SetOptions(merge: true));
  }
}
