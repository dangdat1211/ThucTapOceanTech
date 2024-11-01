import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const MyHomePage({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content: const Text('Đây là một hộp thoại mẫu'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài tập 2 - L1'),
        actions: [
          Switch(
            value: isDarkMode,
            onChanged: onThemeChanged,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bài tập xây dựng giao diện người dùng',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Button
            ElevatedButton(
              onPressed: () => _showDialog(context),
              child: const Text('Hiển thị Dialog'),
            ),
            const SizedBox(height: 20),
            
            // Image từ assets
            const Text('Hình ảnh từ assets:'),
            const SizedBox(height: 10),
            Image.asset(
              'assets/logo_noback.png',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            
            // Image từ mạng
            const Text('Hình ảnh từ mạng:'),
            const SizedBox(height: 10),
            Image.network(
              'https://picsum.photos/300/200',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}