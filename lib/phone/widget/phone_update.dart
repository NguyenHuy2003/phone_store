// Widget cho màn hình cập nhật điện thoại
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhoneUpdate extends StatefulWidget {
  final String? initialBrand;
  final String? initialModel;
  final int? initialPrice;
  final String? initialSpecifications;
  final String? initialImage;

  const PhoneUpdate({
    Key? key,
    this.initialBrand,
    this.initialModel,
    this.initialPrice,
    this.initialSpecifications,
    this.initialImage,
  }) : super(key: key);

  @override
  State<PhoneUpdate> createState() => _PhoneUpdateState();
}

class _PhoneUpdateState extends State<PhoneUpdate> {
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _priceController;
  late TextEditingController _specificationsController;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController(text: widget.initialBrand);
    _modelController = TextEditingController(text: widget.initialModel);
    _priceController =
        TextEditingController(text: widget.initialPrice?.toString() ?? '');
    _specificationsController =
        TextEditingController(text: widget.initialSpecifications);
    _imagePath = widget.initialImage;
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _priceController.dispose();
    _specificationsController.dispose();
    super.dispose();
  }

  // Chọn và thiết lập hình ảnh cho điện thoại
  Future<String?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return pickedFile.path;
    } else {
      return null;
    }
  }

  // Chọn và thiết lập hình ảnh cho điện thoại
  void _pickAndSetImage() async {
    final imagePath = await _pickImage();
    if (imagePath != null) {
      setState(() {
        _imagePath = imagePath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialBrand != null
            ? 'Chỉnh sửa điện thoại'
            : 'Thêm điện thoại'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop({
                'brand': _brandController.text,
                'model': _modelController.text,
                'price': int.tryParse(_priceController.text) ?? 0,
                'image': _imagePath, // Chuyển đường dẫn hình ảnh cho người gọi
                'specifications': _specificationsController.text
              });
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickAndSetImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _imagePath != null
                      ? kIsWeb
                          ? Image.network(
                              _imagePath!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(_imagePath!),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                      : const Icon(
                          Icons.add_photo_alternate,
                          size: 60,
                          color: Colors.grey,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Thương hiệu'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Mẫu'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Giá (VND)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _specificationsController,
                decoration:
                    const InputDecoration(labelText: 'Thông số kỹ thuật'),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
