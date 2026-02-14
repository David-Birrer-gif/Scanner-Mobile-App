import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/notifications/data/notification_orchestrator.dart';
import '../../features/notifications/data/notification_service.dart';
import '../../features/products/data/datasources/app_database.dart';
import '../../features/products/data/datasources/open_food_facts_api.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/delete_product_usecase.dart';
import '../../features/products/domain/usecases/get_effective_reminder_rules_usecase.dart';
import '../../features/products/domain/usecases/get_products_usecase.dart';
import '../../features/products/domain/usecases/save_product_usecase.dart';
import '../../features/products/domain/usecases/update_product_status_usecase.dart';
import '../../features/products/domain/usecases/upsert_product_usecase.dart';

final appLocaleProvider = StateProvider<Locale>((_) => const Locale('en'));

final dioProvider = Provider((_) => Dio());
final databaseProvider = Provider((_) => AppDatabase());
final foodApiProvider = Provider((ref) => OpenFoodFactsApi(ref.watch(dioProvider)));

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(ref.watch(databaseProvider)),
);

final notificationsPluginProvider = Provider((_) => FlutterLocalNotificationsPlugin());
final notificationServiceProvider = Provider(
  (ref) => NotificationService(ref.watch(notificationsPluginProvider)),
);

final notificationOrchestratorProvider = Provider(
  (ref) => NotificationOrchestrator(
    ref.watch(productRepositoryProvider),
    ref.watch(notificationServiceProvider),
  ),
);

final getProductsUseCaseProvider =
    Provider((ref) => GetProductsUseCase(ref.watch(productRepositoryProvider)));
final saveProductUseCaseProvider =
    Provider((ref) => SaveProductUseCase(ref.watch(productRepositoryProvider)));
final upsertProductUseCaseProvider = Provider(
  (ref) => UpsertProductUseCase(
    ref.watch(productRepositoryProvider),
    ref.watch(notificationOrchestratorProvider),
  ),
);
final deleteProductUseCaseProvider = Provider(
  (ref) => DeleteProductUseCase(
    ref.watch(productRepositoryProvider),
    ref.watch(notificationOrchestratorProvider),
  ),
);
final updateProductStatusUseCaseProvider = Provider(
  (ref) => UpdateProductStatusUseCase(
    ref.watch(productRepositoryProvider),
    ref.watch(notificationOrchestratorProvider),
  ),
);
final getEffectiveReminderRulesUseCaseProvider = Provider(
  (ref) => GetEffectiveReminderRulesUseCase(ref.watch(productRepositoryProvider)),
);
