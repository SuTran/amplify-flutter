/*
 * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

import 'dart:async';

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:meta/meta.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'amplify_datastore_stream_controller.dart';
import 'method_channel_datastore.dart';

export 'package:amplify_datastore_plugin_interface/src/publicTypes.dart';

class AmplifyDataStore extends DataStorePluginInterface {
  static final Object _token = Object();

  /// Constructs an AmplifyDataStore plugin with mandatory [modelProvider]
  /// and optional datastore configuration properties including
  ///
  /// [syncExpressions]: list of sync expressions to filter datastore sync against
  ///
  /// [syncInterval]: datastore syncing interval (in seconds)
  ///
  /// [syncMaxRecords]: max number of records to sync
  ///
  /// [syncPageSize]: page size to sync
  AmplifyDataStore({
    required ModelProviderInterface modelProvider,
    List<DataStoreSyncExpression> syncExpressions = const [],
    int? syncInterval,
    int? syncMaxRecords,
    int? syncPageSize,
  }) : super(
          token: _token,
          modelProvider: modelProvider,
          syncExpressions: syncExpressions,
          syncInterval: syncInterval,
          syncMaxRecords: syncMaxRecords,
          syncPageSize: syncPageSize,
        );

  /// Internal use constructor
  @protected
  AmplifyDataStore.tokenOnly() : super.tokenOnly(token: _token);

  static AmplifyDataStore _instance = AmplifyDataStoreMethodChannel();
  static DataStoreStreamController streamWrapper = DataStoreStreamController();

  static set instance(DataStorePluginInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance as AmplifyDataStore;
  }

  StreamController get streamController {
    return streamWrapper.datastoreStreamController;
  }

  @override
  Future<void> configureDataStore({
    ModelProviderInterface? modelProvider,
    List<DataStoreSyncExpression>? syncExpressions,
    int? syncInterval,
    int? syncMaxRecords,
    int? syncPageSize,
  }) async {
    ModelProviderInterface provider = modelProvider ?? this.modelProvider!;
    if (provider.modelSchemas.isEmpty) {
      throw DataStoreException('No modelProvider or modelSchemas found',
          recoverySuggestion:
              'Pass in a modelProvider instance while instantiating DataStorePlugin');
    }
    streamWrapper.registerModelsForHub(provider);
    return _instance.configureDataStore(
      modelProvider: provider,
      syncExpressions: this.syncExpressions,
      syncInterval: this.syncInterval,
      syncMaxRecords: this.syncMaxRecords,
      syncPageSize: this.syncPageSize,
    );
  }

  @override
  Future<void> configure({String? configuration}) async {
    return _instance.configure(configuration: configuration);
  }

  @override
  Future<List<T>> query<T extends Model>(ModelType<T> modelType,
      {QueryPredicate? where,
      QueryPagination? pagination,
      List<QuerySortBy>? sortBy}) async {
    return _instance.query(modelType,
        where: where, pagination: pagination, sortBy: sortBy);
  }

  @override
  Future<void> delete<T extends Model>(T model) async {
    return _instance.delete(model);
  }

  @override
  Future<void> save<T extends Model>(T model) {
    return _instance.save(model);
  }

  @override
  Stream<SubscriptionEvent<T>> observe<T extends Model>(
      ModelType<T> modelType) {
    return _instance.observe(modelType);
  }

  @override
  Future<void> clear() async {
    return _instance.clear();
  }

  @override
  Future<void> start() async {
    return _instance.start();
  }

  @override
  Future<void> stop() async {
    return _instance.stop();
  }
}
