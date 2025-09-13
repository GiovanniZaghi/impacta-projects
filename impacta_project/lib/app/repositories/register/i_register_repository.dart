import '../../model/user_model.dart';

abstract class IRegisterRepository {
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String birthday,
  });
}
