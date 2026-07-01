import 'package:flutter/widgets.dart';

class AppStrings {
  AppStrings._();

  static bool _isArabic(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar';

  static String appName(BuildContext context) =>
      _isArabic(context) ? 'سيرفي ماركت' : 'ServiMarket';

  static String createAccount(BuildContext context) =>
      _isArabic(context) ? 'إنشاء حساب' : 'Create Account';

  static String forgottenPassword(BuildContext context) =>
      _isArabic(context) ? 'نسيت كلمة المرور؟' : 'Forgotten Password?';

  static String continueWith(BuildContext context) =>
      _isArabic(context) ? 'المتابعة باستخدام ' : 'Continue with ';

  static String resetLinkSent(BuildContext context) => _isArabic(context)
      ? 'تم إرسال رابط إعادة التعيين إلى بريدك'
      : 'Reset link sent to your email';

  static String profile(BuildContext context) =>
      _isArabic(context) ? 'الملف الشخصي' : 'Profile';

  static String messages(BuildContext context) =>
      _isArabic(context) ? 'الرسائل' : 'Messages';

  static String signIn(BuildContext context) =>
      _isArabic(context) ? 'تسجيل الدخول' : 'Sign In';

  static String signUp(BuildContext context) =>
      _isArabic(context) ? 'إنشاء حساب' : 'Sign Up';

  static String email(BuildContext context) =>
      _isArabic(context) ? 'البريد الإلكتروني' : 'Email Address';

  static String password(BuildContext context) =>
      _isArabic(context) ? 'كلمة المرور' : 'Password';

  static String forgotPassword(BuildContext context) =>
      _isArabic(context) ? 'نسيت كلمة المرور؟' : 'Forgot Password?';

  static String continueWithGoogle(BuildContext context) =>
      _isArabic(context) ? 'المتابعة باستخدام Google' : 'Continue with Google';

  static String noConversations(BuildContext context) =>
      _isArabic(context) ? 'لا توجد محادثات بعد' : 'No conversations yet';

  static String noMessagesYet(BuildContext context) =>
      _isArabic(context) ? 'لا توجد رسائل بعد' : 'No messages yet';

  static String tryAgain(BuildContext context) =>
      _isArabic(context) ? 'حاول مرة تانية' : 'Try again';

  static String retry(BuildContext context) =>
      _isArabic(context) ? 'إعادة المحاولة' : 'Retry';

  static String signOut(BuildContext context) =>
      _isArabic(context) ? 'تسجيل الخروج' : 'Sign Out';

  static String contactDevelopers(BuildContext context) =>
      _isArabic(context) ? 'تواصل مع المطورين' : 'Contact Developers';

  static String memberSince(BuildContext context) =>
      _isArabic(context) ? 'عضو منذ' : 'Member since';

  static String skills(BuildContext context) =>
      _isArabic(context) ? 'المهارات' : 'Skills';

  static String rating(BuildContext context) =>
      _isArabic(context) ? 'التقييم' : 'Rating';

  static String reviews(BuildContext context) =>
      _isArabic(context) ? 'المراجعات' : 'Reviews';

  static String posts(BuildContext context) =>
      _isArabic(context) ? 'المنشورات' : 'Posts';

  static String myPosts(BuildContext context) =>
      _isArabic(context) ? 'منشوراتي' : 'My Posts';

  static String activity(BuildContext context) =>
      _isArabic(context) ? 'النشاط' : 'Activity';

  static String noPostsYet(BuildContext context) =>
      _isArabic(context) ? 'لا توجد منشورات بعد' : 'No posts yet.';

  static String noActivityYet(BuildContext context) =>
      _isArabic(context) ? 'لا يوجد نشاط بعد' : 'No activity yet.';

  static String tabMyPosts(BuildContext context) =>
      _isArabic(context) ? 'منشوراتي' : 'My Posts';

  static String tabActivity(BuildContext context) =>
      _isArabic(context) ? 'النشاط' : 'Activity';

  static String failedToLoadProfile(BuildContext context) => _isArabic(context)
      ? 'فشل تحميل الملف الشخصي.'
      : 'Failed to load profile.';

  static String failedToLoadPosts(BuildContext context) =>
      _isArabic(context) ? 'فشل تحميل المنشورات.' : 'Failed to load posts.';

  static String conversationUnavailable(BuildContext context) =>
      _isArabic(context) ? 'المحادثة غير متاحة' : 'Conversation unavailable';

  static String onlineNow(BuildContext context) =>
      _isArabic(context) ? 'متصل الآن' : 'Online now';

  static String startConversation(BuildContext context) =>
      _isArabic(context) ? 'ابدأ المحادثة' : 'Start the conversation';

  static String sendMessageHint(BuildContext context) => _isArabic(context)
      ? 'اكتب ردًا عن هذه الخدمة...'
      : 'Reply about this service...';

  static String markAsActive(BuildContext context) =>
      _isArabic(context) ? 'تحديد كمفتوح' : 'Mark as Active';

  static String markAsWaiting(BuildContext context) =>
      _isArabic(context) ? 'تحديد كمنتظر' : 'Mark as Waiting';

  static String closeConversation(BuildContext context) =>
      _isArabic(context) ? 'إغلاق المحادثة' : 'Close Conversation';

  static String today(BuildContext context) =>
      _isArabic(context) ? 'اليوم' : 'Today';

  static String yesterday(BuildContext context) =>
      _isArabic(context) ? 'أمس' : 'Yesterday';

  static String loadingOlderMessages(BuildContext context) => _isArabic(context)
      ? 'جارٍ تحميل رسائل أقدم...'
      : 'Loading older messages...';

  static String signedOutSuccessfully(BuildContext context) =>
      _isArabic(context) ? 'تم تسجيل الخروج بنجاح' : 'Signed out successfully';

  static String searchConversations(BuildContext context) => _isArabic(context)
      ? 'ابحث باسم العميل أو الخدمة'
      : 'Search by customer or service';

  static String emptyInboxDescription(BuildContext context) =>
      _isArabic(context)
      ? 'لما حد يتواصل معاك بخصوص خدمة، هتظهر هنا.'
      : 'When someone contacts you about a service, it will appear here.';

  static String sendMessagePrompt(BuildContext context) => _isArabic(context)
      ? 'ابعت رسالة عشان تبدأ المحادثة.'
      : 'Send a message to get things moving.';

  static String all(BuildContext context) =>
      _isArabic(context) ? 'الكل' : 'All';

  static String newLeads(BuildContext context) =>
      _isArabic(context) ? 'العملاء الجدد' : 'New Leads';

  static String active(BuildContext context) =>
      _isArabic(context) ? 'نشط' : 'Active';

  static String waiting(BuildContext context) =>
      _isArabic(context) ? 'في الانتظار' : 'Waiting';

  static String closed(BuildContext context) =>
      _isArabic(context) ? 'مغلق' : 'Closed';

  static String newLead(BuildContext context) =>
      _isArabic(context) ? 'عميل جديد' : 'New Lead';

  static String yesterdayShort(BuildContext context) =>
      _isArabic(context) ? 'أمس' : 'Yesterday';
}
