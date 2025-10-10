import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final services = [
      {'title': 'সাধারন সেবা', 'icon': Icons.miscellaneous_services_rounded},
      {'title': 'ইনোভেশন ডেসিমিনেশন সেন্টার', 'icon': Icons.lightbulb_rounded},
      {'title': 'অন্যান্য', 'icon': Icons.more_horiz_rounded},
      {'title': 'লিগ্যাল এডভাইজরি শাখা', 'icon': Icons.gavel_rounded},
      {'title': 'জরুরী সেবা', 'icon': Icons.sos_rounded},
      {'title': 'পরিবহন', 'icon': Icons.directions_bus_filled_rounded},
      {'title': 'ক্লাব সমূহ', 'icon': Icons.groups_rounded},
      {'title': 'মসজিদ সমূহ', 'icon': Icons.place_rounded},
      {'title': 'অধিকতর উন্নয়ন প্রকল্প', 'icon': Icons.engineering_rounded},
      {'title': 'হল সমূহ', 'icon': Icons.apartment_rounded},
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
        title: const Text('Services'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: services.length,
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
            final item = services[i];
            final colors = palettes[i % palettes.length];
            final start = colors.first;
            final end = colors.last;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  context.push(
                    '/services?name=${Uri.encodeComponent(item['title'] as String)}',
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
