import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/message/widgets/custom_app_bar.dart';
import 'package:stevenako_flutter/features/setting/widgets/setting_switch_card.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class NotificationsActivityScreen extends StatefulWidget {
  const NotificationsActivityScreen({super.key});

  @override
  State<NotificationsActivityScreen> createState() =>
      _NotificationsActivityScreenState();
}

class _NotificationsActivityScreenState
    extends State<NotificationsActivityScreen> {
  bool _allNotification = true;
  bool _chatManage = true;
  bool _photoVideoUpdate = false;
  bool _settingsUpdate = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialSettings();
  }

  void _fetchInitialSettings() async {
    final model = await getNotificationSettingsRxObj.getNotificationSettings();
    final settings = model?.data?.settings;
    if (settings != null && mounted) {
      setState(() {
        _allNotification = settings.allNotification ?? _allNotification;
        _chatManage = settings.chatManage ?? _chatManage;
        _photoVideoUpdate = settings.photoVideoUpdate ?? _photoVideoUpdate;
        _settingsUpdate = settings.settingsUpdate ?? _settingsUpdate;
      });
    }
  }

  void _updateAllNotification() async {
    final model = await postAllNotificationRxObj.postAllNotification(
      allNotification: _allNotification,
    );
    final settings = model?.data?.settings;
    if (settings != null && mounted) {
      setState(() {
        _allNotification = settings.allNotification ?? _allNotification;
        _chatManage = settings.chatManage ?? _chatManage;
        _photoVideoUpdate = settings.photoVideoUpdate ?? _photoVideoUpdate;
        _settingsUpdate = settings.settingsUpdate ?? _settingsUpdate;
      });
    }
  }

  void _updateSettings() async {
    final model = await postNotificationSettingsRxObj.postNotificationSettings(
      chatManage: _chatManage,
      photoVideoUpdate: _photoVideoUpdate,
      settingsUpdate: _settingsUpdate,
    );
    final settings = model?.data?.settings;
    if (settings != null && mounted) {
      setState(() {
        _allNotification = settings.allNotification ?? _allNotification;
        _chatManage = settings.chatManage ?? _chatManage;
        _photoVideoUpdate = settings.photoVideoUpdate ?? _photoVideoUpdate;
        _settingsUpdate = settings.settingsUpdate ?? _settingsUpdate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox.expand(
          child: Stack(
            children: [
              // --------------- Background Image ---------------
              Positioned.fill(
                child: Image.asset(AppImages.bg, fit: BoxFit.cover),
              ),

              // --------------- Screen Layout ---------------
              Positioned.fill(
                child: SafeArea(
                  child: Column(
                    children: [
                      // Reusable Custom App Bar
                      const CustomAppBar(title: 'Notifications & Activity'),

                      // Scrollable content
                      Expanded(
                        child: ValueListenableBuilder<bool>(
                          valueListenable:
                              getNotificationSettingsRxObj.isLoading,
                          builder: (context, isLoading, child) {
                            if (isLoading) {
                              return const Center(
                                child: CupertinoActivityIndicator(
                                  color: Colors.white,
                                  radius: 14,
                                ),
                              );
                            }

                            return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 16.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SettingSwitchCard(
                                    title: 'All Notifications',
                                    description:
                                        'Turn on or off all notifications across chat, photo and video updates, and settings with a single tap.',
                                    value: _allNotification,
                                    onChanged: (val) {
                                      setState(() {
                                        _allNotification = val;
                                        _chatManage = val;
                                        _photoVideoUpdate = val;
                                        _settingsUpdate = val;
                                      });
                                      _updateAllNotification();
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                  SettingSwitchCard(
                                    title: 'Chat Manage',
                                    description:
                                        'Stay updated with new messages and replies. Turn on notifications to never miss a conversation.',
                                    value: _chatManage,
                                    onChanged: (val) {
                                      setState(() {
                                        _chatManage = val;
                                        _allNotification =
                                            _chatManage &&
                                            _photoVideoUpdate &&
                                            _settingsUpdate;
                                      });
                                      _updateSettings();
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                  SettingSwitchCard(
                                    title: 'Photo and Video Update',
                                    description:
                                        'Keep track of your tasks with deadlines, reminders, and priorities. Collaborate with team members for better workflow.',
                                    value: _photoVideoUpdate,
                                    onChanged: (val) {
                                      setState(() {
                                        _photoVideoUpdate = val;
                                        _allNotification =
                                            _chatManage &&
                                            _photoVideoUpdate &&
                                            _settingsUpdate;
                                      });
                                      _updateSettings();
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                  SettingSwitchCard(
                                    title: 'Settings Update',
                                    description:
                                        'View real-time analytics on performance metrics. Use insights to drive better decision-making and strategies.',
                                    value: _settingsUpdate,
                                    onChanged: (val) {
                                      setState(() {
                                        _settingsUpdate = val;
                                        _allNotification =
                                            _chatManage &&
                                            _photoVideoUpdate &&
                                            _settingsUpdate;
                                      });
                                      _updateSettings();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
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
