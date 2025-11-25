import 'package:diary/client/shared.dart';
import 'package:diary/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key, required this.name});

  final String name;

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  Future<Map<String, List<PersonItem>>> _load() async {
    // Fetch services for the selected category (faculty_name) with department_name
    final rows = await supabase
        .from('administration_services')
        .select('id, name, phone, email, designation, priority, faculty_name, department_name')
        .eq('faculty_name', widget.name)
        .order('priority', ascending: true)
        .order('name', ascending: true);

    // If no services, return empty
    if (rows.isEmpty) return {};

    final items = rows.map<PersonItem>((r) {
      final department = (r['department_name'] as String?) ?? 'অনির্দিষ্ট বিভাগ';
      return PersonItem(
        name: (r['name'] as String?)?.trim().isNotEmpty == true
            ? r['name'] as String
            : 'অনির্দিষ্ট',
        designation: (r['designation'] as String?)?.trim().isNotEmpty == true
            ? r['designation'] as String
            : 'অনির্দিষ্ট',
        phone: r['phone'] as String?,
        email: r['email'] as String?,
        priority: (r['priority'] as num?)?.toInt(),
        department: department,
        profilePic: null,
      );
    }).toList();

    return groupByDepartment(items);
  }

  @override
  Widget build(BuildContext context) {
    final faculty = widget.name;
    return Scaffold(
      appBar: AppBar(title: Text(faculty.isEmpty ? 'সেবা' : faculty)),
      body: SafeArea(
        child: faculty.isEmpty
            ? const EmptyState(message: 'সেবার নাম পাওয়া যায়নি')
            : SearchableGroupTab<PersonItem>(
                loader: _load,
                emptyMessage: 'কোনো সেবার তথ্য পাওয়া যায়নি',
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
