// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String barcode;
  final String name;
  final String brand;
  final String category;
  final int quantity;
  final DateTime expiryDate;
  final String fridgeId;
  final String status;
  final DateTime createdAt;
  const Product({
    required this.id,
    required this.barcode,
    required this.name,
    required this.brand,
    required this.category,
    required this.quantity,
    required this.expiryDate,
    required this.fridgeId,
    required this.status,
    required this.createdAt,
  });

  @override
  Map<String, Expression<Object>> toColumns(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      barcode: Value(barcode),
      name: Value(name),
      brand: Value(brand),
      category: Value(category),
      quantity: Value(quantity),
      expiryDate: Value(expiryDate),
      fridgeId: Value(fridgeId),
      status: Value(status),
      createdAt: Value(createdAt),
    ).toColumns(nullToAbsent);
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'barcode': serializer.toJson<String>(barcode),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String>(brand),
      'category': serializer.toJson<String>(category),
      'quantity': serializer.toJson<int>(quantity),
      'expiryDate': serializer.toJson<DateTime>(expiryDate),
      'fridgeId': serializer.toJson<String>(fridgeId),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> barcode;
  final Value<String> name;
  final Value<String> brand;
  final Value<String> category;
  final Value<int> quantity;
  final Value<DateTime> expiryDate;
  final Value<String> fridgeId;
  final Value<String> status;
  final Value<DateTime> createdAt;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.barcode = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.category = const Value.absent(),
    this.quantity = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.fridgeId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });

  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String barcode,
    required String name,
    required String brand,
    required String category,
    required int quantity,
    required DateTime expiryDate,
    required String fridgeId,
    required String status,
    required DateTime createdAt,
  })  : barcode = Value(barcode),
        name = Value(name),
        brand = Value(brand),
        category = Value(category),
        quantity = Value(quantity),
        expiryDate = Value(expiryDate),
        fridgeId = Value(fridgeId),
        status = Value(status),
        createdAt = Value(createdAt);

  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? barcode,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? category,
    Expression<int>? quantity,
    Expression<DateTime>? expiryDate,
    Expression<String>? fridgeId,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (barcode != null) 'barcode': barcode,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (category != null) 'category': category,
      if (quantity != null) 'quantity': quantity,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (fridgeId != null) 'fridge_id': fridgeId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProductsCompanion copyWith({
    Value<int>? id,
    Value<String>? barcode,
    Value<String>? name,
    Value<String>? brand,
    Value<String>? category,
    Value<int>? quantity,
    Value<DateTime>? expiryDate,
    Value<String>? fridgeId,
    Value<String>? status,
    Value<DateTime>? createdAt,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      expiryDate: expiryDate ?? this.expiryDate,
      fridgeId: fridgeId ?? this.fridgeId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression<Object>> toColumns(bool nullToAbsent) {
    final map = <String, Expression<Object>>{};
    if (id.present) map['id'] = Variable<int>(id.value);
    if (barcode.present) map['barcode'] = Variable<String>(barcode.value);
    if (name.present) map['name'] = Variable<String>(name.value);
    if (brand.present) map['brand'] = Variable<String>(brand.value);
    if (category.present) map['category'] = Variable<String>(category.value);
    if (quantity.present) map['quantity'] = Variable<int>(quantity.value);
    if (expiryDate.present) map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    if (fridgeId.present) map['fridge_id'] = Variable<String>(fridgeId.value);
    if (status.present) map['status'] = Variable<String>(status.value);
    if (createdAt.present) map['created_at'] = Variable<DateTime>(createdAt.value);
    return map;
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);

  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    hasAutoIncrement: true,
    requiredDuringInsert: false,
  );

  static const VerificationMeta _barcodeMeta = VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _nameMeta = VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _brandMeta = VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _categoryMeta = VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _quantityMeta = VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _expiryDateMeta = VerificationMeta('expiryDate');
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
    'expiry_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _fridgeIdMeta = VerificationMeta('fridgeId');
  @override
  late final GeneratedColumn<String> fridgeId = GeneratedColumn<String>(
    'fridge_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _statusMeta = VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );

  @override
  List<GeneratedColumn> get $columns =>
      [id, barcode, name, brand, category, quantity, expiryDate, fridgeId, status, createdAt];

  @override
  String get aliasedName => _alias ?? actualTableName;

  @override
  String get actualTableName => 'products';

  @override
  VerificationContext validateIntegrity(Insertable<Product> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta, barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(_brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta, category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta, quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    } else if (isInserting) {
      context.missing(_expiryDateMeta);
    }
    if (data.containsKey('fridge_id')) {
      context.handle(_fridgeIdMeta, fridgeId.isAcceptableOrUnknown(data['fridge_id']!, _fridgeIdMeta));
    } else if (isInserting) {
      context.missing(_fridgeIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta, status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      barcode: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}barcode'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      brand: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}brand'])!,
      category: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      quantity: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      expiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expiry_date'],
      )!,
      fridgeId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}fridge_id'])!,
      status: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $ProductsTable products = $ProductsTable(this);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables => [products];

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [products];
}
