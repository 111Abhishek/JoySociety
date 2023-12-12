import 'dart:ui';

import 'package:joy_society/data/model/response/language_model.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/extensions/int_extensions.dart';

class AppConstants {
  static const String APP_NAME = 'Joy Society';
  static const String BASE_URL = 'https://server.joysociety.app';
  static const String USER_ID = 'userId';
  static const String NAME = 'name';
  static const String DEFAULT_COUNTRY_CODE = '+1';
  static const noInternetMsg = 'Oops No Internet';
  static const msg = 'message';
  static const status = 'status';
  static const int timeoutDuration = 30;
  static double tabletBreakpointGlobal = 600.0;
  static double desktopBreakpointGlobal = 720.0;
  static Duration pageRouteTransitionDurationGlobal = 400.milliseconds;
  static const String stripePublishableKey =
      "pk_test_51NRPhbSCRLE6eWsl9Diya1wKO6IiU4dBhtI6Cy10N8vrOafdvF7votbbCKNS7BlH9bpyj3xawBoBf882BCbEDvOy00JeeA4crr";
  static const String secret_key =
      'sk_test_51NRPhbSCRLE6eWslNuPvft099uKRjW4EvodGBtP1uifewy8mCLqikj2OtxS2RcR7G94T3If8JkWWvTZMModzSIhh00aA4Uq8Fe';
  // sharePreference
  static const String TOKEN = 'token';
  static const String USER = 'user';
  static const String USER_EMAIL = 'user_email';
  static const String USER_PHONE_NUMBER = 'user_phone_number';
  static const String USER_PHONE_COUNTRY_CODE = 'user_country_code';
  static const String USER_PASSWORD = 'user_password';
  static const String CURRENCY = 'currency';
  static const String LANG_KEY = 'lang';
  static const String INTRO = 'intro';
  static const String HOME_ADDRESS = 'home_address';
  static const String OFFICE_ADDRESS = 'office_address';
  static const String ROLES_LIST = 'roles_list';

  static const String CONFIG_URI = '/api/v1/config';
  static const String SOCIAL_LOGIN_URI = '/api/v1/auth/social-login';
  static const String REGISTRATION_URI = '/user/register/';
  static const String LOGIN_URI = '/user/login/';
  static const String TOKEN_URI = '/notification/devices/add/';
  static const String CHECK_EMAIL_URI = '/api/v1/auth/check-email';
  static const String VERIFY_EMAIL_URI = '/api/v1/auth/verify-email';
  static const String CHECK_PHONE_URI = '/api/v1/auth/check-phone';
  static const String VERIFY_PHONE_URI = '/api/v1/auth/verify-phone';
  static const String VERIFY_OTP_URI = '/api/v1/auth/verify-otp';
  static const String RESET_PASSWORD_URI = '/api/v1/auth/reset-password';
  static const String FORGET_PASSWORD_URI = '/api/v1/auth/forgot-password';
  static const String CUSTOMER_URI = '/api/v1/customer/info';
  static const String ADDRESS_LIST_URI = '/api/v1/customer/address/list';
  static const String REMOVE_ADDRESS_URI =
      '/api/v1/customer/address?address_id=';
  static const String ADD_ADDRESS_URI = '/api/v1/customer/address/add';
  static const String UPDATE_PROFILE_URI = '/api/v1/customer/update-profile';
  static const String LOCATIONS_URI = '/master/location/';
  static const String TIMEZONE_URI = '/master/timezone/';
  static const String COUNTRY_LIST_URI = '/master/country/';
  static const String STATE_LIST_URI = '/master/state/';
  static const String CITY_LIST_URI = '/master/city/';
  static const String USER_PROFILE_URI = '/user/profile/';
  static const String USER_BILLING_DETAILS_URI = '/user/billing-address/';
  static const String SAVE_USER_BILLING_DETAILS_URI = '/user/billing-address/';

