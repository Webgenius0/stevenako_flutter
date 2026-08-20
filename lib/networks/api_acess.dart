
import 'package:rxdart/rxdart.dart';

import '../features/auth/log_out/data/rx.dart';
import '../features/auth/login/data/rx.dart';
import '../features/auth/login/model/login_model.dart';
import '../features/auth/register/data/rx.dart';
import '../features/auth/register/model/forgort_model.dart';
import '../features/auth/register/model/post_verify_otp_model.dart';
import '../features/auth/set_new_password/data/rx.dart';
import '../features/auth/set_new_password/model/set_new_passwrod_model.dart';


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
  empty: const PostLoginModel(
    success: false,
    code: 0,
    message: '',
    data: null,
  ),
  dataFetcher: BehaviorSubject<PostLoginModel>(),
);

ForgotRx forgotRxObj = ForgotRx(
  empty:   PostForgotModel(
    success: false,
    code: 0,
    message: '',
    data: null,
  ),
  dataFetcher: BehaviorSubject<PostForgotModel>(),
);

VerifyOtpRx verifyOtpRxObj = VerifyOtpRx(
  empty: PostVerifyOtpModel(
    success: false,
    code: 0,
    message: '',
    data: null,
  ),
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

//
// GetProfileRx getProfileRxObj = GetProfileRx(
//   empty: UserInfoModel(
//     success: false,
//     code: 0,
//     message: '',
//     data: null,
//     timestamp: '',
//   ),
//   dataFetcher: BehaviorSubject<UserInfoModel>(),
// );
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
// PostSentMessgAIRx postSentMessgAIRxObj = PostSentMessgAIRx(
//   empty: PostSentMessageAiModel(
//     success: false,
//     code: 0,
//     message: "",
//     data: null,
//     timestamp: "",
//   ),
//   dataFetcher: BehaviorSubject<PostSentMessageAiModel>(),
// );
//
// PostStartChatRx postStartChatRxObj = PostStartChatRx(
//   empty: PostStartChatModel(
//     success: false,
//     code: 0,
//     message: "",
//     data: null,
//     timestamp: "",
//   ),
//   dataFetcher: BehaviorSubject<PostStartChatModel>(),
// );
//
//
//
//
// GetMessageRespsnRx getMessageRespsnRxObj = GetMessageRespsnRx(
//   empty: GetMessageResponseModel(
//     success: false,
//     code: 0,
//     message: "",
//     data: null,
//     timestamp: "",
//   ),
//   dataFetcher: BehaviorSubject<GetMessageResponseModel>(),
// );
//
// PutProfielImageUpdageRx profielImageUpdageRxObj = PutProfielImageUpdageRx(
//   empty: UserProfileIImagenfoUpdateModel(
//     success: false,
//     code: 0,
//     message: "",
//     data: null,
//     timestamp: "",
//   ),
//   dataFetcher: BehaviorSubject<UserProfileIImagenfoUpdateModel>(),
// );
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
//
//
//
LogoutRx logoutRxObj = LogoutRx(
  empty: <String, dynamic>{},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);

// DeleteAccountRx deleteAccountRxObj = DeleteAccountRx(
//   empty: <String, dynamic>{},
//   dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
// );
//
// GetRecentChatsRx getRecentChatsRxObj = GetRecentChatsRx(
//   empty: RcentChasModel(
//     success: false,
//     code: 0,
//     message: "",
//     data: null,
//     timestamp: "",
//   ),
//   dataFetcher: BehaviorSubject<RcentChasModel>(),
// );
//
