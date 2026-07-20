// ignore_for_file: constant_identifier_names, unnecessary_string_interpolations

const String url = "https://abojude.thesyndicates.team/api";
const String imageUrl = "${url}";

final class NetworkConstants {
  NetworkConstants._();
  static const ACCEPT = "Accept";
  static const APP_KEY = "App-Key";
  static const ACCEPT_LANGUAGE = "Accept-Language";
  static const ACCEPT_LANGUAGE_VALUE = "pt";
  static const APP_KEY_VALUE = String.fromEnvironment("APP_KEY_VALUE");
  static const ACCEPT_TYPE = "application/json";
  static const AUTHORIZATION = "Authorization";
  static const CONTENT_TYPE = "content-Type";
}

final class Endpoints {
  Endpoints._();

  // -------------------Register start-------------------
  static String register() => "/v1/sign-up";
  // -------------------Register end-------------------

  // -------------------Register Verify email start-----------------
  static String registerVerifyOtp() => "/v1/verify/otp";
  // -------------------Register Verify email end-------------------

  // -------------------Get Province List start-----------------
  static String getProvinceList() => "/v1/locations/provinces";
  // -------------------Get Province List end-------------------

  // -------------------Get Cities List start-----------------
  static String getCitiesList(String province) =>
      "/v1/locations/provinces/$province/cities";
  // -------------------Get Cities List end-------------------

  // -------------------Select Location auth user start-----------------
  static String selectLocationForAuthUser() => "/v1/locations/select";
  // -------------------Select Location auth user end-------------------

  // -------------------Guest user location start-----------------
  static String guestUserLocation() => "/v1/guest/location";
  // -------------------Guest user location end-------------------
 

  // -------------------Login start-------------------
  static String login() => "/v1/login";
  // -------------------Login end-------------------

  // -------------------Logout start-------------------
  static String logout() => "/v1/auth/logout";
  // -------------------Logout end-------------------

  // -------------------Delete Account start-------------------
  static String deleteAccount() => "/v1/auth/delete-account";
  // -------------------Delete Account end-------------------

  // -------------------Forget Password start-------------------
  static String forgetPassword() => "/v1/forgot-password";
  // -------------------Forget Password end-------------------

  // -------------------Set New Password start-------------------
  static String setNewPassword() => "/v1/reset-password";
  // -------------------Set New Password end-------------------

  // -------------------Change Password start-------------------
  static String changePassword() => "/v1/auth/change-password";
  // -------------------Change Password end-------------------

  // -------------------Forget Password verify otp start-------------------
  static String forgetPasswordVerifyOtp() => "/v1/verify/otp";
  // -------------------Forget Password verify otp end-------------------

  // -------------------Guest User start-------------------
  static String guestUser() => "/v1/guest";
  // -------------------Guest User end-------------------

  // -------------------Resend Otp start-------------------
  static String resendOtp() => "/v1/resend-otp";
  // -------------------Resend Otp end-------------------

    // ------------------- GetCategoryList start-------------------
  static String getCategoryList() => "/v1/categories";
  // -------------------GetCategoryList end-------------------

  // ------------------- GetRecentPostList start-------------------
  static String getRecentPostList() => "/v1/posts/recent";
  // -------------------GetRecentPostList end-------------------

  // ------------------- GetProfile start-------------------
  static String getProfile() => "/v1/auth/profile";
  // -------------------GetProfile end-------------------
  

  // // -------------------Forget Password verify otp start-------------------
  // static String forgetPasswordVerifyOtp() => "/v1/verify/otp";
  // // -------------------Forget Password verify otp end-------------------

  // // -------------------Resend OTP start-------------------
  // static String resendOtp() => "/api/resend-otp";
  // // -------------------Resend OTP end-------------------

  // // -------------------Reset Password start-------------------
  // static String resetPassword() => "/api/reset-password";
  // // -------------------Reset Password end-------------------

  // // -------------------Verify Otp start-------------------
  // static String verifyForgetPasswordOtp() => "/api/verify-otp";
  // // -------------------Verify Otp end-------------------

  // // -------------------Update Profile start-------------------
  // static String updateProfile() => "/api/update-profile";
  // // -------------------Update Profile end-------------------

