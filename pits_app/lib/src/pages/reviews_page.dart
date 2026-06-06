import 'package:flutter/material.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/establishments_model.dart';
import 'package:pits_app/src/models/review_model.dart';
import 'package:pits_app/src/services/categories_service.dart';
import 'package:pits_app/src/shared/custom_loading.dart';
import 'package:pits_app/src/shared/custom_review.dart';
import 'package:pits_app/src/shared/custom_text.dart';

class ReviewPage extends StatefulWidget {
  final EstablishmentsModel establishment;

  const ReviewPage({super.key, required this.establishment});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final categoriesService = CategoriesService();
  List<ReviewModel> reviews = [];
  bool loadingReviews = false;

  Future<void> loadReviews() async {
    setState(() => loadingReviews = true);
    reviews = await categoriesService
        .getReviewsByEstablishment(widget.establishment.id!);
    setState(() => loadingReviews = false);
  }

  @override
  void initState() {
    super.initState();
    loadReviews();
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews: ${widget.establishment.name ?? ''}'),
      ),
      backgroundColor: config.primary,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: loadingReviews
            ? CustomLoading()
            : reviews.isEmpty
                ? Center(
                    child: CustomText(
                      text: 'No hay reviews aún',
                      colorText: Colors.white,
                      fontSize: screenSize.width * 0.04,
                    ),
                  )
                : ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) =>
                        CustomReview(review: reviews[index]),
                  ),
      ),
    );
  }
}