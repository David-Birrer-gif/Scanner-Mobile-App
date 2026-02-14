import '../../../notifications/domain/reminder_rule.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Stream<List<Product>> watchProducts({bool activeOnly = false});
  Future<int> upsert(Product product);
  Future<void> delete(int id);
  Future<void> updateStatus(int id, ProductStatus status);
  Future<List<int>> getGlobalReminderOffsets();
  Future<void> saveGlobalReminderOffsets(List<int> offsets);
  Future<List<int>?> getProductReminderOverrides(int productId);
  Future<void> saveProductReminderOverrides(int productId, List<int>? offsets);
  Future<void> saveScheduledNotifications(
    int productId,
    List<ReminderSchedule> schedules,
  );
  Future<List<ReminderSchedule>> getScheduledNotifications(int productId);
  Future<void> deleteScheduledNotifications(int productId);
  Future<List<Product>> getActiveProducts();
  Future<List<Product>> getExpiringSoon({required int days});
  Future<List<Product>> getExpired();
  Future<Map<ProductStatus, int>> getStatusCounts();
  Future<List<CategoryStat>> getCategoryStats();
}
