import 'package:skillbridge/core/models/ad_model.dart';
import 'package:skillbridge/core/utils/validator/result.dart';

abstract class FirestoreRepo {
  Future<Result<AdModel>> getdata();
}
