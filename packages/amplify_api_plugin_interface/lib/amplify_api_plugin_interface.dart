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

library amplify_api_plugin_interface;

import 'dart:async';

import 'package:amplify_core/types/index.dart';

import 'src/types.dart';
export 'src/types.dart';

abstract class APIPluginInterface extends AmplifyPluginInterface {
  APIPluginInterface({required Object token}) : super(token: token);

  Future<APIAuthProviderRefresher> addPlugin() async {
    throw UnimplementedError('addPlugin() has not been implemented.');
  }

  // ====== GraphQL =======
  GraphQLOperation<T> query<T>({required GraphQLRequest<T> request}) {
    throw UnimplementedError('query() has not been implemented.');
  }

  GraphQLOperation<T> mutate<T>({required GraphQLRequest<T> request}) {
    throw UnimplementedError('mutate() has not been implemented.');
  }

  GraphQLSubscriptionOperation<T> subscribe<T>(
      {required GraphQLRequest<T> request,
      required void Function(GraphQLResponse<T>) onData,
      Function()? onEstablished,
      Function(dynamic)? onError,
      Function()? onDone}) {
    throw UnimplementedError('subscribe() has not been implemented.');
  }

  /// Registers an [APIAuthProvider] with this plugin.
  void registerAuthProvider(APIAuthProvider authProvider);

  // ====== RestAPI ======
  void cancelRequest(String cancelToken) {
    throw UnimplementedError('cancelRequest has not been implemented.');
  }

  RestOperation get({required RestOptions restOptions}) {
    throw UnimplementedError('get has not been implemented.');
  }

  RestOperation put({required RestOptions restOptions}) {
    throw UnimplementedError('put has not been implemented.');
  }

  RestOperation post({required RestOptions restOptions}) {
    throw UnimplementedError('post has not been implemented.');
  }

  RestOperation delete({required RestOptions restOptions}) {
    throw UnimplementedError('delete has not been implemented.');
  }

  RestOperation head({required RestOptions restOptions}) {
    throw UnimplementedError('head has not been implemented.');
  }

  RestOperation patch({required RestOptions restOptions}) {
    throw UnimplementedError('patch has not been implemented.');
  }
}
