import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './home_page_controller.dart';

import './tabs/school_life_tab.dart';
import './tabs/teachers_tab.dart';
import './tabs/broadcast_tab.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  IconData getIcon(int index) {
    switch (index) {
      case 2:
        return Icons.campaign_outlined;
      default:
        return Icons.add;
    }
  }

  String getLabel(int index) {
    switch (index) {
      case 1:
        return "home/add_teacher".tr;
      case 2:
        return "home/new_broadcast".tr;
      default:
        return "home/add_element".tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController());
    return GetBuilder<HomePageController>(builder: (controller) {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            actions: [
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
                const SizedBox(width: 20),
              ],
            ),
            bottom: TabBar(
              onTap: controller.onTappedTabBar,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.people),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          "home/school_life".tr,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.history_edu),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          "home/teachers".tr,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.campaign),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          "home/broadcasts".tr,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
              BroadcastTab(),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: Text(getLabel(controller.currentTab)),
            icon: Icon(getIcon(controller.currentTab)),
            onPressed: controller.onPressedAdd,
          ),
        ),
      );
    });
  }
}
