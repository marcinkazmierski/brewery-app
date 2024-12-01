import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BeerCardShimmer extends StatelessWidget {
  const BeerCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[500]!.withOpacity(0.75),
      highlightColor: Colors.grey[100]!.withOpacity(0.75),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 65, vertical: 20),
              child: const SizedBox(height: 340),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 120, vertical: 8),
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const SizedBox(height: 40),
            ),
            Card(
              elevation: 1.0,
              margin: const EdgeInsets.symmetric(horizontal: 130, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const SizedBox(height: 20),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 160, vertical: 4),
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const SizedBox(height: 20),
            ),
            const SizedBox(height: 10),
          ]),
    );
  }
}
