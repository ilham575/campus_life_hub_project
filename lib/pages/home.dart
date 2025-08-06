import 'package:campus_life_hub/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campus_life_hub/pages/profile.dart'; // Assuming profile_page.dart exists
import 'package:campus_life_hub/navbar/main_navbar.dart'; // Import the MainNavBar widget
import 'package:campus_life_hub/pages/news.dart'; // หรือ path ที่ถูกต้อง
import 'package:campus_life_hub/pages/timetable/timetable.dart';
import 'package:provider/provider.dart';
import 'package:campus_life_hub/pages/timetable/timetable_state.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      Provider.of<TimetableState>(context, listen: false).resetToToday();
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  // Define the _logout widget as a method that takes context
  Widget _logout(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff0D6EFD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        // minimumSize: const Size(double.infinity, 60), // ลบออกเพื่อไม่ให้ปุ่มกว้างสุดใน Row
        elevation: 0,
      ),
      onPressed: () async {
        await AuthService().signout(context: context);
      },
      child: const Text(
        "Sign Out",
        style: TextStyle(
          color: Colors.white, // เปลี่ยนเป็นสีที่ต้องการ เช่น Colors.blue
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> _pages = [
      // Home tab content
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(Icons.person, size: 36, color: Colors.blue.shade700),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello👋',
                              style: GoogleFonts.raleway(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              FirebaseAuth.instance.currentUser!.email!.toString(),
                              style: GoogleFonts.raleway(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // เปลี่ยนตรงนี้
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 80,
                          maxWidth: 120,
                          minHeight: 40,
                          maxHeight: 40,
                        ),
                        child: _logout(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Body: News Section
              Text(
                "ข่าวประกาศ",
                style: GoogleFonts.raleway(
                  textStyle: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // ใช้ NewsCardList จาก news.dart
              const NewsCardList(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      TimetablePage(),
      ProfilePage(), // Your Profile Page
      NewsPage(),    // หน้า News ใหม่
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: MainNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}