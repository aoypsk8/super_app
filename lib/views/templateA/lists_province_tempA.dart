import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_app/controllers/tempA_controller.dart';
import 'package:super_app/models/provider_tempA_model.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildButtonBottom.dart';
import 'package:super_app/widget/textfont.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ListsProvinceTempA extends StatefulWidget {
  ListsProvinceTempA({super.key});

  @override
  State<ListsProvinceTempA> createState() => _ListsProvinceTempAState();
}

class _ListsProvinceTempAState extends State<ListsProvinceTempA> {
  // Instantiate the TempAController
  final TempAController controller = Get.put(TempAController());

  // Variable to track selected item
  String? selectedItemCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(title: 'Select Province'),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(() {
          // Show loading indicator while data is loading
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show a message if no data is available
          if (controller.provsep.isEmpty) {
            return const Center(
              child: TextFont(
                text: 'No data available',
                color: Colors.red,
              ),
            );
          }

          // Render data grouped by `partid`
          return ListView.builder(
            itemCount: controller.provsep.length,
            itemBuilder: (context, index) {
              final part = controller.provsep[index];
              final partId = part['partid'] as String? ?? 'Unknown';
              final dataList = part['data'] as List? ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section title (partid)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFont(
                      text: 'Sector: $partId',
                      poppin: true,
                      fontWeight: FontWeight.bold,
                      color: color_primary_light,
                    ),
                  ),
                  // Use AnimationLimiter for staggered animation
                  AnimationLimiter(
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(), // Prevent GridView from scrolling
                      shrinkWrap: true, // Allow GridView to shrink and fit content
                      crossAxisCount: 3, // Number of columns
                      crossAxisSpacing: 10, // Space between columns
                      mainAxisSpacing: 10, // Space between rows
                      children: List.generate(
                        dataList.length,
                        (int gridIndex) {
                          final ProviderTempAModel item = dataList[gridIndex];

                          // Check if this item is selected
                          final isSelected = selectedItemCode == item.code;

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
                                      selectedItemCode = item.code; // Set the selected item
                                    });
                                    print('Tapped on ${item.title}'); // Adjust property name as needed
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: color_f4f4,
                                      border: Border.all(
                                        color: isSelected ? color_primary_light : color_ddd, // Change border color
                                        width: isSelected ? 2 : 1, // Thicker border when selected
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Image.asset("assets/icons/cat.png"),
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
      bottomNavigationBar: BuildButtonBottom(
        title: 'next',
        func: () {
          controller.fetchTempAList(); // Fetch data when the button is pressed
        },
      ),
    );
  }
}
