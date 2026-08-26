// ignore_for_file: depend_on_referenced_packages

import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/home/data/post_api/rx.dart';
import 'package:stevenako_flutter/features/home/model/get_all_photo_model.dart';
import 'package:stevenako_flutter/features/home/model/hom_screen_reals_model.dart';
import 'package:stevenako_flutter/features/message/data/rx_message_list/rx.dart';

import '../features/auth/log_out/data/rx.dart';
import '../features/auth/login/data/rx.dart';
import '../features/auth/login/model/login_model.dart';
import '../features/auth/profile_setup/data/rx.dart';
import '../features/auth/profile_setup/model/sing_up_profiel_satep_model.dart';
import '../features/auth/register/data/rx.dart';
import '../features/auth/register/model/forgort_model.dart';
import '../features/auth/register/model/post_verify_otp_model.dart';
import '../features/auth/register/model/register_model.dart';
import '../features/auth/set_new_password/data/rx.dart';
import '../features/auth/set_new_password/model/set_new_passwrod_model.dart';
import '../features/home/data/get_all_photo_api/rx.dart';
import '../features/home/data/rx.dart';

import '../features/home/model/get_all_post_model.dart';
import '../features/message/data/rx_delete_message/rx.dart';
import '../features/message/data/rx_get_conversation_messages/rx.dart';
import '../features/message/data/rx_post_send_message/rx.dart';
import '../features/message/data/rx_post_block_user/rx.dart';
import '../features/message/model/conversation_details_model.dart';
import '../features/message/model/conversation_list_model.dart';

import '../features/setting/data/rx_change_pass/rx.dart';
import '../features/setting/data/rx_delete_user/rx.dart';
import '../features/setting/data/rx_get_user_profile/rx.dart';
import '../features/setting/model/user_profile_model.dart';
import '../features/setting/data/rx_get_faqs/rx.dart';
import '../features/setting/model/faqs_model.dart';
import '../features/message/data/rx_get_msg_notification/rx.dart';
import '../features/message/model/msg_notification_model.dart';
import '../features/setting/data/rx_get_notification_settings/rx.dart';
import '../features/setting/data/rx_post_all_notification/rx.dart';
import '../features/setting/data/rx_get_my_blocked_users/rx.dart';
import '../features/setting/data/rx_post_block_or_unblock_user/rx.dart';
import '../features/setting/data/rx_post_report_user/rx.dart';
import '../features/setting/model/my_blocked_users_model.dart';
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
  empty: FaqsModel(success: false, code: 0, message: '', data: null),
  dataFetcher: BehaviorSubject<FaqsModel>(),
);

final GetMsgNotificationRx getMsgNotificationRxObj = GetMsgNotificationRx(
  empty: MsgNotificationModel(success: false, code: 0, message: '', data: null),
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

//
//
// OtpVerifyRx otpVerifyRxObj = OtpVerifyRx(
//   empty: OtpVerifyModel(
//     success: false,
//     code: 0,
//     message: "",
//     data: null,
//     timestamp: "",
//   ),
//   dataFetcher: BehaviorSubject<OtpVerifyModel>(),
// );
//
final GetAllPostRx getAllPostRxObj = GetAllPostRx(
  empty: GetAllPostModel(success: false, code: 0, message: '', data: null),
  dataFetcher: BehaviorSubject<GetAllPostModel>(),
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

final GetAllPhotoRx getAllPhotoRxObj = GetAllPhotoRx(
  empty: GetAllPhotoModel(success: false, code: 0, message: '', data: null),
  dataFetcher: BehaviorSubject<GetAllPhotoModel>(),
);

//
//
//
//
final GetConversationListRx getConversationListRxObj = GetConversationListRx(
  empty: ConversationListModel(
    success: false,
    code: 0,
    message: '',
    data: null,
  ),
  dataFetcher: BehaviorSubject<ConversationListModel>(),
);

final GetConversationListRx getAllMessageListRxObj = getConversationListRxObj;

final GetConversationMessagesRx getConversationMessagesRxObj =
    GetConversationMessagesRx(
  empty: ConversationDetailsModel(
    success: false,
    code: 0,
    message: '',
    data: null,
  ),
  dataFetcher: BehaviorSubject<ConversationDetailsModel>(),
);

final PostSendMessageRx postSendMessageRxObj = PostSendMessageRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);

final DeleteMessageRx deleteMessageRxObj = DeleteMessageRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);

final BlockUserRx postBlockUserRxObj = BlockUserRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);
//
PostSetProfileRx postSetProfileRxObj = PostSetProfileRx(
  empty: PostSingUpProfielSatipModel(
    success: false,
    code: 0,
    message: '',
    data: null,
  ),
  dataFetcher: BehaviorSubject<PostSingUpProfielSatipModel>(),
);
//
// PutProfielUpdageRx profielUpdageRxObj = PutProfielUpdageRx(
//   empty: UserProfileInfoUpdateModel(
//     success: false,
//     code: 0,
//     message: "",
//     data: null,
//     timestamp: "",
//   ),
//   dataFetcher: BehaviorSubject<UserProfileInfoUpdateModel>(),
// );
//
//
// GetModelDetailsRx getModelDetailsRxObj = GetModelDetailsRx(
//   empty: GetModelDetailsModel(
//     success: false,
//     code: 0,
//     message: "",
//     data: null,
//     timestamp: "",
//   ),
//   dataFetcher: BehaviorSubject<GetModelDetailsModel>(),
// );
//
//
//




//
//
// GetBrandsRcesRx getBrandsRcesRxObj = GetBrandsRcesRx(
//   empty: BrandsRceosModel(
//     success: false,
//     code: 0,
//     message: "",
//     data: null,
//     timestamp: "",
//   ),
//   dataFetcher: BehaviorSubject<BrandsRceosModel>(),
// );
//
// GetModelListRx getModelListRxObj = GetModelListRx(
//   empty: GetCompanyModelListModel(
//     success: false,
//     code: 0,
//     message: "",
//     data: null,
//     timestamp: "",
//   ),
//   dataFetcher: BehaviorSubject<GetCompanyModelListModel>(),
// );
DeleteUserRx deleteUserRxObj = DeleteUserRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);

final GetUserProfileRx getUserProfileRxObj = GetUserProfileRx(
  empty: UserProfileModel(),
  dataFetcher: BehaviorSubject<UserProfileModel>(),
);

final GetMyBlockedUsersRx getMyBlockedUsersRxObj = GetMyBlockedUsersRx(
  empty: MyBlockedUsersModel(success: false, code: 0, message: '', data: null),
  dataFetcher: BehaviorSubject<MyBlockedUsersModel>(),
);

final BlockOrUnblockUserRx blockOrUnblockUserRxObj = BlockOrUnblockUserRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);

final ReportUserRx reportUserRxObj = ReportUserRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);





