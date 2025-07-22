import 'package:flutter/material.dart';
import 'package:campus_life_hub/pages/profile_page.dart'; // ตรวจสอบเส้นทางให้ถูกต้อง

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // แนะนำให้ใช้ Material 3 ถ้าต้องการ UI ที่ทันสมัยขึ้น
      ),
      // เราจะใช้ Named Routes เพื่อจัดการการนำทาง
      // นี่เป็นวิธีที่ดีกว่าการใช้ home: MyHomePage() โดยตรงในแอปที่มีหลายหน้า
      initialRoute: '/', // กำหนดหน้าแรกเมื่อแอปเริ่ม
      routes: {
        '/': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
        '/profile': (context) => const ProfileScreen(), // กำหนดเส้นทางสำหรับหน้า Profile
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            
            const SizedBox(height: 30), // เพิ่มระยะห่าง
            
            // --- เพิ่มปุ่มนี้เข้าไป ---
            ElevatedButton(
              onPressed: () {
                // เมื่อกดปุ่มนี้ จะนำทางไปยังหน้า '/profile'
                Navigator.pushNamed(context, '/profile');
              },
              child: const Text('ไปหน้า Profile'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            // --- สิ้นสุดการเพิ่มปุ่ม ---
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}