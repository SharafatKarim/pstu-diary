import 'dart:developer' as developer;

import 'package:diary/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableModel {
  final String name; // actual DB table name
  final String label; // user-friendly label
  final IconData icon; // icon to display in the NavigationRail
  final List<String> columns; // list of column names (fallback)
  final List<PlutoColumn>? plutoColumns; // optional: rich PlutoGrid columns
  final String primaryKey; // primary key column used for updates
  final String description; // optional: for tooltips or help text

  const TableModel({
    required this.name,
    required this.label,
    required this.icon,
    required this.columns,
    this.plutoColumns,
    this.primaryKey = 'id',
    this.description = '',
  });

  /// Build PlutoColumns if not explicitly provided, from simple column names.
  List<PlutoColumn> buildPlutoColumns() {
    if (plutoColumns != null && plutoColumns!.isNotEmpty) return plutoColumns!;
    return columns
        .map(
          (c) => PlutoColumn(
            title: c,
            field: c,
            type: PlutoColumnType.text(),
            readOnly: c == primaryKey,
            enableRowDrag: false,
            enableDropToResize: true,
            enableEditingMode: c != primaryKey,
            frozen: c == primaryKey
                ? PlutoColumnFrozen.start
                : PlutoColumnFrozen.none,
            width: c == primaryKey ? 140 : 180,
          ),
        )
        .toList();
  }
}

