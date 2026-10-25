import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/widgets/royal_summons/crimson_wax_seal.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/widgets/royal_summons/fantasy_plaque_button.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/widgets/royal_summons/royal_heraldic_crest.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/widgets/royal_summons/scroll_decorations.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/widgets/royal_summons/scroll_roll.dart';

class RoyalSummonsDialog extends StatefulWidget {
  final VoidCallback? onAccept;
  final bool isReread;

  const RoyalSummonsDialog({
    super.key,
    this.onAccept,
    this.isReread = false,
  });

  static void show(
    BuildContext context, {
    VoidCallback? onAccept,
    bool isReread = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: isReread,
      barrierColor: Colors.black.withValues(alpha: 0.82),
      builder: (ctx) => RoyalSummonsDialog(
        onAccept: onAccept,
        isReread: isReread,
      ),
    );
  }

  @override
  State<RoyalSummonsDialog> createState() => _RoyalSummonsDialogState();
}

class _RoyalSummonsDialogState extends State<RoyalSummonsDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _unfurlAnimation;
  late final Animation<double> _fadeAnimation;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _unfurlAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.65, curve: Curves.easeIn),
      reverseCurve: const Interval(0.35, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  Future<void> _handleClose({bool triggerAccept = false}) async {
    if (_isClosing) return;
    _isClosing = true;
    try {
      await _controller.reverse();
    } catch (_) {}
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      if (triggerAccept) {
        widget.onAccept?.call();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxHeight = size.height * 0.86;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (widget.isReread && !_isClosing) {
          _handleClose(triggerAccept: false);
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (widget.isReread && !_isClosing) {
            _handleClose(triggerAccept: false);
          }
        },
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
          child: GestureDetector(
            // Prevent clicks inside the scroll from triggering backdrop dismissal
            behavior: HitTestBehavior.deferToChild,
            onTap: () {},
            child: AnimatedBuilder(
              animation: _unfurlAnimation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 430,
                      maxHeight: maxHeight,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Physical Medieval Scroll Container
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 1. Top Curled Scroll Roll / Spindle
                            const ScrollRoll(isTop: true),

                            // 2. Unfurling Parchment Body
                            Flexible(
                              child: ClipRect(
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  heightFactor: _unfurlAnimation.value,
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    decoration: BoxDecoration(
                                      // Antique parchment coloring with weathered burnt edges
                                      gradient: const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFFD6B57E), // Shaded left edge
                                          Color(0xFFFBF4DF), // Warm parchment core
                                          Color(0xFFF9F0D4), // Soft vellum highlight
                                          Color(0xFFF4E5BD), // Warm aged paper
                                          Color(0xFFCEAA72), // Shaded right edge
                                        ],
                                        stops: [0.0, 0.08, 0.50, 0.92, 1.0],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.55),
                                          blurRadius: 18,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        // Subtle aged parchment grain / vignette overlay
                                        Positioned.fill(
                                          child: CustomPaint(
                                            painter: ParchmentTexturePainter(),
                                          ),
                                        ),

                                        // Inner Decorative Double Border
                                        Positioned.fill(
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: const Color(0xFF7A4F1D)
                                                      .withValues(alpha: 0.50),
                                                  width: 1.2,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.5),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: const Color(
                                                              0xFFC29744)
                                                          .withValues(
                                                              alpha: 0.35),
                                                      width: 0.8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Decree Content Area with smooth scrolling
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: Scrollbar(
                                                thumbVisibility: true,
                                                child: SingleChildScrollView(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 22, 20, 16),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      // Top Imperial Heraldic Royal Crest
                                                      const RoyalHeraldicCrest(),
                                                      const SizedBox(height: 12),

                                                      // Header Decree Proclamation
                                                      Text(
                                                        'BY DECREE OF THE HIGH KING AND QUEEN',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.cinzel(
                                                          fontSize: 13.5.sp,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color: const Color(
                                                              0xFF3A1808),
                                                          letterSpacing: 1.5,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),

                                                      Text(
                                                        'To those who walk between worlds,',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts
                                                            .playfairDisplay(
                                                          fontSize: 12.5.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: const Color(
                                                              0xFF683E1C),
                                                          letterSpacing: 0.4,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 14),

                                                      // Ornamental Divider Flourish
                                                      const ScrollDivider(),
                                                      const SizedBox(height: 14),

                                                      // Opening Dramatic Proclamation (Directly on parchment, NO pink box)
                                                      Text(
                                                        'The Shattered Citadel has fallen.',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.cinzel(
                                                          fontSize: 14.5.sp,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: const Color(
                                                              0xFF781212),
                                                          letterSpacing: 1.0,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 14),

                                                      _buildParchmentParagraph(
                                                        'A violent rupture has torn through the boundaries separating our realms. '
                                                        'Portals once thought impossible have opened, ancient powers have awakened, '
                                                        'and the very foundations of our kingdom tremble beneath an approaching darkness.',
                                                      ),
                                                      const SizedBox(height: 11),

                                                      _buildParchmentParagraph(
                                                        'Our scouts have vanished. Our roads have grown treacherous. '
                                                        'Whispers of things that should not exist now travel upon the wind.',
                                                      ),
                                                      const SizedBox(height: 14),

                                                      // Turning point callout
                                                      Text(
                                                        'And yet, hope remains.',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts
                                                            .playfairDisplay(
                                                          fontSize: 14.0.sp,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: const Color(
                                                              0xFF6C3E08),
                                                          letterSpacing: 0.5,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 14),

                                                      _buildParchmentParagraph(
                                                        'By the authority of the Crown, you are hereby summoned to undertake a journey '
                                                        'into the heart of our fractured kingdom.',
                                                      ),
                                                      const SizedBox(height: 11),

                                                      _buildParchmentParagraph(
                                                        'You shall depart from the Outpost, travel beyond the Wayfarer\'s Arch, and venture '
                                                        'through lands both wondrous and perilous toward the Shattered Citadel.',
                                                      ),
                                                      const SizedBox(height: 11),

                                                      _buildParchmentParagraph(
                                                        'The road will be long. The dangers, unknown. But you shall not walk it alone.',
                                                      ),
                                                      const SizedBox(height: 11),

                                                      _buildParchmentParagraph(
                                                        'Every step brings us closer to the truth. Every mile carries the hope of a kingdom '
                                                        'upon your shoulders.',
                                                      ),
                                                      const SizedBox(height: 16),

                                                      // Call to Action Proclamation directly on parchment
                                                      Container(
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8),
                                                        child: Column(
                                                          children: [
                                                            const ScrollDivider(
                                                                isSubtle: true),
                                                            const SizedBox(
                                                                height: 8),
                                                            Text(
                                                              'Answer the summons. Begin your journey. The realm awaits.',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .cinzel(
                                                                fontSize:
                                                                    12.5.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: const Color(
                                                                    0xFF3C1F08),
                                                                letterSpacing:
                                                                    0.8,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          const ScrollDivider(
                                                              isSubtle: true),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 14),

                                                    // Royal Sign-Off & Wax Seal Area
                                                    const _RoyalSignOffSection(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Ornate Medieval Fantasy Plaque Button
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 6, 16, 14),
                                            child: FantasyPlaqueButton(
                                              label: widget.isReread
                                                  ? 'CLOSE ROYAL DECREE'
                                                  : 'ACCEPT THE SUMMONS',
                                              onPressed: () => _handleClose(
                                                triggerAccept: !widget.isReread,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // 3. Bottom Curled Scroll Roll / Spindle
                          const ScrollRoll(isTop: false),
                        ],
                      ),

                      // Top-right close button when re-reading decree
                      if (widget.isReread)
                        Positioned(
                          top: -6,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _handleClose(triggerAccept: false),
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const RadialGradient(
                                  colors: [
                                    Color(0xFF5A1E1E),
                                    Color(0xFF320E0E)
                                  ],
                                ),
                                border: Border.all(
                                  color: const Color(0xFFDFB65A),
                                  width: 1.6,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Color(0xFFFFE082),
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}

  Widget _buildParchmentParagraph(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: GoogleFonts.playfairDisplay(
          fontSize: 12.8.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF261608),
          height: 1.50,
          letterSpacing: 0.18,
        ),
      ),
    );
  }
}

/// Royal Sign-Off with Realistic 3D Physical Crimson Wax Seal & Ribbons
class _RoyalSignOffSection extends StatelessWidget {
  const _RoyalSignOffSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Signatures
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'By Order of Their Royal Majesties,',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 11.8.sp,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF5A3114),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'The High King and Queen',
                style: GoogleFonts.cinzel(
                  fontSize: 13.0.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF331406),
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // Physical Crimson Wax Seal with Draping Silk Ribbons
          const CrimsonWaxSeal(),
        ],
      ),
    );
  }
}
