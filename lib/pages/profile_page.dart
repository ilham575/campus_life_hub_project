import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 24),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.jpg'), // เปลี่ยน path ตามรูปที่มี
            ),
            SizedBox(height: 24),
            Text(
              'ชื่อผู้ใช้',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'user@email.com',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // เพิ่มฟังก์ชันแก้ไขข้อมูลที่นี่
              },
              icon: Icon(Icons.edit),
              label: Text('แก้ไขข้อมูล'),
            ),
          ],
        ),
      ),
    );
  }
}