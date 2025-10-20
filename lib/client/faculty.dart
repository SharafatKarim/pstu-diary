import 'package:diary/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'shared.dart';

class Faculty extends StatefulWidget {
  final String facultyName;

  const Faculty({super.key, required this.facultyName});

  @override
  State<Faculty> createState() => _FacultyState();
}

class _FacultyState extends State<Faculty> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final faculty = widget.facultyName;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(faculty.isEmpty ? 'অনুষদ' : faculty),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'শিক্ষক'),
              Tab(text: 'ডিন অফিস'),
              Tab(text: 'স্টাফ'),
            ],
          ),
        ),
        body: SafeArea(
          child: faculty.isEmpty
              ? const EmptyState(message: 'অনুষদের নাম পাওয়া যায়নি')
              : TabBarView(
                  children: [
                    _TeachersTab(faculty: faculty),
                    _DeanOfficeTab(faculty: faculty),
                    _StaffTab(faculty: faculty),
                  ],
                ),
        ),
      ),
    );
  }
}

class _TeachersTab extends StatelessWidget {
  final String faculty;
  const _TeachersTab({required this.faculty});

  Future<Map<String, List<PersonItem>>> _load() async {
    // Departments for teachers
    final depRows = await supabase
        .from('academy_department')
        .select('id, department')
        .eq('faculty', faculty);
    final depMap = <int, String>{
      for (final r in depRows)
        (r['id'] as num).toInt(): r['department'] as String,
    };

    final rows = await supabase
        .from('academy_teacher')
        .select(
          'id, name, phone_number, profile_pic, email, designation, faculty_name, priority, department_id',
        )
        .eq('faculty_name', faculty)
        .order('priority', ascending: true)
        .order('name', ascending: true);

    final items = rows.map<PersonItem>((r) {
      final depId = (r['department_id'] as num).toInt();
      final department = depMap[depId] ?? 'অনির্দিষ্ট বিভাগ';
      return PersonItem(
        name: r['name'] as String,
        designation: r['designation'] as String,
        phone: r['phone_number'] as String?,
        email: r['email'] as String?,
        profilePic: r['profile_pic'] as String?,
        priority: (r['priority'] as num?)?.toInt(),
        department: department,
      );
    }).toList();

    return groupByDepartment(items);
  }

  @override
  Widget build(BuildContext context) {
    return SearchableGroupTab<PersonItem>(
      loader: _load,
      emptyMessage: 'কোনো শিক্ষক পাওয়া যায়নি',
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
    );
  }
}

class _DeanOfficeTab extends StatelessWidget {
  final String faculty;
  const _DeanOfficeTab({required this.faculty});

  Future<Map<String, List<PersonItem>>> _load() async {
    // department map for dean office
    final depRows = await supabase
        .from('academy_deanfaculty')
        .select('id, department')
        .eq('faculty', faculty);
    final depMap = <int, String>{
      for (final r in depRows)
        (r['id'] as num).toInt(): r['department'] as String,
    };

    final rows = await supabase
        .from('academy_deanoffice')
        .select(
          'id, name, phone_number, email, designation, faculty, priority, department_id',
        )
        .eq('faculty', faculty)
        .order('priority', ascending: true)
        .order('name', ascending: true);

    final items = rows.map<PersonItem>((r) {
      final depId = (r['department_id'] as num).toInt();
      final department = depMap[depId] ?? 'অনির্দিষ্ট বিভাগ';
      return PersonItem(
        name: r['name'] as String,
        designation: r['designation'] as String,
        phone: r['phone_number'] as String?,
        email: r['email'] as String?,
        priority: (r['priority'] as num?)?.toInt(),
        department: department,
      );
    }).toList();

    return groupByDepartment(items);
  }

  @override
  Widget build(BuildContext context) {
    return SearchableGroupTab<PersonItem>(
      loader: _load,
      emptyMessage: 'কোনো তথ্য পাওয়া যায়নি',
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
    );
  }
}

class _StaffTab extends StatelessWidget {
  final String faculty;
  const _StaffTab({required this.faculty});

  Future<Map<String, List<PersonItem>>> _load() async {
    // department map for staff
    final depRows = await supabase
        .from('academy_staffdepartment')
        .select('id, department')
        .eq('faculty', faculty);
    final depMap = <int, String>{
      for (final r in depRows)
        (r['id'] as num).toInt(): r['department'] as String,
    };

    final rows = await supabase
        .from('academy_staff')
        .select(
          'id, name, phone_number, email, designation, faculty, priority, department_id',
        )
        .eq('faculty', faculty)
        .order('priority', ascending: true)
        .order('name', ascending: true);

    final items = rows.map<PersonItem>((r) {
      final depId = (r['department_id'] as num).toInt();
      final department = depMap[depId] ?? 'অনير्দिষ্ট বিভাগ';
      return PersonItem(
        name: r['name'] as String,
        designation: r['designation'] as String,
        phone: r['phone_number'] as String?,
        email: r['email'] as String?,
        priority: (r['priority'] as num?)?.toInt(),
        department: department,
      );
    }).toList();

    return groupByDepartment(items);
  }

  @override
  Widget build(BuildContext context) {
    return SearchableGroupTab<PersonItem>(
      loader: _load,
      emptyMessage: 'কোনো স্টাফ পাওয়া যায়নি',
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
    );
  }
}