  // Topic URIs
  static const String TOPIC_URI = '/topic/';
  static const String TOPIC_DELETE_URI = '/topic/3/';

  // Members URIs
  static const String SENT_INVTES_LIST = '/member/invite/list/';
  static const String REQUESTS_TO_JOIN_LIST = '/member/request-to-join/list/';
  static const String MEMBER_CONTENT = '/member/content/';
  static const String INVITE_CREATE = '/member/invite/create/';
  static const String MEMBER_FOLLOWERS =
      '/member/list/?page=1&page_size=10&ordering=-created_on';

  // Goals URIs
  static const String GOAL = '/goal/';
  static const String SUCCESS_EVALUATION_REPORT =
      '/goal/success-evaluation-report/';
  static const String SUCCESS_SPHERE = '/goal/success-sphere/';
  static const String GOAL_REFLECTION = '/goal/reflection/';
  static const String GOAL_SPHERE = '/goal/goal_spheres/';
  static const String COMPLETE_SPHERE = '/goal/set_review/';
  // Subscription Charge
  static const SUBSCRIPTION_OPTIONS = '/product/';
  static const SUBSCRIPTION_WORKSHOP = '/workshop/subcription/';
  static const GET_STRIPE_URL = '/user/subscribe/';

  // Workshop URIs
  static const String WORKSHOP = '/workshop/';
  static const String WORKSHOP_CONTENT = '/workshop/get-content';
  static const String WORKSHOP_MEMBERS = '/workshop/member/';
  static const String DEFAULT_WORKSHOP_IMAGE_URL =
      '/assets/img/workshop-placeholder.png';
  static const String WorkshopMessageUrl = '/chat/message/';

  // Event URIs
  static const String EVENT = '/event/';
  static const chatChannel = '/chat/channel/';
  static const String EventMessageUrl = '/chat/message/';

  // Tribe URIs
  static const String TRIBE = '/tribe/';
  static const String TRIBE_REORDER = '/tribe/re-order/';
  static const String TRIBE_MEMBER_URL = '/tribe/member/';

  // Product
  static const String PRODUCT = '/product/';

  // Main URIs
  static const String USER_ROLES = '/user/roles/';

  static String searchPost = '/feeds/quick-post/';
  //'posts/search-post?expand=user,user.userLiveDetail';
  static String QUICK_POST = '/feeds/quick-post/';
  static String LONG_POST = '/feeds/long-post/';
  static String QUESTION_AND_POLL_POST = '/feeds/question-poll/';
  static String ADD_CMT = '/feeds/timeline/comment/add/';
  static const String userCredentialsUri = '/user/credentials/';

  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  static const String THEME = 'theme';
  static const String TOPIC = 'joysociety';

  static const String channel = "/chat/channel/";
  static const String postMessageUrl = "/chat/message/create/";

  // notification urls
  static const String notificationUrl = '/notification/notify/';
  static const String notificationUpdateUrl = '/notification/notify/update';

  // profile urls
  static const String userBadgeUri = '/user/badges-list/';
  static const String uploadProfileImageUri = '/master/media/upload/';

  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: '',
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
    LanguageModel(
        imageUrl: '',
        languageName: 'Arabic',
        countryCode: 'SA',
        languageCode: 'ar'),
  ];

  static const bool forceEnableDebug = false;
  static const double textBoldSizeGlobal = 16;
  static const double textPrimarySizeGlobal = 16;
  static const double textSecondarySizeGlobal = 14;
  static const Color textPrimaryColorGlobal = ColorResources.textPrimaryColor;
  static FontWeight fontWeightPrimaryGlobal = FontWeight.normal;
  static String? fontFamilyPrimaryGlobal;

  // pie socket specific constants
  static String pieSocketClusterId = 's9313.blr1';
  static String pieSocketApiKey = 'p28cVPPkayrdB57PwEodJMNhxUWoI8KlZksFLyuo';
  static String pieSocketRoomId = 'JPS-JoySocity';
}
