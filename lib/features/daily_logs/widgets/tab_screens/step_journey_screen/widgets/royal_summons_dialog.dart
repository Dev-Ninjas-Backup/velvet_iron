import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';

class RoyalSummonsDialog extends StatelessWidget {
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
      builder: (ctx) => RoyalSummonsDialog(
        onAccept: onAccept,
        isReread: isReread,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxHeight = size.height * 0.84;

    return PopScope(
      canPop: isReread,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 440,
            maxHeight: maxHeight,
          ),
          child: Container(
            decoration: BoxDecoration(
              // Weathered antique parchment outer frame
              color: const Color(0xFFF3E4BE),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF8B6425),
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B6425).withValues(alpha: 0.35),
                  blurRadius: 28,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.75),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                children: [
                  // 1. Authentic Aged Weathered Parchment Background
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(0.0, -0.1),
                          radius: 1.15,
                          colors: [
                            Color(0xFFFCF5E0), // Warm ivory parchment center
                            Color(0xFFF4E5BD), // Classic aged vellum
                            Color(0xFFE4CCA0), // Weathered shading
                            Color(0xFFD4B77C), // Burnt vintage edge
                          ],
                          stops: [0.0, 0.45, 0.80, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // 2. Subtle parchment fiber / texture overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFC4A25C).withValues(alpha: 0.45),
                          width: 1.0,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF7A4E1D).withValues(alpha: 0.08),
                            Colors.transparent,
                            const Color(0xFF5E3911).withValues(alpha: 0.12),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 3. Inner Decorative Imperial Border
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xFFB88C38).withValues(alpha: 0.55),
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 4. Main Scroll Content
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Parchment Ribbon
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8D4A2).withValues(alpha: 0.95),
                          border: const Border(
                            bottom: BorderSide(
                              color: Color(0xFFB38628),
                              width: 1.4,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Royal Crown Crest Seal
                            Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF851A1A),
                                border: Border.all(
                                  color: const Color(0xFFE5B947),
                                  width: 2.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.castle_rounded,
                                color: Color(0xFFFFD700),
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              'BY DECREE OF THE HIGH KING AND QUEEN',
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF381206),
                              ).copyWith(letterSpacing: 1.1),
                            ),
                            const SizedBox(height: 4),

                            Text(
                              'To those who walk between worlds,',
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF6B391A),
                              ).copyWith(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),

                      // Scrollable Royal Decree Body
                      Flexible(
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(22, 18, 22, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Dramatic Opening Banner
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFDE8E8),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xFFA83232),
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFA83232).withValues(alpha: 0.15),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'The Shattered Citadel has fallen.',
                                    textAlign: TextAlign.center,
                                    style: getTextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF781616),
                                    ).copyWith(letterSpacing: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 14),

                                _buildParagraph(
                                  'A violent rupture has torn through the boundaries separating our realms. '
                                  'Portals once thought impossible have opened, ancient powers have awakened, '
                                  'and the very foundations of our kingdom tremble beneath an approaching darkness.',
                                ),
                                const SizedBox(height: 12),

                                _buildParagraph(
                                  'Our scouts have vanished. Our roads have grown treacherous. '
                                  'Whispers of things that should not exist now travel upon the wind.',
                                ),
                                const SizedBox(height: 14),

                                Center(
                                  child: Text(
                                    'And yet, hope remains.',
                                    style: getTextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF7E4E03),
                                    ).copyWith(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                const SizedBox(height: 14),

                                _buildParagraph(
                                  'By the authority of the Crown, you are hereby summoned to undertake a journey '
                                  'into the heart of our fractured kingdom.',
                                ),
                                const SizedBox(height: 12),

                                _buildParagraph(
                                  'You shall depart from the Outpost, travel beyond the Wayfarer\'s Arch, and venture '
                                  'through lands both wondrous and perilous toward the Shattered Citadel.',
                                ),
                                const SizedBox(height: 12),

                                _buildParagraph(
                                  'The road will be long. The dangers, unknown. But you shall not walk it alone.',
                                ),
                                const SizedBox(height: 12),

                                _buildParagraph(
                                  'Every step brings us closer to the truth. Every mile carries the hope of a kingdom '
                                  'upon your shoulders.',
                                ),
                                const SizedBox(height: 16),

                                // Royal Callout Cartouche
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF4E2B4),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFB8860B),
                                      width: 1.4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFB8860B).withValues(alpha: 0.15),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Answer the summons. Begin your journey. The realm awaits.',
                                    textAlign: TextAlign.center,
                                    style: getTextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF381C03),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),

                                // Royal Sign-off & Wax Seal
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'By Order of Their Royal Majesties,',
                                          style: getTextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF5E391A),
                                          ).copyWith(fontStyle: FontStyle.italic),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'The High King and Queen',
                                          style: getTextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w900,
                                            color: const Color(0xFF381206),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFF8B1818),
                                        border: Border.all(
                                          color: const Color(0xFFD4AF37),
                                          width: 1.8,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.4),
                                            blurRadius: 5,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.shield_rounded,
                                        color: Color(0xFFFFD700),
                                        size: 19,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Action Button Footer
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE6D09A),
                          border: Border(
                            top: BorderSide(
                              color: Color(0xFFB8860B),
                              width: 1.2,
                            ),
                          ),
                        ),
                        child: CustomButton(
                          label: isReread ? 'Close Royal Decree' : 'ACCEPT THE SUMMONS',
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                            if (!isReread) {
                              onAccept?.call();
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  // Top Right Close button for re-reading mode
                  if (isReread)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context, rootNavigator: true).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A2E14),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFB8860B),
                              width: 1.2,
                            ),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Color(0xFFFFE082),
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: getTextStyle(
        fontSize: 12.8,
        color: const Color(0xFF221408),
      ).copyWith(height: 1.48, letterSpacing: 0.15),
    );
  }
}
