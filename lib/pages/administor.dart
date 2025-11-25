import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Administor extends StatefulWidget {
  const Administor({super.key});

  @override
  State<Administor> createState() => _AdministorState();
}

class _AdministorState extends State<Administor> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final items = [
      {
        'title': 'ভাইস-চ্যান্সেলর কার্যালয়',
        'icon': Icons.account_balance_rounded,
      },
      {
        'title': 'প্রো-ভাইস চ্যান্সেলর কার্যালয়',
        'icon': Icons.person_rounded,
      },
      {
        'title': 'রেজিস্ট্রার অফিস',
        'icon': Icons.apartment_rounded,
      },
      {
        'title': 'অর্থ ও হিসাব বিভাগ',
        'icon': Icons.account_balance_wallet_rounded,
      },
      {
        'title': 'পরিকল্পনা,উন্নয়ন ও ওয়ার্কস বিভাগ',
        'icon': Icons.engineering_rounded,
      },
      {
        'title': 'পরীক্ষা নিয়ন্ত্রক শাখা',
        'icon': Icons.rule_folder_rounded,
      },
      {
        'title': 'কেন্দ্রীয় গ্রন্থাগার',
        'icon': Icons.local_library_rounded,
      },
      {
        'title': 'আইসিটি সেল',
        'icon': Icons.memory_rounded,
      },
      {
        'title': 'প্রকৌশল বিভাগ',
        'icon': Icons.handyman_rounded,
      },
      {
        'title': 'আইটি সেন্টার',
        'icon': Icons.computer_rounded,
      },
      {
        'title': 'ট্রেজারার',
        'icon': Icons.payments_rounded,
      },
      {
        'title': 'কেন্দ্রীয় গবেষনাগার',
        'icon': Icons.science_rounded,
      },
      {
        'title': 'কৃষি খামার',
        'icon': Icons.agriculture_rounded,
      },
    ];

    final palettes = [
      [cs.primary, cs.primaryContainer],
      [cs.secondary, cs.secondaryContainer],
      [cs.tertiary, cs.tertiaryContainer],
      [cs.primary, cs.tertiary],
      [cs.secondary, cs.primaryContainer],
      [cs.tertiary, cs.secondaryContainer],
      [cs.primary, cs.secondary],
      [cs.tertiary, cs.primary],
      [cs.secondary, cs.tertiary],
    ];

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Administration'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width >= 900
                ? 4
                : MediaQuery.of(context).size.width >= 600
                ? 3
                : 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, i) {
            final item = items[i];
            final colors = palettes[i % palettes.length];
            final start = colors.first;
            final end = colors.last;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  final name = item['title'] as String;
                  context.push(
                    '/administration?name=${Uri.encodeComponent(name)}',
                  );
                },
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [start, end],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: end.withValues(alpha: 0.28),
                        blurRadius: 18,
                        spreadRadius: 1,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20,
                        bottom: -20,
                        child: Icon(
                          item['icon'] as IconData,
                          size: 140,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                item['icon'] as IconData,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              item['title'] as String,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'আরও দেখুন',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 16,
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
