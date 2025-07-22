import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์ผู้ใช้'),
        backgroundColor: Colors.blueAccent,
        elevation: 0, // ยกเลิกเงาใต้ AppBar
      ),
      body: SingleChildScrollView( // ใช้ SingleChildScrollView เพื่อให้เลื่อนดูได้หากเนื้อหาเกินหน้าจอ
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // จัดให้อยู่กึ่งกลางแนวนอน
          children: <Widget>[
            // ส่วนแสดงรูปโปรไฟล์
            Center( // ใช้ Center เพื่อจัด CircleAvatar ให้อยู่กึ่งกลาง
              child: Stack( // ใช้ Stack เพื่อวางไอคอนแก้ไขบนรูปโปรไฟล์
                children: [
                  const CircleAvatar(
                    radius: 60, // ขนาดของรูปโปรไฟล์
                    backgroundImage: NetworkImage('https://via.placeholder.com/150'), // รูปโปรไฟล์ (แทนที่ด้วยรูปจริง)
                    backgroundColor: Colors.grey, // สีพื้นหลังถ้าไม่มีรูป
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: เพิ่ม logic สำหรับแก้ไขรูปโปรไฟล์
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('แก้ไขรูปโปรไฟล์')),
                        );
                      },
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // ระยะห่าง
            
            // ส่วนแสดงชื่อผู้ใช้
            const Text(
              'อิลฮัม หะยีดอเล๊าะ', // ชื่อผู้ใช้ของคุณ
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Text(
              'ilham575@email.com', // อีเมลผู้ใช้
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),

            // ส่วนข้อมูลโปรไฟล์เป็นรายการ
            Card( // ใช้ Card เพื่อจัดกลุ่มข้อมูลให้ดูเป็นระเบียบ
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: <Widget>[
                    _buildProfileTile(
                      icon: Icons.person,
                      title: 'เพศ',
                      subtitle: 'ชาย',
                      onTap: () { /* TODO: แก้ไขข้อมูลเพศ */ },
                    ),
                    _buildProfileTile(
                      icon: Icons.calendar_today,
                      title: 'วันเกิด',
                      subtitle: '1 มกราคม 2545',
                      onTap: () { /* TODO: แก้ไขข้อมูลวันเกิด */ },
                    ),
                    _buildProfileTile(
                      icon: Icons.location_on,
                      title: 'ที่อยู่',
                      subtitle: 'สงขลา, ประเทศไทย',
                      onTap: () { /* TODO: แก้ไขข้อมูลที่อยู่ */ },
                    ),
                    _buildProfileTile(
                      icon: Icons.phone,
                      title: 'เบอร์โทรศัพท์',
                      subtitle: '08X-XXX-XXXX',
                      onTap: () { /* TODO: แก้ไขเบอร์โทรศัพท์ */ },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ปุ่มออกจากระบบ (Logout)
            SizedBox(
              width: double.infinity, // ทำให้ปุ่มกว้างเต็มพื้นที่
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: เพิ่ม logic สำหรับออกจากระบบ
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ออกจากระบบแล้ว')),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('ออกจากระบบ', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // สีปุ่ม
                  foregroundColor: Colors.white, // สีตัวอักษร
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget ช่วยสร้าง ListTile สำหรับข้อมูลโปรไฟล์
  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap, // Optional onTap function
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent, size: 30),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
      trailing: onTap != null ? const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey) : null,
      onTap: onTap, // ถ้า onTap ไม่ใช่ null ก็สามารถคลิกได้
    );
  }
}