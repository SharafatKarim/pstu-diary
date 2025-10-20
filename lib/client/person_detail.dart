import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'shared.dart';

class PersonDetail extends StatelessWidget {
  final PersonItem person;

  const PersonDetail({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(person.name)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: person.profilePic != null
                      ? NetworkImage(person.profilePic!)
                      : null,
                  child: person.profilePic == null
                      ? Text(
                          _initials(person.name),
                          style: const TextStyle(fontSize: 32),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 24),

              // Name
              _buildInfoCard(
                icon: Icons.person,
                title: 'নাম',
                content: person.name,
              ),
              const SizedBox(height: 12),

              // Designation
              _buildInfoCard(
                icon: Icons.work,
                title: 'পদবী',
                content: person.designation,
              ),
              const SizedBox(height: 12),

              // Department
              _buildInfoCard(
                icon: Icons.business,
                title: 'বিভাগ',
                content: person.department,
              ),
              const SizedBox(height: 12),

              // Phone
              if (person.phone != null && person.phone!.isNotEmpty)
                _buildInfoCard(
                  icon: Icons.phone,
                  title: 'ফোন',
                  content: preparePhoneForCopy(person.phone!),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy),
                    tooltip: 'ফোন কপি করুন',
                    onPressed: () => _copyToClipboard(
                      context,
                      preparePhoneForCopy(person.phone!),
                      'ফোন নম্বর কপি হয়েছে',
                    ),
                  ),
                ),
              if (person.phone != null && person.phone!.isNotEmpty)
                const SizedBox(height: 12),

              // Email
              if (person.email != null && person.email!.isNotEmpty)
                _buildInfoCard(
                  icon: Icons.email,
                  title: 'ইমেইল',
                  content: person.email!,
                  trailing: IconButton(
                    icon: const Icon(Icons.copy),
                    tooltip: 'ইমেইল কপি করুন',
                    onPressed: () => _copyToClipboard(
                      context,
                      person.email!,
                      'ইমেইল কপি হয়েছে',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    Widget? trailing,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
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
}
