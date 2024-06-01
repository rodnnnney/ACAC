import 'package:acacmobile/common_layer/widgets/app_bar.dart';
import 'package:acacmobile/common_layer/widgets/welcome_text.dart';
import 'package:acacmobile/domain_layer/local_db/sort_by_country.dart';
import 'package:acacmobile/domain_layer/local_db/sort_by_food_type.dart';
import 'package:acacmobile/presentation_layer/state_management/riverpod/riverpod_user.dart';
import 'package:acacmobile/presentation_layer/widgets/home_page_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  static String id = 'home_screen';

  String cutAndLowercase(String name) {
    int spaceIndex = name.indexOf(' ');
    if (spaceIndex == -1) {
      return name.toLowerCase();
    }
    return name.substring(0, spaceIndex).toLowerCase();
  }

  final List<String> images = [
    'images/china.webp',
    'images/tofu.webp',
    'images/japan.avif',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoAsyncValue = ref.watch(userInfoProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Welcome(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        userInfoAsyncValue.when(
                          data: (Map<String, String> userinfo) {
                            final name = userinfo['name'];
                            if (name != null) {
                              return ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(colors: [
                                  Color(0xff14342B),
                                  Color(0xff60935D),
                                  Colors.white
                                ], stops: [
                                  0.05,
                                  0.97,
                                  1
                                ]).createShader(bounds),
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            } else {
                              return const Text('Name not available');
                            }
                          },
                          error: (error, stack) {
                            return const Text('Name not found :(');
                          },
                          loading: () => const Text('....'),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(

                              //borderRadius: BorderRadius.circular(12),
                              ),
                          child: const Icon(
                            Icons.qr_code_scanner_rounded,
                            size: 35,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) =>
                                  const LinearGradient(colors: [
                                Color(0xff14342B),
                                Color(0xff60935D),
                              ], stops: [
                                0.1,
                                0.9,
                              ]).createShader(bounds),
                              child: const Text(
                                'featured',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xff036D19),
                                  Color(0xff7EA172),
                                  Color(0xff60935D),
                                ],
                              ).createShader(bounds),
                              child: Text(
                                'items found: ${images.length}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                            height: screenHeight * 0.19,
                            child: PageView.builder(
                                itemCount: images.length,
                                itemBuilder: (context, index) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      images[index],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  );
                                })),
                        const SizedBox(
                          height: 20,
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              const LinearGradient(colors: [
                            Color(0xff14342B),
                            Color(0xff60935D),
                            Color(0xffF3F9D2),
                          ], stops: [
                            0.1,
                            0.9,
                            1
                          ]).createShader(bounds),
                          child: const Text(
                            'Country:',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.2,
                          // Set appropriate height for GridView
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: sortByCountry.length,
                            itemBuilder: (BuildContext context, int index) {
                              return HomeCard(
                                  displayIMG: sortByCountry[index].displayIMG,
                                  text: sortByCountry[index].text,
                                  routeName: sortByCountry[index].routeName);
                            },
                          ),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              const LinearGradient(colors: [
                            Color(0xff14342B),
                            Color(0xff60935D),
                            Color(0xffF3F9D2),
                          ], stops: [
                            0.1,
                            0.9,
                            1
                          ]).createShader(bounds),
                          child: const Text(
                            'Food Type:',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.2,
                          // Set appropriate height for GridView
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: sortByFoodType.length,
                            itemBuilder: (BuildContext context, int index) {
                              return HomeCard(
                                  displayIMG: sortByCountry[index].displayIMG,
                                  text: sortByFoodType[index].text,
                                  routeName: sortByFoodType[index].routeName);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBarBottom(
        id: id,
      ),
    );
  }
}

class CustomScrollPhysics extends BouncingScrollPhysics {
  const CustomScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  SpringDescription get spring => SpringDescription(
        mass: 80, // Mass of the spring (default is 0.5)
        stiffness: 100, // Stiffness of the spring (default is 100)
        damping: 1, // Damping (default is 1.0)
      );
}