  // // -------------------Get Profile start-------------------
  // static String getProfile() => "/api/me";
  // // -------------------Get Profile end-------------------

  // // -------------------Update Password start-------------------
  // static String updatePassword() => "/api/update-password";
  // // -------------------Update Password end-------------------

  // // -------------------Privacy Policy start-------------------
  // static String privacyPolicy() => "/api/dynamic-pages/single/privacy-policy";
  // // -------------------Privacy Policy end-------------------

  // // -------------------Terms And Conditions start-------------------
  // static String termsAndConditions() => "/api/dynamic-pages/single/terms-and-conditions";
  // // -------------------Terms And Conditions end-------------------

  // // -------------------Services start-------------------
  // static String services() => "/api/services";
  // // -------------------Services end-------------------

  // // -------------------Favourites start-------------------
  // static String favourites() => "/api/researcher/favourites";
  // // -------------------Favourites end-------------------

  // // -------------------Delete Favourites start-------------------
  // static String deleteFavourites(String favouriteId) => "/api/researcher/favourites/$favouriteId";
  // // -------------------Delete Favourites end-------------------

  // // -------------------Opportunities start-------------------
  // static String opportunitiesList() => "/api/opportunities";
  // // -------------------Opportunities end-------------------

  // // -------------------Add Favourites start-------------------
  // static String addFavourites() => "/api/researcher/favourites";
  // // -------------------Add Favourites end-------------------

  // // -------------------Opportunity Details start-------------------
  // static String opportunityDetails(String opportunityId) => "/api/opportunities/$opportunityId";
  // // -------------------Opportunity Details end-------------------

  // // ------------------- Mentors details start-------------------
  // static String mentorsDetails(String mentorId) => "/api/opportunities/mentors/$mentorId";
  // // ------------------- Mentors details end-------------------

  // // ------------------- Filter List start-------------------
  // static String filterList() => "/api/opportunities/fillter-list";
  // // ------------------- Filter List end-------------------

  //   // -------------------Verify phone start-------------------
  //   static String verifyphone() => "/login/verify-otp";
  //   // -------------------Verify phone end-------------------

  //   // -------------------Resend OTP for signup start-------------------
  //   static String resendOtpforSignup() => "/resend-otp";
  //   // -------------------Resend OTP for signup end-------------------

  //   // -------------------Get area MSR start-------------------
  //   static String getAreaMsr() => "/area-measurements";
  //   // -------------------Get area MSR end-------------------

  //   // -------------------Post area MSR start-------------------
  //   static String postAreaMsr() => "/update-area-measurement";
  //   // -------------------Post area MSR end-------------------

  //   // -------------------Get farming start-------------------
  //   static String getFarming() => "/farming-types";
  //   // -------------------Get farming end-------------------

  //   // -------------------Setup profile start-------------------
  //   static String setupProfile() => "/update-profile";
  //   // -------------------Setup profile end-------------------

  //   // -------------------Delete account start-------------------
  //   static String deleteAccount() => "/delete-profile";
  //   // -------------------Delete account end-------------------

  //   // -------------------Create farmer start-------------------
  //   static String craeteFarmer() => "/farmers";
  //   // -------------------Create farmer end-------------------

  //   // -------------------Get all farmer start-------------------
  //   static String getAllFarmer() => "/farmers";
  //   // -------------------Get all farmer end-------------------

  //   // -------------------Get pond by farmer start-------------------
  //   static String getPondByFarmer() => "/observations/get-pond-by-farmer";
  //   // -------------------Get pond by farmer end-------------------

  //   // -------------------Create observation start-------------------
  //   static String createObservation() => "/observations";
  //   // -------------------Create observation end-------------------

  //   // -------------------Create pond observation start-------------------
  //   static String createPondObservation() => "/pond-observations";
  //   // -------------------Create pond observation end-------------------

  //   // -------------------Create biomass observation start-------------------
  //   static String createBiomassObservation() => "/biomass-observations";
  //   // -------------------Create biomass observation end-------------------

  //   // -------------------Create input observation start-------------------
  //   static String createInputObservation() => "/input-observations";
  //   // -------------------Create input observation end-------------------

  //   // -------------------Create pond start-------------------
  //   static String craetePond() => "/my-ponds";
  //   // -------------------Create pond end-------------------

