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
    final maxHeight = size.height * 0.82;

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
              color: const Color(0xFF140F22),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFFFD700),
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.18),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.85),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                children: [
                  // Inner subtle vignette/parchment background
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 1.2,
                          colors: [
                            const Color(0xFF261938).withValues(alpha: 0.7),
                            const Color(0xFF100B1B),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Main Content
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F0B18).withValues(alpha: 0.9),
                          border: const Border(
                            bottom: BorderSide(
                              color: Color(0xFFD6B36A),
                              width: 1.2,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Crown Icon with ambient glow
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                                border: Border.all(
                                  color: const Color(0xFFFFD700),
                                  width: 1.5,
                                ),
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
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFFFD700),
                              ).copyWith(letterSpacing: 1.1),
                            ),
                            const SizedBox(height: 4),

                            Text(
                              'To those who walk between worlds,',
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFD6B36A),
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
                                // Dramatic Opening
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2B141E).withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xFFE57373).withValues(alpha: 0.4),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    'The Shattered Citadel has fallen.',
                                    textAlign: TextAlign.center,
                                    style: getTextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFFFF8A80),
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
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFFFD700),
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

                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFD700).withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFFFD700).withValues(alpha: 0.35),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    'Answer the summons. Begin your journey. The realm awaits.',
                                    textAlign: TextAlign.center,
                                    style: getTextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFFFE082),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),

                                // Royal Sign-off & Seal
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
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white70,
                                          ).copyWith(fontStyle: FontStyle.italic),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'The High King and Queen',
                                          style: getTextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFFFD700),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFF7A1C1C),
                                        border: Border.all(
                                          color: const Color(0xFFFFD700),
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.5),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.shield_rounded,
                                        color: Color(0xFFFFD700),
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Action Button
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F0B18).withValues(alpha: 0.95),
                          border: const Border(
                            top: BorderSide(
                              color: Color(0xFFD6B36A),
                              width: 1.0,
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
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFD6B36A),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white70,
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
        fontSize: 12.5,
        color: Colors.white.withValues(alpha: 0.92),
      ).copyWith(height: 1.45),
    );
  }
}
