import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:joy_society/data/datasource/remote/dio/dio_client.dart';
import 'package:joy_society/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:joy_society/data/repository/auth_repo.dart';
import 'package:joy_society/data/repository/event_repo.dart';
import 'package:joy_society/data/repository/goal_repo.dart';
import 'package:joy_society/data/repository/home_repo.dart';
import 'package:joy_society/data/repository/main_repo.dart';
import 'package:joy_society/data/repository/member_follower.dart';
import 'package:joy_society/data/repository/members_repo.dart';
import 'package:joy_society/data/repository/notification_repo.dart';
import 'package:joy_society/data/repository/onboarding_repo.dart';
import 'package:joy_society/data/repository/plan_repo.dart';
import 'package:joy_society/data/repository/post_repo.dart';
import 'package:joy_society/data/repository/profile_repo.dart';
import 'package:joy_society/data/repository/splash_repository.dart';
import 'package:joy_society/data/repository/topic_repo.dart';
import 'package:joy_society/data/repository/tribe_repo.dart';
import 'package:joy_society/data/repository/workshop_repo.dart';
import 'package:joy_society/helper/network_info.dart';
import 'package:joy_society/provider/auth_provider.dart';
import 'package:joy_society/provider/event_provider.dart';
import 'package:joy_society/provider/facebook_login_provider.dart';
import 'package:joy_society/provider/goal_provider.dart';
import 'package:joy_society/provider/google_sign_in_provider.dart';
import 'package:joy_society/provider/home_provider.dart';
import 'package:joy_society/provider/localization_provider.dart';
import 'package:joy_society/provider/main_provider.dart';
import 'package:joy_society/provider/members_follwers_provider.dart';
import 'package:joy_society/provider/members_provider.dart';
import 'package:joy_society/provider/need_help_provider.dart';
import 'package:joy_society/provider/notification_provider.dart';
import 'package:joy_society/provider/onboarding_provider.dart';
import 'package:joy_society/provider/plan_provider.dart';
import 'package:joy_society/provider/post_provider.dart';
import 'package:joy_society/provider/profile_provider.dart';
import 'package:joy_society/provider/splash_provider.dart';
import 'package:joy_society/provider/subscription_provider.dart';
import 'package:joy_society/provider/theme_provider.dart';
import 'package:joy_society/provider/topic_provider.dart';
import 'package:joy_society/provider/tribe_provider.dart';
import 'package:joy_society/provider/true_success_question_provider.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repository/need_help_repo.dart';
import 'data/repository/subscription_repo.dart';
import 'data/repository/true_success_repo.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  sl.registerLazySingleton(() => DioClient(AppConstants.BASE_URL, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(
      () => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => OnBoardingRepo(dioClient: sl()));
  sl.registerLazySingleton(
      () => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => ProfileRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => TopicRepo(dioClient: sl()));
  sl.registerLazySingleton(() => MembersRepo(dioClient: sl()));
  sl.registerLazySingleton(() => MainRepo(dioClient: sl()));
  sl.registerLazySingleton(() => GoalRepo(dioClient: sl()));
  sl.registerLazySingleton(() => WorkshopRepo(dioClient: sl()));
  sl.registerLazySingleton(() => PostRepo(dioClient: sl()));
  sl.registerLazySingleton(() => EventRepo(dioClient: sl()));
  sl.registerLazySingleton(() => TribeRepo(dioClient: sl()));
  sl.registerLazySingleton(() => PlanRepo(dioClient: sl()));
  sl.registerLazySingleton(() => MembersFollowerRepo(dioClient: sl()));
  sl.registerLazySingleton(() => SubscriptionRepo(dioClient: sl()));
  sl.registerLazySingleton(() => TrueSuccessRepo(dioClient: sl()));
  sl.registerLazySingleton(() => NotificationRepo(dioClient: sl()));
  sl.registerLazySingleton(() => NeedHelpRepo(dioClient: sl()));
  sl.registerLazySingleton(() => HomeRepo(dioClient: sl()));

  // Provider
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(
      () => LocalizationProvider(sharedPreferences: sl(), dioClient: sl()));
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => OnBoardingProvider(onboardingRepo: sl()));
  sl.registerFactory(() => GoogleSignInProvider());
  sl.registerFactory(() => FacebookLoginProvider());
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(
      () => ProfileProvider(profileRepo: sl(), sharedPreferences: sl()));
  sl.registerFactory(() => TopicProvider(topicRepo: sl()));
  sl.registerFactory(
      () => MainProvider(mainRepo: sl(), sharedPreferences: sl()));
  sl.registerFactory(
      () => MembersProvider(membersRepo: sl(), sharedPreferences: sl()));
  sl.registerFactory(() => GoalProvider(goalRepo: sl()));
  sl.registerFactory(
      () => WorkshopProvider(workshopRepo: sl(), sharedPreferences: sl()));
  sl.registerFactory(
      () => PostProvider(postRepo: sl(), sharedPreferences: sl()));
  sl.registerFactory(
      () => EventProvider(eventRepo: sl(), sharedPreferences: sl()));
  sl.registerFactory(
      () => TribeProvider(tribeRepo: sl(), sharedPreferences: sl()));
  sl.registerFactory(
      () => PlanProvider(planRepo: sl(), sharedPreferences: sl()));
  sl.registerFactory(() => MemberFollowerProvider(membersRepo: sl()));
  sl.registerFactory(() => SubscriptionProvider(subscriptionRepo: sl()));
  sl.registerFactory(() => TrueSuccessProvider(trueSuccessRepo: sl()));
  sl.registerFactory(() => NotificationProvider(notificationRepo: sl()));
  sl.registerFactory(() => NeedHelpProvider(need_help_repo: sl()));
  sl.registerFactory(
      () => HomeProvider(homeRepo: sl(), sharedPreferences: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
  sl.registerLazySingleton(() => Connectivity());
}