  //   // -------------------Get all my ponds start-------------------
  //   static String getMyPonds() => "/my-ponds";
  //   // -------------------Get all my ponds end-------------------

  //   // -------------------Get single my pond start-------------------
  //   static String getSingleMyPond(String pondId) => "/my-ponds/${pondId}";
  //   // -------------------Get single my pond end-------------------

  //   // -------------------Get all farmers in home start-------------------
  //   static String getAllFarmersInHome() => "/landing-farmer-page";
  //   // -------------------Get all farmers in home end-------------------

  //   // -------------------Get all home data start-------------------
  //   static String getAllHomeData() => "/landing-page";
  //   // -------------------Get all home data end-------------------

  //   // -------------------Get all ponds start-------------------
  //   static String getAllPonds() => "/landing-pond-page";
  //   // -------------------Get all ponds end-------------------

  //   // -------------------Get all ponds start-------------------
  //   static String getAllFollowUpsInHome() => "/pond-follow-ups";
  //   // -------------------Get all ponds end-------------------

  //   // -------------------Create pond follow ups start-------------------
  //   static String createPondFollowUps() => "/pond-follow-ups";
  //   // -------------------Create pond follow ups end-------------------

  //   // -------------------Update pond follow ups start-------------------
  //   static String updatePondFollowUps(String pondId) =>
  //       "/pond-follow-ups/$pondId";
  //   // -------------------Update pond follow ups end-------------------

  //   // -------------------Get all categories start-------------------
  //   static String getAllCategories() => "/categories";
  //   // -------------------Get all categories end-------------------

  //   // -------------------Create categories start-------------------
  //   static String createCategories() => "/categories";
  //   // -------------------Create categories end-------------------

  //   // -------------------Create sub categories start-------------------
  //   static String createSubCategories() => "/sub-categories";
  //   // -------------------Create sub categories end-------------------

  //   // -------------------Create products start-------------------
  //   static String createProducts() => "/products";
  //   // -------------------Create products end-------------------

  //   // -------------------Get products start-------------------
  //   static String getProducts() => "/products";
  //   // -------------------Get products end-------------------

  //   // -------------------Get farmer and his ponds start-------------------
  //   static String farmersAndHisPonds(String farmerId) => "/farmers/${farmerId}";
  //   // -------------------Get farmer and his ponds end-------------------

  //   // -------------------Get observation by pond start-------------------
  //   static String getObservationByPond(String pondId) =>
  //       "/observations/get-by-pond/${pondId}";
  //   // -------------------Get observation by pond end-------------------

  //   // -------------------Get biomass stock parameters start-------------------
  //   static String getBiomassStockParameters() =>
  //       "/biomass-parameters?type=stocks&is_default=1";
  //   // -------------------Get biomass stock parameters end-------------------

  //   // -------------------Get biomass growth parameters start----------------
  //   static String getBiomassGrowthsParameters() =>
  //       "/biomass-parameters?type=growths&is_default=1";
  //   // -------------------Get biomass growth parameters end----------------

  //   // -------------------Get pond water parameters start-------------------
  //   static String getPondWaterParameters(
  //           {required String type, required String is_default}) =>
  //       "/pond-parameters?type=${type}&is_default=${is_default}";
  //   // -------------------Get pond water parameters end-------------------

  // // -------------------Get pond soil parameters start-------------------
  //   static String getPondSoilParameters(
  //           {required String type, required String is_default}) =>
  //       "/pond-parameters?type=${type}&is_default=${is_default}";
  // // -------------------Get pond soil parameters end-------------------

  //   // -------------------Get pond plankton parameters start-------------------
  //   static String getPondPlanktonParameters(
  //           {required String type, required String is_default}) =>
  //       "/pond-parameters?type=${type}&is_default=${is_default}";
  //   // -------------------Get pond plankton parameters end-------------------

  //   // -------------------Get pond water parameters value start-------------------
  //   static String getPondWaterParametersValue(
  //           {required String pondObservationId}) =>
  //       "/pond-waters?pond_observation_id=${pondObservationId}";
  //   // -------------------Get pond water parameters value end-------------------

  //   // -------------------Get pond soil parameters value start-------------------
  //   static String getPondSoilParametersValue(
  //           {required String pondObservationId}) =>
  //       "/pond-soils?pond_observation_id=${pondObservationId}";
  //   // -------------------Get pond soil parameters value end-------------------

