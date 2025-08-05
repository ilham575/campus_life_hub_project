// news_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text(
            'ข่าวสาร',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // แสดงรายการข่าวในหน้า NewsPage ด้วย
          const Expanded(child: NewsCardList()),
        ],
      ),
    );
  }
}

// เพิ่ม Widget สำหรับแสดงข่าว
class NewsCardList extends StatefulWidget {
  const NewsCardList({super.key});

  @override
  State<NewsCardList> createState() => _NewsCardListState();
}

class _NewsCardListState extends State<NewsCardList> {
  String selectedCategory = 'ทั้งหมด';

  // ลบ setState ออกจาก _updateCategories
  List<String> _getCategories(List<DocumentSnapshot> docs) {
    final cats = docs.map((e) => e['category'] as String).toSet().toList();
    cats.sort();
    return ['ทั้งหมด', ...cats];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('announcement').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('เกิดข้อผิดพลาด: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('ไม่พบข่าวสาร'));
        }

        final docs = snapshot.data!.docs;
        final categories = _getCategories(docs);

        final filteredDocs = selectedCategory == 'ทั้งหมด'
            ? docs
            : docs.where((doc) => doc['category'] == selectedCategory).toList();

        return Column(
          children: [
            Row(
              children: [
                const Text('หมวดหมู่:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedCategory,
                  items: categories
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value ?? 'ทั้งหมด';
                    });
                  },
                ),
              ],
            ),
            ...filteredDocs.map((doc) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ExpansionTile(
                  leading: const Icon(Icons.campaign, color: Colors.deepPurple),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(doc['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          doc['category'] ?? '',
                          style: const TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(doc['source'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(doc['detail'] ?? ''),
                    ),
                    // Bookmark/save feature can be added here later
                  ],
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}