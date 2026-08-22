// ignore_for_file: depend_on_referenced_packages

import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/home/model/hom_screen_reals_model.dart';

import '../features/auth/log_out/data/rx.dart';
import '../features/auth/login/data/rx.dart';
import '../features/auth/login/model/login_model.dart';
import '../features/auth/register/data/rx.dart';
import '../features/auth/register/model/forgort_model.dart';
import '../features/auth/register/model/post_verify_otp_model.dart';
import '../features/auth/register/model/register_model.dart';
import '../features/auth/set_new_password/data/rx.dart';
import '../features/auth/set_new_password/model/set_new_passwrod_model.dart';
import '../features/home/data/rx.dart';
import '../features/setting/data/rx_change_pass/rx.dart';
import '../features/setting/data/rx_get_faqs/rx.dart';
import '../features/setting/model/faqs_model.dart';
import '../features/message/data/rx_get_msg_notification/rx.dart';
import '../features/message/model/msg_notification_model.dart';
import '../features/setting/data/rx_get_notification_settings/rx.dart';
import '../features/setting/data/rx_post_all_notification/rx.dart';
import '../features/setting/data/rx_post_notification_settings/rx.dart';
import '../features/setting/model/notification_settings_model.dart';

//
// SignupRx signupRxObj = SignupRx(
//   empty: SignUpModel(
//     success: false,
//     code: 0,
//     message: '',
//     data: null,
//     timestamp: '',
//   ),
//   dataFetcher: BehaviorSubject<SignUpModel>(),
// );

SigninRx signinRxObj = SigninRx(
  empty: const PostLoginModel(success: false, code: 0, message: '', data: null),
  dataFetcher: BehaviorSubject<PostLoginModel>(),
);

ForgotRx forgotRxObj = ForgotRx(
  empty: PostForgotModel(success: false, code: 0, message: '', data: null),
  dataFetcher: BehaviorSubject<PostForgotModel>(),
);

VerifyOtpRx verifyOtpRxObj = VerifyOtpRx(
  empty: PostVerifyOtpModel(success: false, code: 0, message: '', data: null),
  dataFetcher: BehaviorSubject<PostVerifyOtpModel>(),
);

SetNewPasswordRx setNewPasswordRxObj = SetNewPasswordRx(
  empty: PostSetNewPasswordModel(
    success: false,
    code: 0,
    message: '',
    data: null,
  ),
  dataFetcher: BehaviorSubject<PostSetNewPasswordModel>(),
);

RegisterRx registerRxObj = RegisterRx(
  empty: RegisterModel(success: false, code: 0, message: '', data: null),
  dataFetcher: BehaviorSubject<RegisterModel>(),
);

final GetReelsRx getReelsRxObj = GetReelsRx(
  empty: const GetReelsListModel(
    success: false,
    code: 0,
    message: '',
    data: null,
  ),
  dataFetcher: BehaviorSubject<GetReelsListModel>(),
);

LogoutRx logoutRxObj = LogoutRx(
  empty: <String, dynamic>{},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);

ChangePasswordRx changePasswordRxObj = ChangePasswordRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);

final GetFaqsRx getFaqsRxObj = GetFaqsRx(
  empty: FaqsModel(
    success: false,
    code: 0,
    message: '',
    data: null,
  ),
  dataFetcher: BehaviorSubject<FaqsModel>(),
);

final GetMsgNotificationRx getMsgNotificationRxObj = GetMsgNotificationRx(
  empty: MsgNotificationModel(
    success: false,
    code: 0,
    message: '',
    data: null,
  ),
  dataFetcher: BehaviorSubject<MsgNotificationModel>(),
);

final GetNotificationSettingsRx getNotificationSettingsRxObj =
    GetNotificationSettingsRx(
  empty: NotificationSettingsModel(
    success: false,
    code: 0,
    message: '',
    data: null,
  ),
  dataFetcher: BehaviorSubject<NotificationSettingsModel>(),
);

final PostNotificationSettingsRx postNotificationSettingsRxObj =
    PostNotificationSettingsRx(
  empty: NotificationSettingsModel(
    success: false,
    code: 0,
    message: '',
    data: null,
  ),
  dataFetcher: BehaviorSubject<NotificationSettingsModel>(),
);

final PostAllNotificationRx postAllNotificationRxObj = PostAllNotificationRx(
  empty: NotificationSettingsModel(
    success: false,
    code: 0,
    message: '',
    data: null,
  ),
  dataFetcher: BehaviorSubject<NotificationSettingsModel>(),
);


