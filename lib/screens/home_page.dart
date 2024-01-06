import 'dart:convert';
import 'package:cuteporium_app/widgets/trending_breathwork.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cuteporium_app/widgets/your_breathwork.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

int _currentPage = 0;
int index = 0;
List videosLink = [];
List apiVideoId = [];
List apiVideoTitle = [];
List apiVideoThumbnail = [];
late PageController _pageController;

int page = 3;

String? apiVideoLink;

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    fetchapi();
  }

  //fetching api (in this case i am using paxales)
  fetchapi() async {
    try {
      http.Response response = await http.get(
        Uri.parse('https://api.pexels.com/videos/popular?per_page=2'),
        headers: {
          'Authorization':
              'lqAEwAtzTvCyg79YWd6d4yaRb7ndy3bM2jdjtKlxs7NhznMQd9Ik4aHe'
        },
      );

      //connection is establish if recvied statuscode 200
      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body);
        setState(() {
          videosLink = result['videos'];
          if (videosLink.isNotEmpty) {
            apiVideoThumbnail = List.generate(
              videosLink.length,
              (index) => videosLink[index]["video_pictures"][0]['picture'],
            );

            //api video link in this variable
            apiVideoLink = videosLink[0]['video_files'][0]['link'];

            //api video thumbnail in this variable
            apiVideoThumbnail = videosLink[0]["video_pictures"][0]['picture'];

            //video id in this variable
            apiVideoId = videosLink[0]['video_files'][0]['link'];

            //test your calling
            print('showVideoLink : ,$apiVideoLink');
            print('showVideoId : ,$apiVideoId');
            print('showVideoThumbnail : ,$apiVideoThumbnail');
          }
        });
      } else {
        // Handle other status codes
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      // Handle exceptions
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.black45, Colors.indigo],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top card which can traverse
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 250.0,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: 3,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 30.0, left: 15, right: 20),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                image: DecorationImage(
                                  image:
                                      AssetImage('lib/assets/images/stars.jpg'),
                                  fit: BoxFit
                                      .cover, // Set the fit property to cover the entire container
                                ),
                              ),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 30, bottom: 10),
                                        child: Text(
                                          'My Prayers.Club',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Create AI generated personalized \nbreathing exercise videos as per your \nfeelings',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15, bottom: 20),
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 4),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.handSparkles,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Create your video',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  DotsIndicator(
                    dotsCount: 3,
                    position: _currentPage.toInt(),
                    decorator: DotsDecorator(
                      color: Colors.grey,
                      activeColor: Colors.green,
                    ),
                  ),
                ],
              ),

              // TrendingBreathwork widget
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trending Breathwork',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    FutureBuilder(
                      future: fetchapi(), // Use the fetchapi() method here
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Loading indicator while fetching data
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return SizedBox(
                            height: 300,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: videosLink.length,
                              itemBuilder: (context, index) {
                                final apiVideoLink =
                                    videosLink[index]['video_files'][0]['link'];
                                final apiVideoId =
                                    videosLink[index]['video_files'][0]['id'];
                                return Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: SizedBox(
                                    width: 240,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TrendingBreathwork(
                                          videoId: '$apiVideoId',
                                          videoLink: '$apiVideoLink',
                                          videoThumbnail: '$apiVideoThumbnail',
                                        ),
                                        SizedBox(height: 3),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              // YourBreathwork widget
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Your Breathwork',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    FutureBuilder(
                      future: fetchapi(), // Use the fetchapi() method here
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Loading indicator while fetching data
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return SizedBox(
                            height: 300,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: videosLink.length,
                              itemBuilder: (context, index) {
                                final apiVideoLink =
                                    videosLink[index]['video_files'][0]['link'];
                                final apiVideoId =
                                    videosLink[index]['video_files'][0]['id'];
                                return Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: SizedBox(
                                    width: 240,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        YourBreathwork(
                                          videoId: '$apiVideoId',
                                          videoLink: '$apiVideoLink',
                                        ),
                                        SizedBox(height: 3),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              // below card
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      image: AssetImage('lib/assets/images/sunset.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'You have ',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '1 credit',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' available \nto create \npersonalized video',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 20, right: 10),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.handSparkles,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Create video',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
