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


/** This is an auto generated class representing the ChannelDetail type in your schema. */
@immutable
class ChannelDetail {
  final Channel? _channel;
  final List<Member>? _members;
  final List<Message>? _messages;

  Channel get channel {
    try {
      return _channel!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<Member> get members {
    try {
      return _members!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<Message> get messages {
    try {
      return _messages!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  const ChannelDetail._internal({required channel, required members, required messages}): _channel = channel, _members = members, _messages = messages;
  
  factory ChannelDetail({required Channel channel, required List<Member> members, required List<Message> messages}) {
    return ChannelDetail._internal(
      channel: channel,
      members: members != null ? List<Member>.unmodifiable(members) : members,
      messages: messages != null ? List<Message>.unmodifiable(messages) : messages);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChannelDetail &&
      _channel == other._channel &&
      DeepCollectionEquality().equals(_members, other._members) &&
      DeepCollectionEquality().equals(_messages, other._messages);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ChannelDetail {");
    buffer.write("channel=" + (_channel != null ? _channel!.toString() : "null") + ", ");
    buffer.write("members=" + (_members != null ? _members!.toString() : "null") + ", ");
    buffer.write("messages=" + (_messages != null ? _messages!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ChannelDetail copyWith({Channel? channel, List<Member>? members, List<Message>? messages}) {
    return ChannelDetail._internal(
      channel: channel ?? this.channel,
      members: members ?? this.members,
      messages: messages ?? this.messages);
  }
  
  ChannelDetail.fromJson(Map<String, dynamic> json)  
    : _channel = json['channel']?['serializedData'] != null
        ? Channel.fromJson(new Map<String, dynamic>.from(json['channel']['serializedData']))
        : null,
      _members = json['members'] is List
        ? (json['members'] as List)
          .where((e) => e != null)
          .map((e) => Member.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _messages = json['messages'] is List
        ? (json['messages'] as List)
          .where((e) => e != null)
          .map((e) => Message.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null;
  
  Map<String, dynamic> toJson() => {
    'channel': _channel?.toJson(), 'members': _members?.map((Member? e) => e?.toJson()).toList(), 'messages': _messages?.map((Message? e) => e?.toJson()).toList()
  };
  
  Map<String, Object?> toMap() => {
    'channel': _channel, 'members': _members, 'messages': _messages
  };

  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ChannelDetail";
    modelSchemaDefinition.pluralName = "ChannelDetails";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.embedded(
      fieldName: 'channel',
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.embedded, ofCustomTypeName: 'Channel')
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.embedded(
      fieldName: 'members',
      isRequired: true,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.embeddedCollection, ofCustomTypeName: 'Member')
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.embedded(
      fieldName: 'messages',
      isRequired: true,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.embeddedCollection, ofCustomTypeName: 'Message')
    ));
  });
}