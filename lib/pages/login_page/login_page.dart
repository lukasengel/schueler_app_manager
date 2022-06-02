import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import './login_page_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginPageController());
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Get.theme.scaffoldBackgroundColor
          : Get.theme.colorScheme.primary,
      body: Column(
        children: [
// ###################################################################################
// #                              LOGO AND HEADLINE                                  #
// ###################################################################################
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: FractionallySizedBox(
                heightFactor: 0.6,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CircleAvatar(
                        backgroundColor: Get.theme.colorScheme.primary,
                        radius: double.infinity,
                        child: const ImageIcon(
                          AssetImage("assets/images/logo.png"),
                          color: Colors.white,
                          size: double.infinity,
                        ),
                      ),
                    ),
                    Expanded(
                      child: FittedBox(
                        child: Text(
                          "general/app_title".tr,
                          textAlign: TextAlign.center,
                          style: context.textTheme.headlineLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              width: context.width >= 500 ? 500 : double.infinity,
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.tertiary,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 15,
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "login/login_header".tr,
                          style: Get.textTheme.headlineMedium,
                        ),
                      ),
                    ),
                    // ###################################################################################
                    // #                                  LOGIN FORM                                     #
                    // ###################################################################################
                    SizedBox(
                      width: context.width >= 800
                          ? context.width / 2
                          : double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            enableSuggestions: false,
                            autocorrect: false,
                            style: context.textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: "login/username".tr,
                              fillColor: Get.theme.colorScheme.onTertiary,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            autofillHints: const [AutofillHints.username],
                            controller: controller.usernameController,
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 10),
                          Obx(
                            () => TextField(
                              enableSuggestions: false,
                              autocorrect: false,
                              style: context.textTheme.bodyMedium,
                              decoration: InputDecoration(
                                hintText: "login/password".tr,
                                suffixIcon: IconButton(
                                  splashRadius: 20,
                                  icon: Icon(
                                    controller.obscure.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: controller.toggleVisibility,
                                  color: Get.isDarkMode
                                      ? Get
                                          .theme.colorScheme.onTertiaryContainer
                                      : null,
                                  tooltip: "tooltips/toggle_visibility".tr,
                                ),
                                fillColor: Get.theme.colorScheme.onTertiary,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              autofillHints: const [AutofillHints.password],
                              controller: controller.passwortController,
                              textInputAction: TextInputAction.done,
                              obscureText: controller.obscure.value,
                              onSubmitted: (_) => controller.login(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Obx(() => SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: controller.login,
                                    child: controller.working.value
                                        ? const SpinKitThreeBounce(
                                            color: Colors.white,
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child:
                                                Text("login/login_button".tr),
                                          ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    // ###################################################################################
                    // #                                  BOTTOM TEXT                                    #
                    // ###################################################################################
                    Text(
                      "general/school_name".tr.toUpperCase(),
                      style: Get.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
