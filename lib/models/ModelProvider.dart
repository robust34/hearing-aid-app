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

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:amplify_core/amplify_core.dart';
import 'Hospital.dart';
import 'MedicalSpecialist.dart';
import 'Notification.dart';
import 'PointHistory.dart';
import 'RoomSuggestion.dart';
import 'Specialty.dart';
import 'Trouble.dart';
import 'Channel.dart';
import 'ChannelDetail.dart';
import 'CreateUserTokenResponse.dart';
import 'Member.dart';
import 'Message.dart';
import 'User.dart';

export 'Channel.dart';
export 'ChannelDetail.dart';
export 'CreateUserTokenResponse.dart';
export 'Hospital.dart';
export 'MedicalSpecialist.dart';
export 'Member.dart';
export 'Message.dart';
export 'Notification.dart';
export 'PointHistory.dart';
export 'RoomSuggestion.dart';
export 'Specialty.dart';
export 'Trouble.dart';
export 'User.dart';

class ModelProvider implements ModelProviderInterface {
  @override
  String version = "524137d29d9fe9c451cef97a86575cef";
  @override
  List<ModelSchema> modelSchemas = [Hospital.schema, MedicalSpecialist.schema, Notification.schema, PointHistory.schema, RoomSuggestion.schema, Specialty.schema, Trouble.schema];
  static final ModelProvider _instance = ModelProvider();
  @override
  List<ModelSchema> customTypeSchemas = [Channel.schema, ChannelDetail.schema, CreateUserTokenResponse.schema, Member.schema, Message.schema, User.schema];

  static ModelProvider get instance => _instance;
  
  ModelType getModelTypeByModelName(String modelName) {
    switch(modelName) {
      case "Hospital":
        return Hospital.classType;
      case "MedicalSpecialist":
        return MedicalSpecialist.classType;
      case "Notification":
        return Notification.classType;
      case "PointHistory":
        return PointHistory.classType;
      case "RoomSuggestion":
        return RoomSuggestion.classType;
      case "Specialty":
        return Specialty.classType;
      case "Trouble":
        return Trouble.classType;
      default:
        throw Exception("Failed to find model in model provider for model name: " + modelName);
    }
  }
}