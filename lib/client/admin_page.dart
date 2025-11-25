import 'package:flutter/material.dart';
import 'package:diary/main.dart';
import 'package:diary/client/shared.dart';
import 'package:go_router/go_router.dart';

class AdminPage extends StatefulWidget {
  final String name;

  const AdminPage({super.key, required this.name});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Future<Map<String, List<PersonItem>>> _load() async {
    final rows = await supabase
        .from('administration_administration')
        .select(
          'id, name, phone_number, email, designation, faculty_name, priority, department_name, profile_pic',
        )
        .eq('faculty_name', widget.name)
        .order('priority', ascending: true)
        .order('name', ascending: true);

    final items = rows.map<PersonItem>((r) {
      final department = (r['department_name'] as String?) ?? 'অনির্দিষ্ট বিভাগ';
      return PersonItem(
        name: r['name'] as String,
        designation: r['designation'] as String,
        phone: r['phone_number'] as String?,
        email: r['email'] as String?,
        priority: (r['priority'] as num?)?.toInt(),
        department: department,
        profilePic: r['profile_pic'] as String?,
      );
    }).toList();

    return groupByDepartment(items);
  }

  @override
  Widget build(BuildContext context) {
    final faculty = widget.name;
    return Scaffold(
      appBar: AppBar(title: Text(faculty.isEmpty ? 'প্রশাসন' : faculty)),
      body: SafeArea(
        child: faculty.isEmpty
            ? const EmptyState(message: 'প্রশাসনের নাম পাওয়া যায়নি')
            : SearchableGroupTab<PersonItem>(
                loader: _load,
                emptyMessage: 'কোনো প্রশাসনিক তথ্য পাওয়া যায়নি',
                itemBuilder: (item) => PersonCard(
                  item: item,
                  onTap: () => context.push('/person-detail', extra: item),
                ),
                searchFields: (item) => [
                  item.name,
                  item.designation,
                  item.phone ?? '',
                  item.email ?? '',
                  item.department,
                ],
              ),
      ),
    );
  }
}
