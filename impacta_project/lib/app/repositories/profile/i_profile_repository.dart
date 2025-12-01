abstract class IProfileRepository {
  Future<void> editProfile(
    int id,
    String? name,
    String? email,
    String? password,
  );
  Future<void> removeUser(int id);
}
