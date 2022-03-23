import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './home_page_controller.dart';

import './tabs/school_life_tab.dart';
import './tabs/teachers_tab.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController());
    return GetBuilder<HomePageController>(builder: (controller) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: controller.onPressedBroadcast,
                icon: const Icon(Icons.campaign_outlined),
                tooltip: "tooltips/broadcast".tr,
              ),
              IconButton(
                onPressed: controller.onPressedRefresh,
                icon: const Icon(Icons.refresh),
                tooltip: "tooltips/refresh".tr,
              ),
              IconButton(
                onPressed: controller.onPressedChangePassword,
                icon: const Icon(Icons.key),
                tooltip: "tooltips/change_password".tr,
              ),
              IconButton(
                onPressed: controller.onPressedLogout,
                icon: const Icon(Icons.logout),
                tooltip: "tooltips/logout".tr,
              ),
            ],
            title: Row(
              children: [
                Text("general/app_title".tr),
                SizedBox(width: 20),
              ],
            ),
            bottom: TabBar(
              onTap: controller.onTappedTabBar,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.people),
                      SizedBox(width: 10),
                      Text("home/school_life".tr),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.history_edu),
                      SizedBox(width: 10),
                      Text("home/teachers".tr),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SchoolLifeTab(),
              TeachersTab(),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: Text(controller.currentTab == 0
                ? "home/add_element".tr
                : "home/add_teacher".tr),
            icon: const Icon(Icons.add),
            onPressed: controller.onPressedAdd,
          ),
        ),
      );
    });
  }
}
