import 'package:skillbridge/core/errors/app_exception.dart';
import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/profile/data/models/ad_post_model.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';
import 'package:skillbridge/features/profile/data/repos/profile_repo.dart';

/// Concrete implementation of [ProfileRepo].
/// Replace the mock data below with real API/Firestore calls when backend is ready.
/// Pattern mirrors [AuthRepoImplementation] exactly.
class ProfileRepoImplementation extends ProfileRepo {
  // TODO: inject your FirebaseFirestore or ApiService here when ready
  // final FirebaseFirestore _firestore;
  // ProfileRepoImplementation(this._firestore);

  @override
  Future<Result<UserProfileModel>> getUserProfile() async {
    try {
      // TODO: replace with real call e.g.:
      // final doc = await _firestore.collection('users').doc(uid).get();
      // return Success(UserProfileModel.fromJson(doc.data()!));

      await Future.delayed(const Duration(milliseconds: 600)); // simulate network
      return const Success(
        UserProfileModel(
          id: '1',
          name: 'Alex Johnson',
          memberSince: '2024',
          avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
          isVerified: true,
          rating: 4.8,
          reviews: 120,
          postsCount: 15,
          skills: ['UI Design', 'Graphic Design', 'Branding', 'React Native', 'Figma'],
        ),
      );
    } on AppException catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<List<AdPostModel>>> getMyPosts() async {
    try {
      // TODO: replace with real Firestore/API query
      await Future.delayed(const Duration(milliseconds: 300));
      return const Success([
        AdPostModel(
          id: '1',
          title: 'Professional Mobile App UI Design',
          priceRange: 'EGP 2,200 - EGP 3,900 / hr',
          location: 'San Francisco, CA',
          imageUrl: 'https://picsum.photos/seed/mobile/200/200',
          badge: 'GREAT MATCH',
        ),
        AdPostModel(
          id: '2',
          title: 'Logo Branding & Style Guide',
          priceRange: '24,000 ج.م - 58,000 ج.م / project',
          location: 'Remote',
          imageUrl: 'https://picsum.photos/seed/logo/200/200',
        ),
        AdPostModel(
          id: '3',
          title: 'React Component Library Development',
          priceRange: 'EGP 2,900 / hr',
          location: 'New York, NY',
          imageUrl: 'https://picsum.photos/seed/react/200/200',
        ),
      ]);
    } on AppException catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<List<AdPostModel>>> getActivityPosts() async {
    try {
      // TODO: replace with real activity feed query
      await Future.delayed(const Duration(milliseconds: 300));
      return const Success([]); // empty until backend is ready
    } on AppException catch (e) {
      return Failure(e);
    }
  }
}