  //   // -------------------Get pond plankton parameters value start-------------------
  //   static String getPlanktonParametersValue(
  //           {required String pondObservationId}) =>
  //       "/pond-planktons?pond_observation_id=${pondObservationId}";
  //   // -------------------Get pond plankton parameters value end-------------------

  //   // -------------------Get pond parameters value start-------------------
  //   static String getPondParametersValue({required String pondObservationId}) =>
  //       "/pond-waters?pond_observation_id=${pondObservationId}";
  //   // -------------------Get pond parameters value end-------------------

  //   // -------------------Create pond water reading start-------------------
  //   static String createPondWaterReading() => "/pond-waters";
  //   // -------------------Create pond water reading end-------------------

  //   // -------------------Create pond soil reading start-------------------
  //   static String createPondSoilReading() => "/pond-soils";
  //   // -------------------Create pond soil reading end-------------------

  //   // -------------------Create pond planktons reading start-------------------
  //   static String createPondplanktonsReading() => "/pond-planktons";
  //   // -------------------Create pond planktons reading end-------------------

  //   // -------------------Create pond microbes reading start-------------------
  //   static String createPondMicrobeReading() => "/pond-microbes";
  //   // -------------------Create pond microbes reading end-------------------

  //   // -------------------Get all past cycles start-------------------
  //   static String getAllPastCycles(String pondId) =>
  //       "/observations/get-list-by-pond/${pondId}";
  //   // -------------------Get all past cycles end-------------------

  //   // -------------------Create key contact start-------------------
  //   static String createKeyContact() => "/farmer-key-contacts";
  //   // -------------------Create key contact end-------------------

  //   // -------------------Update key contact start-------------------
  //   static String updateKeyContact(String id) => "/farmer-key-contacts/$id";
  //   // -------------------Update key contact end-------------------

  //   // -------------------Get other key contact start-------------------
  //   static String getOtherKeyContact() => "/farmer-key-contacts";
  //   // -------------------Get other key contact end-------------------

  //   // -------------------Get single group pond start-------------------
  //   static String getSingleGroupPond(String groupId) => "/my-groups/${groupId}";
  //   // -------------------Get single group pond end-------------------

  //   // -------------------Update farmer start-------------------
  //   static String updateFarmer(String farmerId) => "/farmers/${farmerId}";
  //   // -------------------Update farmer end-------------------

  //   // -------------------Get shared ponds start-------------------
  //   static String getSharedPonds(String sharedPondId) =>
  //       "/farmers/share-pond/${sharedPondId}";
  //   // -------------------Get shared ponds end-------------------

  //   // -------------------Create sharing ponds start-------------------
  //   static String createSharingPonds() => "/farmers/share-pond";
  //   // -------------------Create sharing ponds end-------------------

  //   // -------------------Get user info start-------------------
  //   static String getUserInfo() => "/me";
  //   // -------------------Get user info end-------------------

  //   // -------------------Get single pond start-------------------
  //   static String getSinglePond({required String pondId}) =>
  //       "/observations/get-by-pond/${pondId}";
  //   // -------------------Get single pond end-------------------

  //   // -------------------Create observation close start-------------------
  //   static String createObservationClose(String observationId) =>
  //       "/observations/close-observation-cycle/${observationId}";
  //   // -------------------Create observation close end-------------------

  //   // -------------------Create biomass stock start-------------------
  //   static String createBiomassStocks() => "/biomass-stocks";
  //   // -------------------Create biomass stock end-------------------

  //   // -------------------Create input stock start-------------------
  //   static String createInputStocks() => "/input-stocks";
  //   // -------------------Create input stock end-------------------

  //   // -------------------get all Biomass Stock start-------------------
  //   static String getAllBiomassStocksData(
  //           {required String biomassObservationId}) =>
  //       "/biomass-stocks?biomass_observation_id=${biomassObservationId}";
  //   // -------------------get all Biomass Stock end-------------------

  //   // -------------------get Biomass Harvest start-------------------
  //   static String getBiomassHarvests({required String biomassObservationId}) =>
  //       "/biomass-harvests?biomass_observation_id=${biomassObservationId}";
  //   // -------------------get Biomass Harvest end-------------------

