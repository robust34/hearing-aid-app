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

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the CreateUserTokenResponse type in your schema. */
@immutable
class CreateUserTokenResponse {
  final String? _token;
  final List<ChannelDetail>? _rooms;

  String get token {
    try {
      return _token!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<ChannelDetail> get rooms {
    try {
      return _rooms!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  const CreateUserTokenResponse._internal({required token, required rooms}): _token = token, _rooms = rooms;
  
  factory CreateUserTokenResponse({required String token, required List<ChannelDetail> rooms}) {
    return CreateUserTokenResponse._internal(
      token: token,
      rooms: rooms != null ? List<ChannelDetail>.unmodifiable(rooms) : rooms);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateUserTokenResponse &&
      _token == other._token &&
      DeepCollectionEquality().equals(_rooms, other._rooms);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("CreateUserTokenResponse {");
    buffer.write("token=" + "$_token" + ", ");
    buffer.write("rooms=" + (_rooms != null ? _rooms!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  CreateUserTokenResponse copyWith({String? token, List<ChannelDetail>? rooms}) {
    return CreateUserTokenResponse._internal(
      token: token ?? this.token,
      rooms: rooms ?? this.rooms);
  }
  
  CreateUserTokenResponse.fromJson(Map<String, dynamic> json)  
    : _token = json['token'],
      _rooms = json['rooms'] is List
        ? (json['rooms'] as List)
          .where((e) => e != null)
          .map((e) => ChannelDetail.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null;
  
  Map<String, dynamic> toJson() => {
    'token': _token, 'rooms': _rooms?.map((ChannelDetail? e) => e?.toJson()).toList()
  };
  
  Map<String, Object?> toMap() => {
    'token': _token, 'rooms': _rooms
  };

  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "CreateUserTokenResponse";
    modelSchemaDefinition.pluralName = "CreateUserTokenResponses";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'token',
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.embedded(
      fieldName: 'rooms',
      isRequired: true,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.embeddedCollection, ofCustomTypeName: 'ChannelDetail')
    ));
  });
}