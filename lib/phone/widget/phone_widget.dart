import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crud_mvvm/phone/models/phone.dart';

class PhoneWidget extends StatelessWidget {
  final Phone phone;
  final VoidCallback? onTap;

  const PhoneWidget({Key? key, required this.phone, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        // ignore: sized_box_for_whitespace
        child: Container(
          width: 60,
          height: 60,
          // Display default image or placeholder icon if image path is null
          // ignore: unnecessary_null_comparison
          child: phone.image.value != null
              ? kIsWeb
                  ? Image.network(
                      phone.image.value,
                      fit: BoxFit.scaleDown,
                    )
                  : Image.file(
                      File(phone.image.value),
                      fit: BoxFit.scaleDown,
                    )
              : const Icon(
                  Icons.phone,
                  size: 40,
                  color: Colors.grey,
                ),
        ),
      ),
      title: Text('${phone.brand.value} ${phone.model.value}'),
      subtitle: Text(
        '${_formatCurrency(phone.price.value)} đ',
      ),
      onTap: onTap,
    );
  }

  String _formatCurrency(int amount) {
    String formattedAmount = amount.toString();
    if (formattedAmount.length <= 3) {
      return formattedAmount;
    }
    int separatorIndex = formattedAmount.length % 3;
    StringBuffer buffer = StringBuffer();
    buffer.write(formattedAmount.substring(0, separatorIndex));
    for (int i = separatorIndex; i < formattedAmount.length; i += 3) {
      if (buffer.isNotEmpty) {
        buffer.write('.');
      }
      buffer.write(formattedAmount.substring(i, i + 3));
    }
    return buffer.toString();
  }
}