  //   // -------------------get Biomass Growth start-------------------
  //   static String getBiomassGrowths({required String biomassObservationId}) =>
  //       "/biomass-growths?biomass_observation_id=${biomassObservationId}";
  //   // -------------------get Biomass Growth end-------------------

  //   // -------------------get Biomass Harvest start-------------------
  //   static String getBiomassHarvestParameters() =>
  //       "/biomass-parameters?type=harvests&is_default=1";
  //   // -------------------get Biomass Harvest end-------------------

  //   // -------------------get Biomass Transfer start-------------------
  //   static String getBiomassTransferParameters() =>
  //       "/biomass-parameters?type=transfers&is_default=1";
  //   // -------------------get Biomass Transfer end-------------------

  //   // -------------------get Biomass Mortality start-------------------
  //   static String getBiomassMortalityParameters() =>
  //       "/biomass-parameters?type=mortalitys&is_default=1";
  //   // -------------------get Biomass Mortality end-------------------

  //   // -------------------get Biomass Transfer start-------------------
  //   static String getBiomassTransfers(String biomassObservationId) =>
  //       "/biomass-transfers?biomass_observation_id=$biomassObservationId";
  //   // -------------------get Biomass Transfer end-------------------

  //   // -------------------create Biomass Transfer start-------------------
  //   static String createBiomassGrowth() => "/biomass-growths";
  //   // -------------------create Biomass Transfer end-------------------

  //   // -------------------create Biomass Growth start-------------------
  //   static String createBiomassHarvest() => "/biomass-harvests";
  //   // -------------------create Biomass Growth end-------------------

  //   // -------------------get Biomass Mortality start-------------------
  //   static String getBiomassMortalitys({required String biomassObservationId}) =>
  //       "/biomass-mortalitys?biomass_observation_id=$biomassObservationId";
  //   // -------------------get Biomass Mortality end-------------------

  //   // -------------------create Biomass Mortality start-------------------
  //   static String createBiomassMortality() => "/biomass-mortalitys";
  //   // -------------------create Biomass Mortality end-------------------

  //   // -------------------create Farmer Comment start-------------------
  //   static String createFarmerComment() => "/input-farmer-comments";
  //   // -------------------create Farmer Comment end-------------------

  //   // -------------------get Farmer Comment start-------------------
  //   static String getFarmerComment(int id) =>
  //       "/input-farmer-comments?input_observation_id=$id";
  //   // -------------------get Farmer Comment end-------------------

  //   // -------------------get Feeding Parameters start-------------------
  //   static String getFeedingParameters(
  //           {required String type, required int isDefault}) =>
  //       "/input-parameters?type=$type&is_default=$isDefault";
  //   // -------------------get Feeding Parameters end-------------------

  //   // -------------------get input feeding start-------------------
  //   static String getInputFeedings(int observationId) =>
  //       "/input-feedings?input_observation_id=$observationId";
  //   // -------------------get input feeding end-------------------

  //   // -------------------create input feeding start-------------------
  //   static String createInputFeeding() => "/input-feedings";
  //   // -------------------create input feeding end-------------------

  //   // -------------------create biomass transfer start-------------------
  //   static String createBiomassTransfer() => "/biomass-transfers";
  //   // -------------------create biomass transfer end-------------------

  //   // -------------------create input product usages start-------------------
  //   static String createInputProductUse() => "/input-product-usages";
  //   // -------------------create input product usages end-------------------

  //   // -------------------input remarks and rxs start-------------------
  //   static String inputRemarksAndRxs() => "/input-remarks-and-rxs";
  //   // -------------------input remarks and rxs end-------------------

  //   // -------------------input product usages start-------------------
  //   static String input_product_usages() => "/input-product-usages";
  //   // -------------------input product usages end-------------------

  //   // -------------------pond update start-------------------
  //   static String updatePond(String id) => "/my-ponds/update/$id";
  //   // -------------------pond update end-------------------

  //   // -------------------delete pond start-------------------
  //   static String deletePond(String id) => "/my-ponds/$id";
  //   // -------------------delete pond end-------------------

  //   // -------------------delete farmer start-------------------
  //   static String deleteFarmer(String id) => "/farmers/$id";
  //   // -------------------delete farmer end-------------------
}
