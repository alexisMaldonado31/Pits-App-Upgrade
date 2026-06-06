import 'package:flutter/material.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/news_model.dart';
import 'package:pits_app/src/services/news_service.dart';
import 'package:pits_app/src/shared/custom_title.dart';
import 'package:pits_app/src/shared/news.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final newsService = NewsService();
  List<NewsModel> news = [];

  Future<void> getNews() async {
    final result = await newsService.getNews();
    setState(() => news = result);
  }

  @override
  void initState() {
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height,
      width: screenSize.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/background.png"),
          fit: BoxFit.fill,
          colorFilter: ColorFilter.mode(
            config.secondary.withOpacity(0.95),
            BlendMode.modulate,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.05,
        vertical: screenSize.height * 0.025,
      ),
      child: Column(
        children: [
          CustomTitle(text: "Pits Live 🔴"),
          Expanded(
            child: RefreshIndicator(
              onRefresh: getNews,
              child: news.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(height: screenSize.height * 0.2),
                        Center(
                          child: Text(
                            'No hay noticias disponibles',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: news.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) => News(news[index]),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}