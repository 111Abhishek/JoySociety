import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:joy_society/data/model/response/subscription_model.dart';
import 'package:joy_society/helper/custom_delegate.dart';
import 'package:joy_society/localization/app_localization.dart';
import 'package:joy_society/notification/my_notification.dart';
import 'package:joy_society/notification/pie_socket_notification.dart';
import 'package:joy_society/provider/auth_provider.dart';
import 'package:joy_society/provider/event_provider.dart';
import 'package:joy_society/provider/facebook_login_provider.dart';
import 'package:joy_society/provider/goal_provider.dart';
import 'package:joy_society/provider/google_sign_in_provider.dart';
import 'package:joy_society/provider/home_controller.dart';
import 'package:joy_society/provider/home_provider.dart';
import 'package:joy_society/provider/localization_provider.dart';
import 'package:joy_society/provider/main_provider.dart';
import 'package:joy_society/provider/members_follwers_provider.dart';
import 'package:joy_society/provider/members_provider.dart';
import 'package:joy_society/provider/need_help_provider.dart';
import 'package:joy_society/provider/notification_provider.dart';
import 'package:joy_society/provider/onboarding_provider.dart';
import 'package:joy_society/provider/plan_provider.dart';
import 'package:joy_society/provider/post_card_controller.dart';
import 'package:joy_society/provider/post_controller.dart';
import 'package:joy_society/provider/post_provider.dart';
import 'package:joy_society/provider/profile_provider.dart';
import 'package:joy_society/provider/splash_provider.dart';
import 'package:joy_society/provider/subscription_provider.dart';
import 'package:joy_society/provider/theme_provider.dart';
import 'package:joy_society/provider/topic_provider.dart';
import 'package:joy_society/provider/tribe_provider.dart';
import 'package:joy_society/provider/true_success_question_provider.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/theme/dark_theme.dart';
import 'package:joy_society/theme/light_theme.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/view/screen/splash/splash_screen.dart';
import 'package:piesocket_channels/channels.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'di_container.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  //Assign publishable key to flutter_stripe
  Stripe.publishableKey = AppConstants.stripePublishableKey;

  //Load our .env file that contains our Stripe Secret key
  // await dotenv.load(fileName: "assets/.env");
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  int? _orderID;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    _orderID = (notificationAppLaunchDetails?.payload != null &&
            notificationAppLaunchDetails!.payload!.isNotEmpty)
        ? int.parse(notificationAppLaunchDetails.payload!)
        : null;
  }
  await MyNotification.initialize(flutterLocalNotificationsPlugin);
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OnBoardingProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<GoogleSignInProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<FacebookLoginProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<MainProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<TopicProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<MembersProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<GoalProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<WorkshopProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<PostProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<EventProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<TribeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<PlanProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<MemberFollowerProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<SubscriptionProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<TrueSuccessProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<NotificationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<NeedHelpProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<HomeProvider>()),
    ],
    child: MyApp(orderId: _orderID),
  ));

  Get.put(HomeController());
  Get.put(PostController());
  Get.put(PostCardController());
}

class MyApp extends StatefulWidget {
  final int? orderId;
  MyApp({required this.orderId});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // creating the piesocket channels here
    // PieSocketOptions options = PieSocketOptions();
    // options.setClusterId('s9313.blr1');
    // options.setApiKey('p28cVPPkayrdB57PwEodJMNhxUWoI8KlZksFLyuo');

    // PieSocket pieSocket = PieSocket(options);

    // Channel channel = pieSocket.join('JPS-JoySocity');
    // channel.listen("system:message", (PieSocketEvent event) {
    //   print(event.getEvent().toString());
    // });
  }

  @override
  Widget build(BuildContext context) {
    List<Locale> _locals = [];
    AppConstants.languages.forEach((language) {
      _locals.add(Locale(language.languageCode!, language.countryCode));
    });

    return MaterialApp(
        title: AppConstants.APP_NAME,
        navigatorKey: MyApp.navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).darkTheme ? dark : light,
        locale: Provider.of<LocalizationProvider>(context).locale,
        localizationsDelegates: [
          AppLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          FallbackLocalizationDelegate()
        ],
        supportedLocales: _locals,
        home: SplashScreen());
  }
}

// class MyApp extends StatelessWidget {
//   final int? orderId;
//   MyApp({required this.orderId});

//   static final navigatorKey = GlobalKey<NavigatorState>();

//   @override
//   Widget build(BuildContext context) {
//     List<Locale> _locals = [];
//     AppConstants.languages.forEach((language) {
//       _locals.add(Locale(language.languageCode!, language.countryCode));
//     });

//     return MaterialApp(
//         title: AppConstants.APP_NAME,
//         navigatorKey: navigatorKey,
//         debugShowCheckedModeBanner: false,
//         theme: Provider.of<ThemeProvider>(context).darkTheme ? dark : light,
//         locale: Provider.of<LocalizationProvider>(context).locale,
//         localizationsDelegates: [
//           AppLocalization.delegate,
//           GlobalMaterialLocalizations.delegate,
//           GlobalWidgetsLocalizations.delegate,
//           GlobalCupertinoLocalizations.delegate,
//           FallbackLocalizationDelegate()
//         ],
//         supportedLocales: _locals,
//         home: SplashScreen());
//   }
// }
