/*
 * Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
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

part of amplify_interface;

/// Interface for DataStore category. This expose all the APIs that
/// are supported by this category's plugins. This class will accept plugins to
/// be registered and configured and then subsequent API calls will be forwarded
/// to those plugins.
class DataStoreCategory {
  /// Default constant constructor
  const DataStoreCategory();

  /// Added DataStore plugins.
  static List<DataStorePluginInterface> plugins = [];

  /// Add DataStore plugin
  Future<void> addPlugin(DataStorePluginInterface plugin) async {
    // TODO: Discuss and support multiple plugins
    if (plugins.length == 0) {
      try {
        _refreshAuthProviders();
        // Extra step to configure datastore specifically.
        // Note: The native datastore plugins are not added
        // in the `onAttachedToEngine` but rather in the `configure()
        await plugin.configureDataStore(modelProvider: plugin.modelProvider!);
        plugins.add(plugin);
      } on AmplifyAlreadyConfiguredException {
        plugins.add(plugin);
      } on PlatformException catch (e) {
        throw AmplifyException.fromMap(Map<String, String>.from(e.details));
      }
    } else {
      throw AmplifyException(
          "DataStore plugin has already been added, multiple plugins for DataStore category are currently not supported.");
    }
  }

  /// Get [streamController]
  StreamController get streamController {
    _refreshAuthProviders();
    return plugins.length == 1
        ? plugins[0].streamController
        : throw _pluginNotAddedException("DataStore");
  }

  /// Configure DataStore
  Future<void> configure(String configuration) async {
    _refreshAuthProviders();
    if (plugins.length == 1) {
      return plugins[0].configure(configuration: configuration);
    }
  }

  /// Query the DataStore to find all items of the specified [modelType] that satisfy the specified
  /// query predicate [where]. Returned items are paginated by [pagination] and sorted by [sortBy].
  Future<List<T>> query<T extends Model>(ModelType<T> modelType,
      {QueryPredicate? where,
      QueryPagination? pagination,
      List<QuerySortBy>? sortBy}) {
    _refreshAuthProviders();
    return plugins.length == 1
        ? plugins[0].query(modelType,
            where: where, pagination: pagination, sortBy: sortBy)
        : throw _pluginNotAddedException("DataStore");
  }

  /// Delete [model] from the DataStore.
  Future<void> delete<T extends Model>(T model) {
    _refreshAuthProviders();
    return plugins.length == 1
        ? plugins[0].delete(model)
        : throw _pluginNotAddedException("DataStore");
  }

  /// Save [model] into the DataStore.
  Future<void> save<T extends Model>(T model) {
    _refreshAuthProviders();
    return plugins.length == 1
        ? plugins[0].save(model)
        : throw _pluginNotAddedException("DataStore");
  }

  /// Observe changes on the specified [modelType].
  Stream<SubscriptionEvent<T>> observe<T extends Model>(
      ModelType<T> modelType) {
    _refreshAuthProviders();
    return plugins.length == 1
        ? plugins[0].observe(modelType)
        : throw _pluginNotAddedException("DataStore");
  }

  /// Stops the underlying DataStore, resetting the plugin to the initialized state, and deletes all data
  /// from the local device. Remotely synced data can be re-synced back when starting DataStore using
  /// [start]. local-only data will be lost permanently.
  Future<void> clear() {
    _refreshAuthProviders();
    return plugins.length == 1
        ? plugins[0].clear()
        : throw _pluginNotAddedException("DataStore");
  }

  /// Starts the DataStore's synchronization with a remote system, if DataStore is configured to support
  /// remote synchronization. This only needs to be called if you wish to start the synchronization eagerly.
  /// If you don't call start(), the synchronization will start automatically, prior to executing any other
  /// operations (query, save, delete, update).
  Future<void> start() {
    _refreshAuthProviders();
    return plugins.length == 1
        ? plugins[0].start()
        : throw _pluginNotAddedException("DataStore");
  }

  /// Stops the underlying DataStore's synchronization with a remote system, if DataStore is configured to
  /// support remote synchronization.
  Future<void> stop() {
    _refreshAuthProviders();
    return plugins.length == 1
        ? plugins[0].stop()
        : throw _pluginNotAddedException("DataStore");
  }

  /// Refreshes API auth providers in a microtask, so that they are available
  /// for the next DataStore call.
  void _refreshAuthProviders() {
    APICategory._authProviderRefreshers.values.forEach(scheduleMicrotask);
  }
}
