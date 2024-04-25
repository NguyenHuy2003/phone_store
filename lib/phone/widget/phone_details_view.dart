import 'dart:io';

import 'package:phone_store/phone/models/phone.dart';
import 'package:phone_store/phone/views/phone_view_model.dart';
import 'package:phone_store/phone/widget/phone_update.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Widget cho màn hình chi tiết điện thoại
class PhoneDetailsView extends StatefulWidget {
  final Phone phone;

  const PhoneDetailsView({Key? key, required this.phone}) : super(key: key);

  @override
  State<PhoneDetailsView> createState() => _PhoneDetailsViewState();
}

class _PhoneDetailsViewState extends State<PhoneDetailsView> {
  final viewModel = PhoneViewModel();

  // Xác nhận xóa điện thoại
  void _deletePhone(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận Xóa"),
          content:
              const Text("Bạn có chắc chắn muốn xóa điện thoại này không?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                viewModel.removePhone(widget.phone.id);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text("Xóa"),
            ),
          ],
        );
      },
    );
  }

  // Chỉnh sửa thông tin điện thoại
  void _editPhone(BuildContext context) {
    showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      builder: (context) => PhoneUpdate(
        initialBrand: widget.phone.brand.value,
        initialModel: widget.phone.model.value,
        initialPrice: widget.phone.price.value,
        initialSpecifications: widget.phone.specifications.value,
        initialImage: widget.phone.image.value,
      ),
    ).then((value) {
      if (value != null) {
        viewModel.updatePhone(
          widget.phone.id,
          value['brand'] ?? '',
          value['model'] ?? '',
          value['price'] ?? 0,
          value['specifications'] ?? '',
          value['image'], // Chuyển đường dẫn hình ảnh
        );
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Điện Thoại'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editPhone(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deletePhone(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ignore: unnecessary_null_comparison
                  if (widget.phone.image.value != null &&
                      widget.phone.image.value
                          .isNotEmpty) // Kiểm tra nếu đường dẫn hình ảnh không rỗng
                    kIsWeb
                        ? Image.network(
                            widget.phone.image.value,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.contain,
                          )
                        : Image.file(
                            File(widget.phone.image.value),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.contain,
                          )
                  else
                    Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[200],
                      child: Center(
                        child: Text(
                          'Không có Hình ảnh',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    'Thương hiệu: ${widget.phone.brand.value}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Mẫu: ${widget.phone.model.value}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Giá: ${_formatCurrency(widget.phone.price.value)} VND',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Thông số kỹ thuật: ${widget.phone.specifications.value}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
