import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0, // Số lượng hàm trong stacktrace được in
    errorMethodCount: 5, // Số lượng hàm nếu có lỗi
    lineLength: 80, // Độ dài đường kẻ
    colors: true, // In màu (cho VS Code/Android Studio)
    printEmojis: true, // Hiển thị icon
    printTime: true, // Hiển thị thời gian
  ),
);
