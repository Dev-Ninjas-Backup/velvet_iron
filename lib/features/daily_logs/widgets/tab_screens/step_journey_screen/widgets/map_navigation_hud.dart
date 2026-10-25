import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';

class MapNavigationHud extends StatelessWidget {
  final String currentLocationName;
  final String nextDestinationName;
  final int stepsCompletedInLeg;
  final int legSpan;
  final int stepsRemainingInLeg;
  final double legProgressRatio;

  const MapNavigationHud({
    super.key,
    required this.currentLocationName,
    required this.nextDestinationName,
    required this.stepsCompletedInLeg,
    required this.legSpan,
    required this.stepsRemainingInLeg,
    required this.legProgressRatio,
  });

  String _formatNum(int n) =>
      n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: const Color(0xF0120D1F),
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFD6B36A),
            width: 1.2,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Current Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.place_rounded,
                          size: 13,
                          color: Color(0xFFD6B36A),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Current Location',
                          style: getTextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFD6B36A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentLocationName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getTextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Journey Arrow
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: Color(0xFFFFD700),
                ),
              ),

              // Next Destination
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Next Destination',
                          style: getTextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFFD700),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.navigation_rounded,
                          size: 13,
                          color: Color(0xFFFFD700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      nextDestinationName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getTextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFFD700),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Steps completed toward next landmark
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Steps completed: ${_formatNum(stepsCompletedInLeg)} / ${_formatNum(legSpan)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getTextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                stepsRemainingInLeg > 0
                    ? '${_formatNum(stepsRemainingInLeg)} steps to go'
                    : 'Reached!',
                style: getTextStyle(
                  fontSize: 10.5,
                  color: const Color(0xFFFFD700),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: legProgressRatio,
              minHeight: 4,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
            ),
          ),
        ],
      ),
    );
  }
}
