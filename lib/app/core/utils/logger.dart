import 'package:logger/logger.dart';

final logger = Logger(
  level: Level.all,
  printer: PrettyPrinter(
    methodCount: 0, // Không in stacktrace cho log thường để tránh rối mắt
    errorMethodCount: 8, // In stacktrace chi tiết khi có lỗi (Error)
    lineLength: 100, // Tăng độ rộng để chứa được nhiều JSON hơn trên 1 dòng
    colors: true, // Bật màu sắc để phân biệt các tầng (Info, Warning, Error)
    printEmojis: true, // Hiển thị icon (🚀, ✅, ❌) giúp nhận diện nhanh
    printTime:
        false, // Tắt thời gian nếu bạn thấy rối, hoặc bật nếu cần track performance
    noBoxingByDefault:
        false, // Giữ khung (box) để bao bọc dữ liệu, giúp dễ tách biệt các lần log
  ),
);
