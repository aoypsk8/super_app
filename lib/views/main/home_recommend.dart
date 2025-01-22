// ignore_for_file: avoid_unnecessary_containers
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class HomeRecommendScreen extends StatefulWidget {
  const HomeRecommendScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeRecommendScreenState createState() => _HomeRecommendScreenState();
}

class _HomeRecommendScreenState extends State<HomeRecommendScreen> {
  bool showAmount = false;
  int _current = 0;
  int _currentDropping = 0;
  int _currentLoveit = 0;
  final CarouselSliderController carouselController =
      CarouselSliderController();

  List<String> imageUrls = [
    "https://blog.ipleaders.in/wp-content/uploads/2021/10/Advertisement-Media.jpg",
    "https://blog.ipleaders.in/wp-content/uploads/2021/10/Advertisement-Media.jpg",
    "https://blog.ipleaders.in/wp-content/uploads/2021/10/Advertisement-Media.jpg",
    "https://blog.ipleaders.in/wp-content/uploads/2021/10/Advertisement-Media.jpg",
    "https://blog.ipleaders.in/wp-content/uploads/2021/10/Advertisement-Media.jpg",
  ];
  List<String> imageUrlsDropping = [
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
  ];
  List<String> loveItUrls = [
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cr_fbf7,
      floatingActionButton: SizedBox(
        width: 14.w,
        height: 14.w,
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Theme.of(context).primaryColor,
          shape: CircleBorder(),
          child: Icon(
            Iconsax.scan,
            color: Theme.of(context).colorScheme.secondary,
            size: 30,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PrimaryCardComponent(),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () => Get.toNamed('/transfer'),
                      child: TextFont(
                        text: "M Money X Transfer ",
                        color: Theme.of(context).primaryColor,
                        poppin: true,
                        fontSize: 7.5.sp,
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () => Get.toNamed('/cashOut'),
                      child: TextFont(
                        text: "M Money X Cash Out here ",
                        color: Theme.of(context).primaryColor,
                        poppin: true,
                        fontSize: 7.5.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 250),
            Container(
              color: color_fff,
              width: Get.width,
              padding: const EdgeInsets.only(top: 15, bottom: 25),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFont(
                      text: "Deal for you, ມາລີນາ!",
                      color: cr_4139,
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                      noto: true,
                    ),
                    Divider(
                      color: Theme.of(context).primaryColor,
                      thickness: 2,
                      endIndent: 310,
                    ),
                    const SizedBox(height: 20),
                    buildRecomend(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              color: color_fff,
              width: Get.width,
              padding: const EdgeInsets.only(top: 15, bottom: 25),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFont(
                      text: "Dropping Like It's Hot!",
                      color: cr_4139,
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    Divider(
                      color: Theme.of(context).primaryColor,
                      thickness: 2,
                      endIndent: 310,
                    ),
                    const SizedBox(height: 20),
                    buildDropping(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              color: color_fff,
              width: Get.width,
              padding: const EdgeInsets.only(top: 15, bottom: 25),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFont(
                      text: "Dropping Like It's Hot!",
                      color: cr_4139,
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    Divider(
                      color: Theme.of(context).primaryColor,
                      thickness: 2,
                      endIndent: 310,
                    ),
                    const SizedBox(height: 20),
                    buildLoveit(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget PrimaryCardComponent() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(MyIcon.bg_main),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 30,
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(MyIcon.bg_mmoneyx),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: color_fff,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFont(
                    text: "Primary",
                    color: Theme.of(context).textTheme.bodySmall?.color ??
                        Colors.black,
                    poppin: true,
                    fontSize: 7.5.sp,
                  ),
                ),
                const SizedBox(height: 5),
                TextFont(
                  text: "Your balance",
                  color: Theme.of(context).textTheme.bodyMedium?.color ??
                      Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 10.5.sp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFont(
                      text: showAmount ? "₭ 99,950,000.00" : "₭",
                      color: Theme.of(context).textTheme.bodyMedium?.color ??
                          Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5.sp,
                    ),
                    Container(
                      width: 35.sp,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        color: cr_black.withOpacity(0.2),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showAmount = !showAmount;
                          });
                        },
                        child: Icon(
                          showAmount ? Iconsax.eye : Iconsax.eye_slash,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildRecomend() {
    return Container(
      child: Column(
        children: [
          CarouselSlider(
            carouselController: carouselController,
            options: CarouselOptions(
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0,
              scrollDirection: Axis.horizontal,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items: imageUrls.map<Widget>((entry) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).primaryColor,
                  image: DecorationImage(
                    image: NetworkImage(entry),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),

          // Indicator for the carousel
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(imageUrls.length, (index) {
              return _current == index
                  ? Container(
                      width: 6.0.w,
                      height: 1.5.w,
                      margin: const EdgeInsets.only(left: 6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : Container(
                      width: 1.5.w,
                      height: 1.5.w,
                      margin: const EdgeInsets.only(left: 6.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cr_ecec,
                      ),
                    );
            }),
          ),
        ],
      ),
    );
  }

  Container buildDropping() {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        children: [
          CarouselSlider(
            carouselController: carouselController,
            options: CarouselOptions(
              enableInfiniteScroll: false,
              initialPage: _currentDropping + 1,
              reverse: false,
              autoPlay: true,
              enlargeCenterPage: false,
              enlargeFactor: 0,
              scrollDirection: Axis.horizontal,
              viewportFraction: 0.45,
              autoPlayInterval: const Duration(seconds: 10),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              onPageChanged: (index, reason) {
                setState(() {
                  _currentDropping = index;
                });
              },
            ),
            items: imageUrlsDropping.map<Widget>((entry) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                  image: DecorationImage(
                    image: NetworkImage(entry),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),

          // Indicator for the carousel
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(imageUrlsDropping.length, (index) {
              return _currentDropping == index
                  ? Container(
                      width: 6.0.w,
                      height: 1.5.w,
                      margin: const EdgeInsets.only(left: 6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : Container(
                      width: 1.5.w,
                      height: 1.5.w,
                      margin: const EdgeInsets.only(left: 6.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cr_ecec,
                      ),
                    );
            }),
          ),
        ],
      ),
    );
  }

  Container buildLoveit() {
    return Container(
      child: Column(
        children: [
          CarouselSlider(
            carouselController: carouselController,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.45,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0,
              scrollDirection: Axis.horizontal,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentLoveit = index;
                });
              },
            ),
            items: List.generate((loveItUrls.length / 4).ceil(), (index) {
              int start = index * 4;
              int end = start + 4;
              List<String> sublist = loveItUrls.sublist(
                  start, end > loveItUrls.length ? loveItUrls.length : end);
              return GridView.builder(
                padding: const EdgeInsets.all(5),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: sublist.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(sublist[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate((loveItUrls.length / 4).ceil(), (index) {
              return _currentLoveit == index
                  ? Container(
                      width: 6.0.w,
                      height: 1.5.w,
                      margin: const EdgeInsets.only(left: 6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : Container(
                      width: 1.5.w,
                      height: 1.5.w,
                      margin: const EdgeInsets.only(left: 6.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cr_ecec,
                      ),
                    );
            }),
          ),
        ],
      ),
    );
  }
}
