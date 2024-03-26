import 'package:flutter/material.dart';
import 'package:heathtrack/models/newsModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewModel extends StatefulWidget {
  const ViewModel({super.key});

  @override
  State<ViewModel> createState() => _ViewModelState();
}
class _ViewModelState extends State<ViewModel> {
  NewsViewModel newsViewModel = NewsViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('News'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: newsView(context),
        )
    );
  }
  Widget newsView(BuildContext context){
    Future<void> launchURL(String source) async {
      final Uri url = Uri.parse(source);
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height*1.0,
          width: MediaQuery.of(context).size.width*1.0,
          child: FutureBuilder<NewsModel>(
            future: newsViewModel.fetchNewModelApi(),
            builder: (BuildContext context,snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else{
                return ListView.builder(
                  itemCount: snapshot.data!.articles!.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: () {
                        String source = snapshot.data!.articles![index].url.toString();
                        if(source.isEmpty){
                          source = 'https://www.usatoday.com/';
                        }
                        launchURL(source);
                      },
                      child: Container(
                        padding:const EdgeInsets.symmetric(vertical: 14.0),
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height*.3,
                              width: MediaQuery.of(context).size.width*.9,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(5 ,5),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    flex: 65,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => const SizedBox(
                                          width: 20,
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 35,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!.articles![index].title.toString(),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  snapshot.data!.articles![index].publishedAt.toString(),
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w300
                                                  )
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },

          ),
        )
      ],
    );
  }
}

