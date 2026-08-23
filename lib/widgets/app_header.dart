import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackops/screens/dashboard_screen.dart';
import 'package:trackops/screens/stations_screen.dart';
import 'package:trackops/theme.dart';

class AppHeader extends StatefulWidget {
  final bool isConnected;
  final bool returnHome;
  const AppHeader(
      {super.key, this.returnHome = false, required this.isConnected});

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  @override
  Widget build(BuildContext context) {
    bool isHovered = false;
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border2)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
              color: AppColors.accent, borderRadius: BorderRadius.circular(6)),
          child: const Icon(Icons.train, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        RichText(
            text: TextSpan(
          style: GoogleFonts.barlowCondensed(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textMain,
              letterSpacing: 1),
          children: [
            const TextSpan(text: 'Track'),
            const TextSpan(
                text: 'Ops', style: TextStyle(color: AppColors.accent)),
          ],
        )),
        const Spacer(),
        if (!widget.returnHome) ...[
          StatefulBuilder(builder: (context, setState) {
            return MouseRegion(
              onEnter: (_) => setState(() => isHovered = true),
              onExit: (_) => setState(() => isHovered = false),
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => stationsScreen()));
                },
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Configure Station Distance',
                          style: GoogleFonts.dmMono(
                              fontSize: 12,
                              color: AppColors.textMain,
                              height: 1.0,
                              decoration:
                                  isHovered ? TextDecoration.underline : null)),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_right_alt_rounded,
                          color: AppColors.accent, size: 16),
                    ]),
              ),
            );
          })
        ],
        if (widget.returnHome) ...[
          StatefulBuilder(builder: (context, setState) {
            return MouseRegion(
              onEnter: (_) => setState(() => isHovered = true),
              onExit: (_) => setState(() => isHovered = false),
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_left_rounded,
                          color: AppColors.accent, size: 16),
                      const SizedBox(width: 6),
                      Text('Back to Dashboard',
                          style: GoogleFonts.dmMono(
                              fontSize: 12,
                              color: AppColors.textMain,
                              height: 1.0,
                              decoration:
                                  isHovered ? TextDecoration.underline : null)),
                    ]),
              ),
            );
          })
        ],
        const SizedBox(width: 16),
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: widget.isConnected ? AppColors.active : AppColors.critical,
              shape: BoxShape.circle,
            )),
        const SizedBox(width: 6),
        Text(widget.isConnected ? 'LIVE' : 'CONNECTING...',
            style: GoogleFonts.dmMono(
                fontSize: 12,
                color: widget.isConnected
                    ? AppColors.active
                    : AppColors.critical)),
        const SizedBox(width: 16),
        Text('Firebase Realtime DB',
            style: GoogleFonts.dmMono(fontSize: 11, color: AppColors.muted)),
      ]),
    );
  }
}
