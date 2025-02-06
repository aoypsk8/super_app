// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/tempA_controller.dart';
import 'package:super_app/models/provider_tempA_model.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildButtonBottom.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/textfont.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ListsProvinceTempA extends StatefulWidget {
  ListsProvinceTempA({super.key});

  @override
  State<ListsProvinceTempA> createState() => _ListsProvinceTempAState();
}

class _ListsProvinceTempAState extends State<ListsProvinceTempA> {
  // Instantiate the TempAController
  final TempAController tempAcontroller = Get.put(TempAController());
  final homeController = Get.find<HomeController>();
  final box = GetStorage();

  // Variable to track selected item
  String? selectedItemCode;
  bool? isActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: homeController.getMenuTitle()),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: buildStepProcess(title: '1/5', desc: 'select_province')),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Obx(() {
                // Show loading indicator while data is loading
                if (tempAcontroller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Show a message if no data is available
                if (tempAcontroller.provsep.isEmpty) {
                  return Center(
                    child: TextFont(
                      text: 'No data available',
                      color: Theme.of(context).primaryColor,
                      poppin: true,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: tempAcontroller.provsep.length,
                  itemBuilder: (context, index) {
                    final part = tempAcontroller.provsep[index];
                    final partId = part['partid'] as String? ?? 'Unknown';
                    final dataList = part['data'] as List? ?? [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section title (partid)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextFont(
                            text: partId,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Use AnimationLimiter for staggered animation
                        AnimationLimiter(
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            children: List.generate(
                              dataList.length,
                              (int gridIndex) {
                                final ProviderTempAModel item =
                                    dataList[gridIndex];

                                // Check if this item is selected
                                final isSelected =
                                    selectedItemCode == item.code;

                                return AnimationConfiguration.staggeredGrid(
                                  position: gridIndex,
                                  duration: const Duration(milliseconds: 500),
                                  columnCount: 3,
                                  child: ScaleAnimation(
                                    child: FadeInAnimation(
                                      child: GestureDetector(
                                        onTap: () {
                                          // Update the selected item
                                          setState(() {
                                            selectedItemCode = item.code;
                                            isActive = true;
                                          });
                                          tempAcontroller.tempAdetail.value =
                                              dataList[gridIndex];
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.1)
                                                : color_f4f4,
                                            border: Border.all(
                                              color: isSelected
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.5)
                                                  : color_f4f4,
                                              width: isSelected ? 2 : 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: CachedNetworkImage(
                                                      imageUrl:
                                                          item.logo ?? ''),
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Expanded(
                                                child: TextFont(
                                                  text: item.code ?? 'No Name',
                                                  textAlign: TextAlign.center,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BuildButtonBottom(
        title: 'next',
        isActive: isActive!,
        func: () {
          tempAcontroller.fetchrecent();
          Get.toNamed('/verifyAccTempA');
        },
      ),
    );
  }
}
