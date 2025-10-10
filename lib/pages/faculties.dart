import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Faculties extends StatefulWidget {
  const Faculties({super.key});

  @override
  State<Faculties> createState() => _FacultiesState();
}

class _FacultiesState extends State<Faculties> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final faculties = [
      {'title': 'কম্পিউটার সায়েন্স এন্ড ইঞ্জিনিয়ারিং', 'icon': Icons.computer},
      {'title': 'এগ্রিকালচার', 'icon': Icons.agriculture},
      {'title': 'বিজনেস এডমিনিস্ট্রেশন', 'icon': Icons.business_center_rounded},
      {'title': 'এনিমাল সায়েন্স এন্ড ভেটেরিনারি মেডিসিন', 'icon': Icons.pets},
      {'title': 'ফিশারিজ', 'icon': Icons.water},
      {
        'title': 'এনভায়রনমেন্টাল সায়েন্স এন্ড ডিজাস্টার ম্যানজমেন্ট',
        'icon': Icons.eco_rounded,
      },
      {'title': 'নিউট্রেশন এন্ড ফুড সায়েন্স', 'icon': Icons.restaurant_rounded},
      {'title': 'ল এন্ড ল্যান্ড এডমিনিস্ট্রেশন', 'icon': Icons.gavel_rounded},
      {'title': 'পোস্টগ্র্যাজুয়েট স্টাডিজ', 'icon': Icons.school_rounded},
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
        title: const Text('Faculties'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: faculties.length,
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
            final item = faculties[i];
            final colors = palettes[i % palettes.length];
            final start = colors.first;
            final end = colors.last;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  context.push(
                    '/faculty?name=${Uri.encodeComponent(item['title'] as String)}',
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
