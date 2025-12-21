import 'package:blooket/app/data/model/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Hàm đăng nhập
  Future<StudentModel?> login(String username, String password) async {
    try {
      // 1. Tìm user theo username trong collection 'students' (hoặc 'users')
      final QuerySnapshot result = await _firestore
          .collection('students') 
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (result.docs.isEmpty) {
        return null; // Không tìm thấy user
      }

      // 2. Lấy dữ liệu user
      final userDoc = result.docs.first;
      final userModel = StudentModel.fromSnapshot(userDoc);

      // 3. Kiểm tra mật khẩu (So sánh string thông thường)
      // Lưu ý: Dự án thực tế nên mã hóa mật khẩu (bcrypt/sha256)
      if (userModel.password == password) {
        return userModel;
      } else {
        return null; // Sai mật khẩu
      }
    } catch (e) {
      print("Login Error: $e");
      throw Exception("Lỗi kết nối cơ sở dữ liệu");
    }
  }
}