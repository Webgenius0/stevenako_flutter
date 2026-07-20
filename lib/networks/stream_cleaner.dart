import '../constants/app_constants.dart';
import '../helpers/di.dart';

Future<void> totalDataClean() async {
  await appData.write(kKeyIsLoggedIn, false);
  await appData.write(kKeyIsExploring, false);
  appData.write(kKeyLanguage, kKeyPortuguese);
  appData.write(kKeyCountryCode, countriesCode[kKeyPortuguese]);
  appData.write(kKeySelectedLocation, false);
//lisbon
  // appData.writeIfNull(kKeySelectedLat, 38.74631383626653);
  // appData.writeIfNull(kKeySelectedLng, -9.130169921874991);
//codemen
  await appData.write(kKeySelectedLat, 22.818285677915657);
  await appData.write(kKeySelectedLng, 89.5535583794117);
}

// void cleanLoginData() {
//   signinRXobj.clean();
//   getProfileRXobj.clean();
//   viewOrderRXobj.clean();
// }


