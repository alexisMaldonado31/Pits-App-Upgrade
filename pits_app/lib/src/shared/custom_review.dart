import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/review_model.dart';
import 'package:pits_app/src/shared/custom_text.dart';

class CustomReview extends StatelessWidget {
  final ReviewModel review;

  const CustomReview({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final config = AppConfig.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: review.comment ?? '',
          colorText: Colors.white,
          textAlign: TextAlign.left,
          fontSize: screenSize.width * 0.04,
          fontWeight: FontWeight.w500,
        ),
        RatingBar.builder(
          initialRating: (review.stars ?? 0).toDouble(),
          minRating: 1,
          itemCount: 5,
          allowHalfRating: true,
          itemSize: screenSize.width * 0.05,
          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
          itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (_) {},
          ignoreGestures: true,
          unratedColor: Colors.white,
        ),
        Divider(color: config.secondary),
        SizedBox(height: screenSize.height * 0.02),
      ],
    );
  }
}