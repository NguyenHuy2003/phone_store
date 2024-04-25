import 'package:crud_mvvm/phone/views/phone_view_model.dart';
import 'package:flutter/material.dart';

import 'phone_details_view.dart';
import 'phone_update.dart';
import 'phone_widget.dart';

// Widget cho danh sách điện thoại
class PhoneListView extends StatefulWidget {
  const PhoneListView({Key? key}) : super(key: key);

  @override
  State<PhoneListView> createState() => _PhoneListViewState();
}

class _PhoneListViewState extends State<PhoneListView> {
  final viewModel = PhoneViewModel();
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cửa Hàng Điện Thoại'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet<Map<String, dynamic>>(
                context: context,
                builder: (context) => const PhoneUpdate(),
              ).then((value) {
                if (value != null) {
                  viewModel.addPhone(
                    value['brand'] ?? '',
                    value['model'] ?? '',
                    value['price'] ?? 0,
                    value['image'] ?? '', // Chuyển đường dẫn hình ảnh
                    value['specifications'] ?? '',
                  );
                }
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {}); // Cập nhật UI khi truy vấn tìm kiếm thay đổi
              },
              decoration: InputDecoration(
                labelText: 'Tìm kiếm',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) {
                // Lọc danh sách điện thoại dựa trên truy vấn tìm kiếm
                final filteredPhones = viewModel.phones.where((phone) {
                  final searchTerm = _searchController.text.toLowerCase();
                  final phoneBrand = phone.brand.value.toLowerCase();
                  final phoneModel = phone.model.value.toLowerCase();
                  return phoneBrand.contains(searchTerm) ||
                      phoneModel.contains(searchTerm);
                }).toList();
                return ListView.builder(
                  itemCount: filteredPhones.length,
                  itemBuilder: (context, index) {
                    final phone = filteredPhones[index];
                    return PhoneWidget(
                      key: ValueKey(phone.id),
                      phone: phone,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PhoneDetailsView(
                              phone: phone,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
