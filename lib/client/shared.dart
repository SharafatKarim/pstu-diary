import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A generic searchable tab widget that displays grouped items
class SearchableGroupTab<T extends GroupableItem> extends StatefulWidget {
  final Future<Map<String, List<T>>> Function() loader;
  final String emptyMessage;
  final Widget Function(T item) itemBuilder;
  final List<String> Function(T item) searchFields;

  const SearchableGroupTab({
    super.key,
    required this.loader,
    required this.emptyMessage,
    required this.itemBuilder,
    required this.searchFields,
  });

  @override
  State<SearchableGroupTab<T>> createState() => _SearchableGroupTabState<T>();
}

class _SearchableGroupTabState<T extends GroupableItem>
    extends State<SearchableGroupTab<T>> {
  late Future<Map<String, List<T>>> _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _future = widget.loader();
  }

  Map<String, List<T>> _filter(Map<String, List<T>> groups) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return groups;
    final out = <String, List<T>>{};
    groups.forEach((dept, items) {
      final filtered = items.where((item) {
        final fields = widget.searchFields(item);
        return fields.any((field) => field.toLowerCase().contains(q));
      }).toList();
      if (filtered.isNotEmpty) out[dept] = filtered;
    });
    return out;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'অনুসন্ধান করুন (নাম, পদবী, ফোন, ইমেইল)',
              prefixIcon: const Icon(Icons.search),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: FutureBuilder<Map<String, List<T>>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingState();
              }
              if (snapshot.hasError) {
                return ErrorState(error: snapshot.error.toString());
              }
              final data = snapshot.data ?? const {};
              final filtered = _filter(data);
              if (filtered.isEmpty) {
                return EmptyState(message: widget.emptyMessage);
              }
              return GroupedList<T>(
                groups: filtered,
                itemBuilder: widget.itemBuilder,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// A widget that displays items grouped by sections in expansion tiles
class GroupedList<T> extends StatelessWidget {
  final Map<String, List<T>> groups;
  final Widget Function(T item) itemBuilder;

  const GroupedList({
    super.key,
    required this.groups,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final sections = groups.keys.toList()..sort();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: sections.length,
      itemBuilder: (context, i) {
        final section = sections[i];
        final items = groups[section]!;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: ExpansionTile(
              title: Text(section),
              children: [
                Column(children: [for (final item in items) itemBuilder(item)]),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A card widget for displaying person information
class PersonCard extends StatelessWidget {
  final PersonItem item;

  const PersonCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(item.profilePic ?? ''),
          child: item.profilePic == null
              ? Text(_initials(item.name), style: const TextStyle(fontSize: 16))
              : null,
        ),
        title: Text(item.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.designation),
            if ((item.phone ?? '').isNotEmpty)
              Text('ফোন: ${preparePhoneForCopy(item.phone!)}'),
            if ((item.email ?? '').isNotEmpty) Text('ইমেইল: ${item.email}'),
          ],
        ),
        trailing: _buildCopyButton(context),
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

  void _copyToClipboard(
    BuildContext context,
    String value,
    String successMsg,
  ) async {
    try {
      await Clipboard.setData(ClipboardData(text: value));
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMsg),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('কপি করা যায়নি')));
      }
    }
  }

  Widget? _buildCopyButton(BuildContext context) {
    final hasPhone = (item.phone ?? '').isNotEmpty;
    final hasEmail = (item.email ?? '').isNotEmpty;
    if (!hasPhone && !hasEmail) return null;

    if (hasPhone && hasEmail) {
      return PopupMenuButton<String>(
        tooltip: 'কপি করুন',
        icon: const Icon(Icons.copy),
        onSelected: (val) {
          if (val == 'phone') {
            _copyToClipboard(
              context,
              preparePhoneForCopy(item.phone!),
              'ফোন নম্বর কপি হয়েছে',
            );
          } else if (val == 'email') {
            _copyToClipboard(context, item.email!, 'ইমেইল কপি হয়েছে');
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(value: 'phone', child: Text('ফোন কপি করুন')),
          const PopupMenuItem(value: 'email', child: Text('ইমেইল কপি করুন')),
        ],
      );
    }

    final isPhone = hasPhone;
    final value = isPhone ? item.phone! : item.email!;
    final success = isPhone ? 'ফোন নম্বর কপি হয়েছে' : 'ইমেইল কপি হয়েছে';
    final tip = isPhone ? 'ফোন কপি করুন' : 'ইমেইল কপি করুন';
    return IconButton(
      tooltip: tip,
      icon: const Icon(Icons.copy),
      onPressed: () => _copyToClipboard(
        context,
        isPhone ? preparePhoneForCopy(value) : value,
        success,
      ),
    );
  }
}

/// Interface for items that can be grouped
abstract class GroupableItem {
  String get groupKey;
  int? get priority;
  String get sortKey;
}

/// Data model for person information
class PersonItem implements GroupableItem {
  final String name;
  final String designation;
  final String? phone;
  final String? email;
  final String? profilePic;
  @override
  final int? priority;
  final String department;

  const PersonItem({
    required this.name,
    required this.designation,
    required this.department,
    this.phone,
    this.email,
    this.profilePic,
    this.priority,
  });

  @override
  String get groupKey => department;

  @override
  String get sortKey => name.toLowerCase();
}

/// Utility function to group items by their department
Map<String, List<T>> groupByDepartment<T extends GroupableItem>(List<T> items) {
  items.sort((a, b) {
    final pa = a.priority ?? 1 << 30;
    final pb = b.priority ?? 1 << 30;
    final cmp = pa.compareTo(pb);
    if (cmp != 0) return cmp;
    return a.sortKey.compareTo(b.sortKey);
  });
  final map = <String, List<T>>{};
  for (final item in items) {
    map.putIfAbsent(item.groupKey, () => []).add(item);
  }
  return map;
}

/// Utility function to prepare phone number for copying
String preparePhoneForCopy(String raw) {
  final t = raw.trim();
  if (t.startsWith('+880')) return t; // already in intl format
  if (t.startsWith('1')) return '+880$t';
  return t;
}

// Common state widgets

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(24.0),
      child: CircularProgressIndicator(),
    ),
  );
}

class EmptyState extends StatelessWidget {
  final String message;

  const EmptyState({super.key, required this.message});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Text(message, textAlign: TextAlign.center),
    ),
  );
}

class ErrorState extends StatelessWidget {
  final String error;

  const ErrorState({super.key, required this.error});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Text('ত্রুটি: $error', textAlign: TextAlign.center),
    ),
  );
}
