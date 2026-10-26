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

  const RoyalSummonsDialog({super.key, this.onAccept, this.isReread = false});

  static void show(
    BuildContext context, {
    VoidCallback? onAccept,
    bool isReread = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: isReread,
      barrierColor: Colors.black.withValues(alpha: 0.86),
      builder: (ctx) =>
          RoyalSummonsDialog(onAccept: onAccept, isReread: isReread),
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
    final maxHeight = size.height * 0.88;

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
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 18,
          ),
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
                      maxWidth: 440,
                      maxHeight: maxHeight,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Physical Ancient Royal Decree Scroll
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 1. Top Antique Dark Timber & Bronze Scroll Rod
                            const ScrollRoll(isTop: true),

                            // 2. Unfurling Weathered High Fae Parchment Body
                            Flexible(
                              child: ClipRect(
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  heightFactor: _unfurlAnimation.value,
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      // Dark-fantasy aged parchment with scorched/weathered gradient
                                      gradient: const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(
                                            0xFF7A5424,
                                          ), // Scorched dark left edge
                                          Color(
                                            0xFFB8925A,
                                          ), // Weathered transition
                                          Color(0xFFE2CBA1), // Aged vellum core
                                          Color(
                                            0xFFD9BE8E,
                                          ), // Natural aged parchment
                                          Color(
                                            0xFFA8824A,
                                          ), // Weathered transition
                                          Color(
                                            0xFF6E481B,
                                          ), // Scorched dark right edge
                                        ],
                                        stops: [
                                          0.0,
                                          0.05,
                                          0.30,
                                          0.70,
                                          0.95,
                                          1.0,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.75,
                                          ),
                                          blurRadius: 22,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        // Weathered parchment texture, burnt vignette, and aging fibers
                                        Positioned.fill(
                                          child: CustomPaint(
                                            painter: ParchmentTexturePainter(),
                                          ),
                                        ),

                                        // Decree Content Area with smooth scrolling
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: ScrollConfiguration(
                                                behavior:
                                                    ScrollConfiguration.of(
                                                      context,
                                                    ).copyWith(
                                                      scrollbars: false,
                                                    ),
                                                child: SingleChildScrollView(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                        20,
                                                        16,
                                                        20,
                                                        24,
                                                      ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      // Official Dravosi Royal Crest Artwork
                                                      const RoyalHeraldicCrest(
                                                        size: 110,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),

                                                      // Header Decree Proclamation in High Fae Calligraphy
                                                      Text(
                                                        'BY DECREE OF THE HIGH KING AND QUEEN',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.cinzelDecorative(
                                                              fontSize: 13.5.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  const Color(
                                                                    0xFF2E1303,
                                                                  ),
                                                              letterSpacing:
                                                                  1.2,
                                                              height: 1.35,
                                                            ),
                                                      ),
                                                      const SizedBox(height: 5),

                                                      Text(
                                                        'To those who walk between worlds,',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.cormorantGaramond(
                                                              fontSize: 14.0.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color:
                                                                  const Color(
                                                                    0xFF59300E,
                                                                  ),
                                                              letterSpacing:
                                                                  0.5,
                                                            ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),

                                                      // Subtle High Fae Divider Flourish
                                                      const ScrollDivider(),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),

                                                      // Opening Proclamation with Dramatic High Fae Emphasis
                                                      Text(
                                                        'The Shattered Citadel has fallen.',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.cinzelDecorative(
                                                              fontSize: 14.5.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  const Color(
                                                                    0xFF6E0D0D,
                                                                  ),
                                                              letterSpacing:
                                                                  0.8,
                                                            ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),

                                                      _buildParchmentParagraph(
                                                        'A violent rupture has torn through the boundaries separating our realms. '
                                                        'Portals once thought impossible have opened, ancient powers have awakened, '
                                                        'and the very foundations of our kingdom tremble beneath an approaching darkness.',
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),

                                                      _buildParchmentParagraph(
                                                        'Our scouts have vanished. Our roads have grown treacherous. '
                                                        'Whispers of things that should not exist now travel upon the wind.',
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),

                                                      // Turning point callout
                                                      Text(
                                                        'And yet, hope remains.',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.cormorantGaramond(
                                                              fontSize: 15.0.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color:
                                                                  const Color(
                                                                    0xFF542E08,
                                                                  ),
                                                              letterSpacing:
                                                                  0.4,
                                                            ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),

                                                      _buildParchmentParagraph(
                                                        'By the authority of the Crown, you are hereby summoned to undertake a journey '
                                                        'into the heart of our fractured kingdom.',
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),

                                                      _buildParchmentParagraph(
                                                        'You shall depart from the Outpost, travel beyond the Wayfarer\'s Arch, and venture '
                                                        'through lands both wondrous and perilous toward the Shattered Citadel.',
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),

                                                      _buildParchmentParagraph(
                                                        'The road will be long. The dangers, unknown. But you shall not walk it alone.',
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),

                                                      _buildParchmentParagraph(
                                                        'Every step brings us closer to the truth. Every mile carries the hope of a kingdom '
                                                        'upon your shoulders.',
                                                      ),
                                                      const SizedBox(
                                                        height: 14,
                                                      ),

                                                      // Call to Action Proclamation with High Fae Ornamental Styling
                                                      Container(
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 6,
                                                            ),
                                                        child: Column(
                                                          children: [
                                                            const ScrollDivider(
                                                              isSubtle: true,
                                                            ),
                                                            const SizedBox(
                                                              height: 6,
                                                            ),
                                                            Text(
                                                              'Answer the summons. Begin your journey. The realm awaits.',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts.cinzel(
                                                                fontSize:
                                                                    12.5.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color:
                                                                    const Color(
                                                                      0xFF331604,
                                                                    ),
                                                                letterSpacing:
                                                                    0.9,
                                                                height: 1.4,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 6,
                                                            ),
                                                            const ScrollDivider(
                                                              isSubtle: true,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 14,
                                                      ),

                                                      // Official Royal Sign-Off & Dravosi Wax Seal
                                                      const _RoyalSignOffSection(),
                                                      const SizedBox(height: 8),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Ornate Medieval Fantasy Plaque Button
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                    16,
                                                    6,
                                                    16,
                                                    14,
                                                  ),
                                              child: FantasyPlaqueButton(
                                                label: widget.isReread
                                                    ? 'CLOSE ROYAL DECREE'
                                                    : 'ACCEPT THE SUMMONS',
                                                onPressed: () => _handleClose(
                                                  triggerAccept:
                                                      !widget.isReread,
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

                            // 3. Bottom Antique Dark Timber & Bronze Scroll Rod
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
                                      Color(0xFF4A1414),
                                      Color(0xFF260808),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: const Color(0xFFC79E45),
                                    width: 1.4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.65,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Color(0xFFFFD54F),
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
        style: GoogleFonts.cormorantGaramond(
          fontSize: 13.5.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1E0E03), // Deep iron-gall ink
          height: 1.55,
          letterSpacing: 0.20,
        ),
      ),
    );
  }
}

/// Royal Sign-Off with Official Dravosi Royal Wax Seal & High Fae Signatures
class _RoyalSignOffSection extends StatelessWidget {
  const _RoyalSignOffSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
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
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF502B0E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'The High King and Queen',
                style: GoogleFonts.cinzel(
                  fontSize: 13.0.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF281002),
                  letterSpacing: 0.9,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Official Dravosi Royal Wax Seal
          const CrimsonWaxSeal(size: 50),
        ],
      ),
    );
  }
}
