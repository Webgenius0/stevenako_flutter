
import 'package:provider/provider.dart';
import 'package:stevenako_flutter/provider/address.dart';
import 'package:stevenako_flutter/provider/auth_provider.dart';
import 'package:stevenako_flutter/provider/email.dart';

var providers = [
  //New
  ChangeNotifierProvider<AuthProvider>(create: ((context) => AuthProvider())),
  // Old
  ChangeNotifierProvider<EmailProvider>(create: ((context) => EmailProvider())),
  ChangeNotifierProvider<AddressProvider>(
    create: ((context) => AddressProvider()),
  ),
  
];
