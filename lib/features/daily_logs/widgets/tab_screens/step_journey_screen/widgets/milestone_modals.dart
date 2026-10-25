import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/models/journey_milestone.dart';

void showMilestoneBottomSheet({
  required BuildContext context,
  required JourneyMilestone milestone,
  required int effectiveLifetime,
}) {
  final isReached = effectiveLifetime >= milestone.stepMilestone;
  final isCitadel = milestone.stepMilestone == 1000000;
  final stepsRemaining = milestone.stepMilestone - effectiveLifetime;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) {
      return Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1429),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: isCitadel ? const Color(0xFFFFD700) : const Color(0xFFD6B36A),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.7),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isReached
                        ? const Color(0xFFE5A93C).withValues(alpha: 0.2)
                        : Colors.black38,
                    border: Border.all(
                      color: isReached ? const Color(0xFFE5A93C) : Colors.white24,
                    ),
                  ),
                  child: Icon(
                    isCitadel
                        ? Icons.castle_rounded
                        : (isReached ? Icons.check_circle_rounded : Icons.place_rounded),
                    color: isReached ? const Color(0xFFE5A93C) : Colors.white70,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        milestone.name,
                        style: getTextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: isCitadel ? const Color(0xFFFFD700) : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isCitadel
                            ? '🏆 Final Destination • 1,000,000 Steps'
                            : 'Milestone: ${milestone.stepMilestone.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} steps',
                        style: getTextStyle(
                          fontSize: 12,
                          color: isCitadel ? const Color(0xFFE5A93C) : Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isReached
                        ? const Color(0xFF2E7D32).withValues(alpha: 0.3)
                        : (stepsRemaining > 0 && stepsRemaining <= 25000
                            ? const Color(0xFFE5A93C).withValues(alpha: 0.2)
                            : Colors.white10),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isReached
                          ? const Color(0xFF81C784)
                          : (stepsRemaining > 0 && stepsRemaining <= 25000
                              ? const Color(0xFFE5A93C)
                              : Colors.white24),
                    ),
                  ),
                  child: Text(
                    isReached
                        ? 'Reached'
                        : (stepsRemaining > 0 && stepsRemaining <= 25000 ? 'Upcoming' : 'Locked'),
                    style: getTextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isReached
                          ? const Color(0xFF81C784)
                          : (stepsRemaining > 0 && stepsRemaining <= 25000
                              ? const Color(0xFFFFE082)
                              : Colors.white54),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: Text(
                milestone.lore,
                style: getTextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.9),
                ).copyWith(height: 1.45),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Expedition Status:',
                  style: getTextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
                Text(
                  isReached
                      ? '✅ Milestone completed!'
                      : '${stepsRemaining.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} steps remaining',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isReached ? const Color(0xFF81C784) : const Color(0xFFE5A93C),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
}

void showAllLandmarksModal({
  required BuildContext context,
  required List<JourneyMilestone> milestones,
  required int effectiveLifetime,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) {
      return Container(
        height: MediaQuery.of(ctx).size.height * 0.75,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 24),
        decoration: const BoxDecoration(
          color: Color(0xFF181224),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(color: Color(0xFFFFD700), width: 1.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expedition Landmarks',
                      style: getTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Journey to The Shattered Citadel (1,000,000 steps)',
                      style: getTextStyle(
                        fontSize: 11,
                        color: const Color(0xFFD6B36A),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Divider(color: Colors.white12, height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: milestones.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, idx) {
                  final m = milestones[idx];
                  final isReached = effectiveLifetime >= m.stepMilestone;
                  final isCitadel = m.stepMilestone == 1000000;
                  final stepsLeft = m.stepMilestone - effectiveLifetime;

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isCitadel
                          ? const Color(0xFFFFD700).withValues(alpha: 0.08)
                          : Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isCitadel
                            ? const Color(0xFFFFD700).withValues(alpha: 0.6)
                            : (isReached ? const Color(0xFFE5A93C).withValues(alpha: 0.4) : Colors.white12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isReached
                                ? const Color(0xFFE5A93C)
                                : Colors.black38,
                          ),
                          child: Icon(
                            isCitadel
                                ? Icons.castle_rounded
                                : (isReached ? Icons.check : Icons.lock_outline),
                            color: isReached ? Colors.black : Colors.white54,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      m.name,
                                      style: getTextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: isCitadel ? const Color(0xFFFFD700) : Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isCitadel) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: const Color(0xFFFFD700), width: 0.8),
                                      ),
                                      child: const Text(
                                        'FINAL SUMMIT',
                                        style: TextStyle(
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFFFD700),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${m.stepMilestone.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} steps',
                                style: getTextStyle(
                                  fontSize: 11,
                                  color: const Color(0xFFD6B36A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isReached
                                ? const Color(0xFF2E7D32).withValues(alpha: 0.25)
                                : Colors.white10,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isReached
                                  ? const Color(0xFF81C784)
                                  : Colors.white24,
                            ),
                          ),
                          child: Text(
                            isReached
                                ? 'Completed'
                                : (stepsLeft > 0 ? '${(stepsLeft / 1000).toStringAsFixed(0)}k left' : 'Locked'),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isReached ? const Color(0xFF81C784) : Colors.white60,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
