import 'package:diary/main.dart';
import 'package:flutter/material.dart';

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
              ? const _EmptyState(message: 'অনুষদের নাম পাওয়া যায়নি')
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

  Future<Map<String, List<_PersonItem>>> _load() async {
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

    final items = rows.map<_PersonItem>((r) {
      final depId = (r['department_id'] as num).toInt();
      final department = depMap[depId] ?? 'অনির্দিষ্ট বিভাগ';
      return _PersonItem(
        name: r['name'] as String,
        designation: r['designation'] as String,
        phone: r['phone_number'] as String?,
        email: r['email'] as String?,
        profilePic: r['profile_pic'] as String?,
        priority: (r['priority'] as num?)?.toInt(),
        department: department,
      );
    }).toList();

    return _groupByDepartment(items);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<_PersonItem>>>(
      future: _load(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingState();
        }
        if (snapshot.hasError) {
          return _ErrorState(error: snapshot.error.toString());
        }
        final data = snapshot.data ?? const {};
        if (data.isEmpty) {
          return const _EmptyState(message: 'কোনো শিক্ষক পাওয়া যায়নি');
        }
        return _GroupedList(groups: data);
      },
    );
  }
}

class _DeanOfficeTab extends StatelessWidget {
  final String faculty;
  const _DeanOfficeTab({required this.faculty});

  Future<Map<String, List<_PersonItem>>> _load() async {
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

    final items = rows.map<_PersonItem>((r) {
      final depId = (r['department_id'] as num).toInt();
      final department = depMap[depId] ?? 'অনির্দিষ্ট বিভাগ';
      return _PersonItem(
        name: r['name'] as String,
        designation: r['designation'] as String,
        phone: r['phone_number'] as String?,
        email: r['email'] as String?,
        priority: (r['priority'] as num?)?.toInt(),
        department: department,
      );
    }).toList();

    return _groupByDepartment(items);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<_PersonItem>>>(
      future: _load(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingState();
        }
        if (snapshot.hasError) {
          return _ErrorState(error: snapshot.error.toString());
        }
        final data = snapshot.data ?? const {};
        if (data.isEmpty) {
          return const _EmptyState(message: 'কোনো তথ্য পাওয়া যায়নি');
        }
        return _GroupedList(groups: data);
      },
    );
  }
}

class _StaffTab extends StatelessWidget {
  final String faculty;
  const _StaffTab({required this.faculty});

  Future<Map<String, List<_PersonItem>>> _load() async {
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

    final items = rows.map<_PersonItem>((r) {
      final depId = (r['department_id'] as num).toInt();
      final department = depMap[depId] ?? 'অনির্দিষ্ট বিভাগ';
      return _PersonItem(
        name: r['name'] as String,
        designation: r['designation'] as String,
        phone: r['phone_number'] as String?,
        email: r['email'] as String?,
        priority: (r['priority'] as num?)?.toInt(),
        department: department,
      );
    }).toList();

    return _groupByDepartment(items);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<_PersonItem>>>(
      future: _load(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingState();
        }
        if (snapshot.hasError) {
          return _ErrorState(error: snapshot.error.toString());
        }
        final data = snapshot.data ?? const {};
        if (data.isEmpty) {
          return const _EmptyState(message: 'কোনো স্টাফ পাওয়া যায়নি');
        }
        return _GroupedList(groups: data);
      },
    );
  }
}

class _GroupedList extends StatelessWidget {
  final Map<String, List<_PersonItem>> groups;
  const _GroupedList({required this.groups});

  @override
  Widget build(BuildContext context) {
    final sections = groups.keys.toList()..sort();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: sections.length,
      itemBuilder: (context, i) {
        final section = sections[i];
        final people = groups[section]!;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: ExpansionTile(
              title: Text(section),
              children: [
                Column(
                  children: [for (final p in people) _PersonCard(item: p)],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PersonCard extends StatelessWidget {
  final _PersonItem item;
  const _PersonCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(item.profilePic ?? ''),
          child: Text(_initials(item.name)),
        ),
        title: Text(item.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.designation),
            if ((item.phone ?? '').isNotEmpty) Text('ফোন: ${item.phone}'),
            if ((item.email ?? '').isNotEmpty) Text('ইমেইল: ${item.email}'),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r"\s+"));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    final first = parts.first.isNotEmpty ? parts.first.substring(0, 1) : '';
    final last = parts.last.isNotEmpty ? parts.last.substring(0, 1) : '';
    return (first + last).toUpperCase();
  }
}

class _PersonItem {
  final String name;
  final String designation;
  final String? phone;
  final String? email;
  final String? profilePic; // reserved for future use
  final int? priority;
  final String department;

  const _PersonItem({
    required this.name,
    required this.designation,
    required this.department,
    this.phone,
    this.email,
    this.profilePic,
    this.priority,
  });
}

Map<String, List<_PersonItem>> _groupByDepartment(List<_PersonItem> items) {
  items.sort((a, b) {
    final pa = a.priority ?? 1 << 30;
    final pb = b.priority ?? 1 << 30;
    final cmp = pa.compareTo(pb);
    if (cmp != 0) return cmp;
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  });
  final map = <String, List<_PersonItem>>{};
  for (final i in items) {
    map.putIfAbsent(i.department, () => []).add(i);
  }
  return map;
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();
  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(24.0),
      child: CircularProgressIndicator(),
    ),
  );
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Text(message, textAlign: TextAlign.center),
    ),
  );
}

class _ErrorState extends StatelessWidget {
  final String error;
  const _ErrorState({required this.error});
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Text('ত্রুটি: $error', textAlign: TextAlign.center),
    ),
  );
}
