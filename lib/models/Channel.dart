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
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Channel type in your schema. */
@immutable
class Channel {
  final String id;
  final String? _type;
  final String? _image;
  final String? _name;
  final String? _description;

  String? get type {
    return _type;
  }
  
  String? get image {
    return _image;
  }
  
  String? get name {
    return _name;
  }
  
  String? get description {
    return _description;
  }
  
  const Channel._internal({required this.id, type, image, name, description}): _type = type, _image = image, _name = name, _description = description;
  
  factory Channel({String? id, String? type, String? image, String? name, String? description}) {
    return Channel._internal(
      id: id == null ? UUID.getUUID() : id,
      type: type,
      image: image,
      name: name,
      description: description);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Channel &&
      id == other.id &&
      _type == other._type &&
      _image == other._image &&
      _name == other._name &&
      _description == other._description;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Channel {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("type=" + "$_type" + ", ");
    buffer.write("image=" + "$_image" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("description=" + "$_description");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Channel copyWith({String? id, String? type, String? image, String? name, String? description}) {
    return Channel._internal(
      id: id ?? this.id,
      type: type ?? this.type,
      image: image ?? this.image,
      name: name ?? this.name,
      description: description ?? this.description);
  }
  
  Channel.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _type = json['type'],
      _image = json['image'],
      _name = json['name'],
      _description = json['description'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'type': _type, 'image': _image, 'name': _name, 'description': _description
  };
  
  Map<String, Object?> toMap() => {
    'id': id, 'type': _type, 'image': _image, 'name': _name, 'description': _description
  };

  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Channel";
    modelSchemaDefinition.pluralName = "Channels";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'id',
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'type',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'image',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'name',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'description',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}