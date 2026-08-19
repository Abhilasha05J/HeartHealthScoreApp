import 'package:flutter/material.dart';


class WorkoutsWeekBanner extends StatelessWidget {
  const WorkoutsWeekBanner({super.key, required this.sessions, this.onTap});

  final int sessions;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(28),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Workouts this week',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                'See your weekly workout totals.',
                style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 22),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$sessions ',
                      style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800),
                    ),
                    TextSpan(
                      text: 'SESSIONS',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
