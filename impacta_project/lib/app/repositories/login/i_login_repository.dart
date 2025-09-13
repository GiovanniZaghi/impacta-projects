import '../../model/user_model.dart';

abstract class ILoginRepository {
  Future<UserModel> login({required String email, required String password});
}
