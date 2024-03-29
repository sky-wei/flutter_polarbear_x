// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import '../data/entity/account_entity.dart';
import '../data/entity/admin_entity.dart';
import '../data/entity/folder_entity.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 7243920561383345351),
      name: 'AccountEntity',
      lastPropertyId: const IdUid(13, 732885442028952931),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6618971053497472697),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 7499360944018734015),
            name: 'adminId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 7498129903544109014),
            name: 'alias',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 8451152365234876964),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 3443911853882744166),
            name: 'password',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 7204257963088120383),
            name: 'url',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 735216984544301895),
            name: 'node',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 5607975824042696162),
            name: 'folderId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 3522479104907954916),
            name: 'favorite',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 9215705905769326182),
            name: 'trash',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 6257958827909214274),
            name: 'createTime',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 2316121011874826872),
            name: 'updateTime',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 732885442028952931),
            name: 'version',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(2, 7229556591746610788),
      name: 'AdminEntity',
      lastPropertyId: const IdUid(7, 5346329168322733736),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 303164366444706577),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 5495362310273198486),
            name: 'name',
            type: 9,
            flags: 2080,
            indexId: const IdUid(1, 6214150832406744158)),
        ModelProperty(
            id: const IdUid(3, 1566734422845387504),
            name: 'password',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 3410483970049015189),
            name: 'desc',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 9172638734654771728),
            name: 'createTime',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 2741697708274369194),
            name: 'updateTime',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 5346329168322733736),
            name: 'headImage',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(3, 8350531745845790151),
      name: 'FolderEntity',
      lastPropertyId: const IdUid(4, 7970571712746313481),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 3060842957316074954),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 8675753262262574228),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 7661035055685820640),
            name: 'createTime',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 7970571712746313481),
            name: 'adminId',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(3, 8350531745845790151),
      lastIndexId: const IdUid(2, 8578202736251352447),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [8578202736251352447],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    AccountEntity: EntityDefinition<AccountEntity>(
        model: _entities[0],
        toOneRelations: (AccountEntity object) => [],
        toManyRelations: (AccountEntity object) => {},
        getId: (AccountEntity object) => object.id,
        setId: (AccountEntity object, int id) {
          object.id = id;
        },
        objectToFB: (AccountEntity object, fb.Builder fbb) {
          final aliasOffset = fbb.writeString(object.alias);
          final nameOffset = fbb.writeString(object.name);
          final passwordOffset = fbb.writeString(object.password);
          final urlOffset = fbb.writeString(object.url);
          final nodeOffset = fbb.writeString(object.node);
          fbb.startTable(14);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.adminId);
          fbb.addOffset(2, aliasOffset);
          fbb.addOffset(3, nameOffset);
          fbb.addOffset(4, passwordOffset);
          fbb.addOffset(5, urlOffset);
          fbb.addOffset(6, nodeOffset);
          fbb.addInt64(7, object.folderId);
          fbb.addBool(8, object.favorite);
          fbb.addBool(9, object.trash);
          fbb.addInt64(10, object.createTime);
          fbb.addInt64(11, object.updateTime);
          fbb.addInt64(12, object.version);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = AccountEntity(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              adminId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              alias: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 8, ''),
              name: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 10, ''),
              password: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 12, ''),
              url: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 14, ''),
              node: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 16, ''),
              folderId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 18, 0),
              favorite: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 20, false),
              trash: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 22, false),
              createTime: const fb.Int64Reader().vTableGet(buffer, rootOffset, 24, 0),
              updateTime: const fb.Int64Reader().vTableGet(buffer, rootOffset, 26, 0),
              version: const fb.Int64Reader().vTableGet(buffer, rootOffset, 28, 0));

          return object;
        }),
    AdminEntity: EntityDefinition<AdminEntity>(
        model: _entities[1],
        toOneRelations: (AdminEntity object) => [],
        toManyRelations: (AdminEntity object) => {},
        getId: (AdminEntity object) => object.id,
        setId: (AdminEntity object, int id) {
          object.id = id;
        },
        objectToFB: (AdminEntity object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final passwordOffset = fbb.writeString(object.password);
          final descOffset = fbb.writeString(object.desc);
          final headImageOffset = fbb.writeString(object.headImage);
          fbb.startTable(8);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, passwordOffset);
          fbb.addOffset(3, descOffset);
          fbb.addInt64(4, object.createTime);
          fbb.addInt64(5, object.updateTime);
          fbb.addOffset(6, headImageOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = AdminEntity(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              name: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, ''),
              password: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 8, ''),
              headImage: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 16, ''),
              desc: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 10, ''),
              createTime:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0),
              updateTime:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0));

          return object;
        }),
    FolderEntity: EntityDefinition<FolderEntity>(
        model: _entities[2],
        toOneRelations: (FolderEntity object) => [],
        toManyRelations: (FolderEntity object) => {},
        getId: (FolderEntity object) => object.id,
        setId: (FolderEntity object, int id) {
          object.id = id;
        },
        objectToFB: (FolderEntity object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addInt64(2, object.createTime);
          fbb.addInt64(3, object.adminId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = FolderEntity(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              adminId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0),
              name: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, ''),
              createTime:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [AccountEntity] entity fields to define ObjectBox queries.
class AccountEntity_ {
  /// see [AccountEntity.id]
  static final id =
      QueryIntegerProperty<AccountEntity>(_entities[0].properties[0]);

  /// see [AccountEntity.adminId]
  static final adminId =
      QueryIntegerProperty<AccountEntity>(_entities[0].properties[1]);

  /// see [AccountEntity.alias]
  static final alias =
      QueryStringProperty<AccountEntity>(_entities[0].properties[2]);

  /// see [AccountEntity.name]
  static final name =
      QueryStringProperty<AccountEntity>(_entities[0].properties[3]);

  /// see [AccountEntity.password]
  static final password =
      QueryStringProperty<AccountEntity>(_entities[0].properties[4]);

  /// see [AccountEntity.url]
  static final url =
      QueryStringProperty<AccountEntity>(_entities[0].properties[5]);

  /// see [AccountEntity.node]
  static final node =
      QueryStringProperty<AccountEntity>(_entities[0].properties[6]);

  /// see [AccountEntity.folderId]
  static final folderId =
      QueryIntegerProperty<AccountEntity>(_entities[0].properties[7]);

  /// see [AccountEntity.favorite]
  static final favorite =
      QueryBooleanProperty<AccountEntity>(_entities[0].properties[8]);

  /// see [AccountEntity.trash]
  static final trash =
      QueryBooleanProperty<AccountEntity>(_entities[0].properties[9]);

  /// see [AccountEntity.createTime]
  static final createTime =
      QueryIntegerProperty<AccountEntity>(_entities[0].properties[10]);

  /// see [AccountEntity.updateTime]
  static final updateTime =
      QueryIntegerProperty<AccountEntity>(_entities[0].properties[11]);

  /// see [AccountEntity.version]
  static final version =
      QueryIntegerProperty<AccountEntity>(_entities[0].properties[12]);
}

/// [AdminEntity] entity fields to define ObjectBox queries.
class AdminEntity_ {
  /// see [AdminEntity.id]
  static final id =
      QueryIntegerProperty<AdminEntity>(_entities[1].properties[0]);

  /// see [AdminEntity.name]
  static final name =
      QueryStringProperty<AdminEntity>(_entities[1].properties[1]);

  /// see [AdminEntity.password]
  static final password =
      QueryStringProperty<AdminEntity>(_entities[1].properties[2]);

  /// see [AdminEntity.desc]
  static final desc =
      QueryStringProperty<AdminEntity>(_entities[1].properties[3]);

  /// see [AdminEntity.createTime]
  static final createTime =
      QueryIntegerProperty<AdminEntity>(_entities[1].properties[4]);

  /// see [AdminEntity.updateTime]
  static final updateTime =
      QueryIntegerProperty<AdminEntity>(_entities[1].properties[5]);

  /// see [AdminEntity.headImage]
  static final headImage =
      QueryStringProperty<AdminEntity>(_entities[1].properties[6]);
}

/// [FolderEntity] entity fields to define ObjectBox queries.
class FolderEntity_ {
  /// see [FolderEntity.id]
  static final id =
      QueryIntegerProperty<FolderEntity>(_entities[2].properties[0]);

  /// see [FolderEntity.name]
  static final name =
      QueryStringProperty<FolderEntity>(_entities[2].properties[1]);

  /// see [FolderEntity.createTime]
  static final createTime =
      QueryIntegerProperty<FolderEntity>(_entities[2].properties[2]);

  /// see [FolderEntity.adminId]
  static final adminId =
      QueryIntegerProperty<FolderEntity>(_entities[2].properties[3]);
}