final List<TableModel> databaseTables = [
  TableModel(
    name: 'profiles',
    label: 'Profiles',
    icon: Icons.person,
    columns: ['id', 'username', 'role'],
    primaryKey: 'id',
    description: 'User profiles and roles',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        // readOnly: true,
        // frozen: PlutoColumnFrozen.start,
        width: 160,
      ),
      PlutoColumn(
        title: 'Username',
        field: 'username',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Role',
        field: 'role',
        type: PlutoColumnType.select(['admin', 'editor', 'user']),
      ),
    ],
  ),
  TableModel(
    name: 'academy_deanfaculty',
    label: 'Dean Faculty',
    icon: Icons.school,
    columns: ['id', 'faculty', 'department'],
    primaryKey: 'id',
    description: 'Dean faculties and departments',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(
        title: 'Faculty',
        field: 'faculty',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Department',
        field: 'department',
        type: PlutoColumnType.text(),
      ),
    ],
  ),
  TableModel(
    name: 'academy_deanoffice',
    label: 'Dean Office',
    icon: Icons.account_balance,
    columns: [
      'id',
      'name',
      'phone_number',
      'email',
      'designation',
      'faculty',
      'priority',
      'department_id',
    ],
    primaryKey: 'id',
    description: 'Dean office contacts',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(title: 'Name', field: 'name', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Phone',
        field: 'phone_number',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(title: 'Email', field: 'email', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Designation',
        field: 'designation',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Faculty',
        field: 'faculty',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Priority',
        field: 'priority',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'Department ID',
        field: 'department_id',
        type: PlutoColumnType.number(),
      ),
    ],
  ),
  TableModel(
    name: 'academy_department',
    label: 'Academy Departments',
    icon: Icons.apartment,
    columns: ['id', 'faculty', 'department'],
    primaryKey: 'id',
    description: 'Departments under academic faculties',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(
        title: 'Faculty',
        field: 'faculty',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Department',
        field: 'department',
        type: PlutoColumnType.text(),
      ),
    ],
  ),
  TableModel(
    name: 'academy_staffdepartment',
    label: 'Academy Staff Departments',
    icon: Icons.domain,
    columns: ['id', 'faculty', 'department'],
    primaryKey: 'id',
    description: 'Staff departments under academic faculties',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(
        title: 'Faculty',
        field: 'faculty',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Department',
        field: 'department',
        type: PlutoColumnType.text(),
      ),
    ],
  ),
  TableModel(
    name: 'academy_staff',
    label: 'Academy Staff',
    icon: Icons.people_alt,
    columns: [
      'id',
      'name',
      'phone_number',
      'email',
      'designation',
      'faculty',
      'priority',
      'department_id',
    ],
    primaryKey: 'id',
    description: 'Academic staff directory',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(title: 'Name', field: 'name', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Phone',
        field: 'phone_number',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(title: 'Email', field: 'email', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Designation',
        field: 'designation',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Faculty',
        field: 'faculty',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Priority',
        field: 'priority',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'Department ID',
        field: 'department_id',
        type: PlutoColumnType.number(),
      ),
    ],
  ),
  TableModel(
    name: 'academy_teacher',
    label: 'Teachers',
    icon: Icons.school_outlined,
    columns: [
      'id',
      'name',
      'phone_number',
      'profile_pic',
      'email',
      'designation',
      'faculty_name',
      'priority',
      'department_id',
    ],
    primaryKey: 'id',
    description: 'Teachers directory',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(title: 'Name', field: 'name', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Phone',
        field: 'phone_number',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Profile Pic',
        field: 'profile_pic',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(title: 'Email', field: 'email', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Designation',
        field: 'designation',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Faculty',
        field: 'faculty_name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Priority',
        field: 'priority',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'Department ID',
        field: 'department_id',
        type: PlutoColumnType.number(),
      ),
    ],
  ),
  TableModel(
    name: 'administration_administrationdepartment',
    label: 'Admin Departments',
    icon: Icons.domain,
    columns: ['id', 'faculty', 'department'],
    primaryKey: 'id',
    description: 'Administration departments',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(
        title: 'Faculty',
        field: 'faculty',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Department',
        field: 'department',
        type: PlutoColumnType.text(),
      ),
    ],
  ),
  TableModel(
    name: 'administration_administration',
    label: 'Administration',
    icon: Icons.admin_panel_settings,
    columns: [
      'id',
      'name',
      'phone_number',
      'email',
      'designation',
      'faculty_name',
      'priority',
      'department_id',
      'profile_pic',
    ],
    primaryKey: 'id',
    description: 'Administration contacts',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(title: 'Name', field: 'name', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Phone',
        field: 'phone_number',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(title: 'Email', field: 'email', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Designation',
        field: 'designation',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Faculty',
        field: 'faculty_name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Priority',
        field: 'priority',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'Department ID',
        field: 'department_id',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'Profile Pic',
        field: 'profile_pic',
        type: PlutoColumnType.text(),
      ),
    ],
  ),
  TableModel(
    name: 'administration_servicedepartment',
    label: 'Service Departments',
    icon: Icons.design_services,
    columns: ['id', 'faculty_name', 'department'],
    primaryKey: 'id',
    description: 'Service departments',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(
        title: 'Faculty',
        field: 'faculty_name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Department',
        field: 'department',
        type: PlutoColumnType.text(),
      ),
    ],
  ),
  TableModel(
    name: 'administration_services',
    label: 'Services',
    icon: Icons.home_repair_service,
    columns: [
      'id',
      'name',
      'phone',
      'designation',
      'email',
      'priority',
      'department_id',
    ],
    primaryKey: 'id',
    description: 'Administration services',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(title: 'Name', field: 'name', type: PlutoColumnType.text()),
      PlutoColumn(title: 'Phone', field: 'phone', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Designation',
        field: 'designation',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(title: 'Email', field: 'email', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Priority',
        field: 'priority',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'Department ID',
        field: 'department_id',
        type: PlutoColumnType.number(),
      ),
    ],
  ),
  TableModel(
    name: 'course_course',
    label: 'Courses',
    icon: Icons.menu_book,
    columns: [
      'id',
      'course_title',
      'course_code',
      'credit_hour',
      'faculty',
      'semester',
    ],
    primaryKey: 'id',
    description: 'Courses catalog',
    plutoColumns: [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 120,
      ),
      PlutoColumn(
        title: 'Course Title',
        field: 'course_title',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Course Code',
        field: 'course_code',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Credit Hour',
        field: 'credit_hour',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'Faculty',
        field: 'faculty',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Semester',
        field: 'semester',
        type: PlutoColumnType.text(),
      ),
    ],
  ),
];

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (supabase.auth.currentSession == null) {
        context.go('/signup');
      } else {
        _checkRole();
      }
    });
  }

  Future<void> _checkRole() async {
    try {
      final role = await supabase
          .from('profiles')
          .select('role')
          .eq('id', supabase.auth.currentSession!.user.id)
          .single();

      developer.log('role: $role');
      if (role['role'] != 'admin') {
        if (!mounted) return;
        context.go('/no-access');
      }
    } catch (e) {
      developer.log('Error fetching role: $e');
      if (!mounted) return;
      context.go('/no-access');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tables = databaseTables;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1200;
        final isMedium =
            constraints.maxWidth >= 800 && constraints.maxWidth < 1200;
        final labelType = isWide
            ? NavigationRailLabelType.none
            : (isMedium
                  ? NavigationRailLabelType.selected
                  : NavigationRailLabelType.all);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Admin Panel'),
            actions: [
              IconButton(
                tooltip: 'Sign out',
                onPressed: () async {
                  await supabase.auth.signOut();
                  if (!mounted) return;
                  // ignore: use_build_context_synchronously
                  context.go('/signup');
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: _selectedIndex,
                labelType: labelType,
                extended: isWide,
                destinations: [
                  for (final t in tables)
                    NavigationRailDestination(
                      icon: Icon(t.icon),
                      label: Text(t.label),
                    ),
                ],
                onDestinationSelected: (i) {
                  setState(() => _selectedIndex = i);
                },
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: _AdminTableView(
                  key: ValueKey('table-${tables[_selectedIndex].name}'),
                  table: tables[_selectedIndex],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AdminTableView extends StatefulWidget {
  final TableModel table;
  const _AdminTableView({super.key, required this.table});

  @override
  State<_AdminTableView> createState() => _AdminTableViewState();
}

class _AdminTableViewState extends State<_AdminTableView> {
  late List<PlutoColumn> _columns;
  List<PlutoRow> _rows = const [];
  PlutoGridStateManager? _stateManager;
  bool _loading = true;
  String? _error;
  static const String _checkField = '_checked';

  @override
  void initState() {
    super.initState();
    _columns = [
      PlutoColumn(
        title: '',
        field: _checkField,
        type: PlutoColumnType.text(),
        enableRowChecked: true,
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        width: 60,
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
      ),
      ...widget.table.buildPlutoColumns(),
    ];
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Fetch up to 200 rows to keep UI snappy
      final data = await supabase.from(widget.table.name).select().limit(200);
      final dataFields = _columns
          .where((c) => c.field != _checkField)
          .map((c) => c.field)
          .toList(growable: false);
      final rows = (data as List)
          .cast<Map<String, dynamic>>()
          .map(
            (m) => PlutoRow(
              cells: {
                _checkField: PlutoCell(value: false),
                for (final f in dataFields) f: PlutoCell(value: m[f]),
              },
            ),
          )
          .toList();
      setState(() {
        _rows = rows;
        _loading = false;
      });
      _stateManager?.removeAllRows();
      if (rows.isNotEmpty) {
        _stateManager?.appendRows(rows);
      }
    } catch (e, st) {
      developer.log(
        'Failed to fetch ${widget.table.name}',
        error: e,
        stackTrace: st,
      );
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  Future<void> _updateCell(PlutoGridOnChangedEvent e) async {
    if (e.column.field == _checkField) return; // ignore checkbox toggles
    final pk = widget.table.primaryKey;
    final row = e.row;
    final pkVal = row.cells[pk]?.value;
    if (pkVal == null) return;

    try {
      await supabase
          .from(widget.table.name)
          .update({e.column.field: e.value})
          .eq(pk, pkVal);
      // Optionally show a small feedback
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saved'),
            duration: Duration(milliseconds: 800),
          ),
        );
      }
    } catch (err, st) {
      developer.log('Failed to update cell', error: err, stackTrace: st);
      // Revert value in grid
      e.row.cells[e.column.field]!.value = e.oldValue;
      _stateManager?.notifyListeners();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Update failed: $err')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: $_error'),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _fetchData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Text(
                  widget.table.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: widget.table.description,
                  child: const Icon(Icons.info_outline, size: 18),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: _onAddPressed,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _onDeletePressed,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Refresh',
                  onPressed: _fetchData,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlutoGrid(
                    columns: _columns,
                    rows: _rows,
                    mode: PlutoGridMode.normal,
                    onLoaded: (event) {
                      _stateManager = event.stateManager;
                      // Fit columns initially
                      _stateManager!.setShowColumnFilter(true);
                    },
                    onChanged: _updateCell,
                    configuration: PlutoGridConfiguration(
                      style: Theme.of(context).brightness == Brightness.dark
                          ? PlutoGridStyleConfig.dark()
                          : PlutoGridStyleConfig(),
                    ),
                    onRowChecked: (event) {},
                  ),
                ),
        ),
      ],
    );
  }

  Future<void> _onAddPressed() async {
    if (_stateManager == null) return;
    final editableColumns = _columns
        .where((c) => c.field != _checkField && !c.readOnly)
        .toList(growable: false);

    final controllers = {
      for (final c in editableColumns) c.field: TextEditingController(text: ''),
    };
    String? error;

    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setS) {
            return AlertDialog(
              title: Text(
                'Add to ${widget.table.label}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final col in editableColumns)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: TextFormField(
                            controller: controllers[col.field],
                            decoration: InputDecoration(
                              labelText: col.title,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      if (error != null) ...[
                        const SizedBox(height: 8),
                        Text(error!, style: const TextStyle(color: Colors.red)),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(null),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    final data = <String, dynamic>{};
                    for (final col in editableColumns) {
                      final v = controllers[col.field]!.text;
                      data[col.field] = v.isEmpty ? null : v;
                    }
                    try {
                      final inserted = await supabase
                          .from(widget.table.name)
                          .insert(data)
                          .select()
                          .single();
                      if (context.mounted) {
                        // ignore: use_build_context_synchronously
                        Navigator.of(ctx).pop(inserted);
                      }
                    } catch (e) {
                      setS(() => error = '$e');
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      final newRow = PlutoRow(
        cells: {
          _checkField: PlutoCell(value: false),
          for (final c in _columns.where((c) => c.field != _checkField))
            c.field: PlutoCell(value: result[c.field]),
        },
      );
      _stateManager!.prependRows([newRow]);
      _stateManager!.setCurrentCell(newRow.cells.values.first, 0);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Row created')));
    }
  }

  Future<void> _onDeletePressed() async {
    if (_stateManager == null) return;
    final checked = _stateManager!.checkedRows;
    if (checked.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No rows selected')));
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete selected'),
        content: Text('Delete ${checked.length} selected row(s)?'),
        actions: [
          TextButton(
            // ignore: use_build_context_synchronously
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            // ignore: use_build_context_synchronously
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    final pk = widget.table.primaryKey;
    final ids = checked
        .map((r) => r.cells[pk]?.value)
        .where((v) => v != null)
        .toList();
    if (ids.isEmpty) return;

    try {
      await supabase.from(widget.table.name).delete().inFilter(pk, ids);

      _stateManager!.removeRows(checked);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Deleted ${ids.length} row(s)')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }
}
