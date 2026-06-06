import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/news_model.dart';
import 'package:pits_app/src/shared/custom_button.dart';
import 'package:pits_app/src/shared/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class News extends StatelessWidget {
  final NewsModel news;
  const News(this.news, {super.key});

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: config.accent.withOpacity(0.5),
        borderRadius: BorderRadius.circular(screenSize.height * 0.015),
      ),
      margin: EdgeInsets.only(bottom: screenSize.width * 0.05),
      padding: EdgeInsets.all(screenSize.width * 0.03),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: Colors.white.withOpacity(0.8),
              title: CustomText(
                text: news.title ?? '',
                colorText: config.primary,
                fontSize: screenSize.height * 0.026,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                height: screenSize.height * 0.5,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: CustomText(
                    text: news.body ?? '',
                    colorText: config.primary,
                    fontSize: screenSize.height * 0.022,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.02,
                horizontal: screenSize.width * 0.04,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: news.title ?? '',
              colorText: config.primary,
              fontSize: screenSize.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: screenSize.height * 0.01),
            CustomText(
              text: news.summary ?? '',
              colorText: config.primary,
              fontSize: screenSize.width * 0.04,
              fontWeight: FontWeight.w500,
            ),
            Divider(color: Colors.white),
            Center(
              child: CachedNetworkImage(
                imageUrl: news.image ?? '',
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            if (news.urlVideo != null)
              CustomButton(
                color: Colors.red[800]!,
                colorText: Colors.white,
                text: "Ver Video",
                fontSize: screenSize.width * 0.05,
                height: screenSize.height * 0.05,
                onTap: () async {
                  final uri = Uri.parse(news.urlVideo!);
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
              ),
          ],
        ),
      ),
    );
  }
}