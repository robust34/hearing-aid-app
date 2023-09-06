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


/** This is an auto generated class representing the Hospital type in your schema. */
@immutable
class Hospital extends Model {
  static const classType = const _HospitalModelType();
  final String id;
  final String? _name;
  final String? _address;
  final String? _homePageUrl;
  final String? _logo;
  final String? _introductionImage;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  HospitalModelIdentifier get modelIdentifier {
      return HospitalModelIdentifier(
        id: id
      );
  }
  
  String? get name {
    return _name;
  }
  
  String? get address {
    return _address;
  }
  
  String? get homePageUrl {
    return _homePageUrl;
  }
  
  String? get logo {
    return _logo;
  }
  
  String? get introductionImage {
    return _introductionImage;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Hospital._internal({required this.id, name, address, homePageUrl, logo, introductionImage, createdAt, updatedAt}): _name = name, _address = address, _homePageUrl = homePageUrl, _logo = logo, _introductionImage = introductionImage, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Hospital({String? id, String? name, String? address, String? homePageUrl, String? logo, String? introductionImage}) {
    return Hospital._internal(
      id: id == null ? UUID.getUUID() : id,
      name: name,
      address: address,
      homePageUrl: homePageUrl,
      logo: logo,
      introductionImage: introductionImage);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Hospital &&
      id == other.id &&
      _name == other._name &&
      _address == other._address &&
      _homePageUrl == other._homePageUrl &&
      _logo == other._logo &&
      _introductionImage == other._introductionImage;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Hospital {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("address=" + "$_address" + ", ");
    buffer.write("homePageUrl=" + "$_homePageUrl" + ", ");
    buffer.write("logo=" + "$_logo" + ", ");
    buffer.write("introductionImage=" + "$_introductionImage" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Hospital copyWith({String? name, String? address, String? homePageUrl, String? logo, String? introductionImage}) {
    return Hospital._internal(
      id: id,
      name: name ?? this.name,
      address: address ?? this.address,
      homePageUrl: homePageUrl ?? this.homePageUrl,
      logo: logo ?? this.logo,
      introductionImage: introductionImage ?? this.introductionImage);
  }
  
  Hospital.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _address = json['address'],
      _homePageUrl = json['homePageUrl'],
      _logo = json['logo'],
      _introductionImage = json['introductionImage'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'address': _address, 'homePageUrl': _homePageUrl, 'logo': _logo, 'introductionImage': _introductionImage, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id, 'name': _name, 'address': _address, 'homePageUrl': _homePageUrl, 'logo': _logo, 'introductionImage': _introductionImage, 'createdAt': _createdAt, 'updatedAt': _updatedAt
  };

  static final QueryModelIdentifier<HospitalModelIdentifier> MODEL_IDENTIFIER = QueryModelIdentifier<HospitalModelIdentifier>();
  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField NAME = QueryField(fieldName: "name");
  static final QueryField ADDRESS = QueryField(fieldName: "address");
  static final QueryField HOMEPAGEURL = QueryField(fieldName: "homePageUrl");
  static final QueryField LOGO = QueryField(fieldName: "logo");
  static final QueryField INTRODUCTIONIMAGE = QueryField(fieldName: "introductionImage");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Hospital";
    modelSchemaDefinition.pluralName = "Hospitals";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
          ModelOperation.READ
        ]),
      AuthRule(
        authStrategy: AuthStrategy.PRIVATE,
        provider: AuthRuleProvider.IAM,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.READ,
          ModelOperation.UPDATE
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Hospital.NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Hospital.ADDRESS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Hospital.HOMEPAGEURL,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Hospital.LOGO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Hospital.INTRODUCTIONIMAGE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _HospitalModelType extends ModelType<Hospital> {
  const _HospitalModelType();
  
  @override
  Hospital fromJson(Map<String, dynamic> jsonData) {
    return Hospital.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Hospital';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Hospital] in your schema.
 */
@immutable
class HospitalModelIdentifier implements ModelIdentifier<Hospital> {
  final String id;

  /** Create an instance of HospitalModelIdentifier using [id] the primary key. */
  const HospitalModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'HospitalModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is HospitalModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}