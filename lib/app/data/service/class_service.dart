import 'package:blooket/app/data/model/class_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Nhớ import file model của bạn
// import 'package:blooket/app/data/model/class_model.dart';

class ClassService {
  // Tham chiếu đến collection 'classes' trên Firestore
  final CollectionReference _classCollection = FirebaseFirestore.instance
      .collection('classes');

  // --- GET: Lấy danh sách lớp ---
  Future<List<ClassModel>> getClasses() async {
    try {
      QuerySnapshot snapshot = await _classCollection.get();

      // Map từng document thành ClassModel
      return snapshot.docs.map((doc) {
        return ClassModel.fromSnapshot(doc);
      }).toList();
    } catch (e) {
      print("Lỗi lấy danh sách lớp: $e");
      return []; // Trả về rỗng nếu lỗi
    }
  }

  // --- REAL-TIME GET (Optional): Lấy danh sách dạng Stream ---
  // Dùng cái này nếu muốn danh sách tự cập nhật khi có thay đổi trên DB
  Stream<List<ClassModel>> getClassesStream() {
    return _classCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ClassModel.fromSnapshot(doc)).toList();
    });
  }

  // --- ADD: Thêm lớp mới ---
  Future<bool> addClass({
    required String className,
    required String subject,
    required String schedule,
    int studentCount = 0,
  }) async {
    try {
      // Tạo object data
      final newClassData = {
        'className': className,
        'subject': subject,
        'schedule': schedule,
        'studentCount': studentCount,
        'createdAt': FieldValue.serverTimestamp(), // Nên lưu thêm thời gian tạo
      };

      // Firestore tự động sinh ID ngẫu nhiên với hàm .add()
      await _classCollection.add(newClassData);
      return true;
    } catch (e) {
      print("Lỗi thêm lớp: $e");
      return false;
    }
  }

  // --- UPDATE: Sửa thông tin lớp ---
  Future<bool> updateClass({
    required String id,
    String? className,
    String? subject,
    String? schedule,
    int? studentCount,
  }) async {
    try {
      // Tạo map chứa các trường cần update
      final Map<String, dynamic> updateData = {};

      // Chỉ thêm vào map những giá trị không null
      if (className != null) updateData['className'] = className;
      if (subject != null) updateData['subject'] = subject;
      if (schedule != null) updateData['schedule'] = schedule;
      if (studentCount != null) updateData['studentCount'] = studentCount;

      // Gọi lệnh update
      await _classCollection.doc(id).update(updateData);
      return true;
    } catch (e) {
      print("Lỗi sửa lớp: $e");
      return false;
    }
  }

  // --- DELETE: Xóa lớp ---
  Future<bool> deleteClass(String id) async {
    try {
      await _classCollection.doc(id).delete();
      return true;
    } catch (e) {
      print("Lỗi xóa lớp: $e");
      return false;
    }
  }
}
