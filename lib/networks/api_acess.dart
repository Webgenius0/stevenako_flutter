
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/home/data/post_api/rx.dart';
import 'package:stevenako_flutter/features/home/model/get_all_photo_model.dart';
import 'package:stevenako_flutter/features/home/model/hom_screen_reals_model.dart';
import 'package:stevenako_flutter/features/message/data/rx.dart';

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
import '../features/message/model/get_all_messae_model.dart';


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

RegisterRx registerRxObj = RegisterRx(
  empty: RegisterModel(
    success: false,
    code: 0,
    message: '',
    data: null,
  ),
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
  empty:   GetAllPostModel(
    success: false,
    code: 0,
    message: '',
    data: null,
  ),
  dataFetcher: BehaviorSubject<GetAllPostModel>(),
);

final GetAllPhotoRx getAllPhotoRxObj = GetAllPhotoRx(
  empty: GetAllPhotoModel(
    success: false,
    code: 0,
    message: '',
    data: null,
  ),
  dataFetcher: BehaviorSubject<GetAllPhotoModel>(),
);

//
//
//
//
final GetAllMessageListRx getAllMessageListRxObj =
GetAllMessageListRx(
  empty:   GetAllMesageListModel(
    success: false,
    code: 0,
    message: '',
    data: null,
  ),
  dataFetcher: BehaviorSubject<GetAllMesageListModel>(),
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
