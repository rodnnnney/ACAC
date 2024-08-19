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

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:amplify_core/amplify_core.dart' as amplify_core;

import 'ModelProvider.dart';

/** This is an auto generated class representing the MarketingCard type in your schema. */
class MarketingCard extends amplify_core.Model {
  static const classType = const _MarketingCardModelType();
  final String id;
  final String? _imageUrl;
  final String? _headerText;
  final String? _descriptionText;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  MarketingCardModelIdentifier get modelIdentifier {
    return MarketingCardModelIdentifier(id: id);
  }

  String get imageUrl {
    try {
      return _imageUrl!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get headerText {
    try {
      return _headerText!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get descriptionText {
    try {
      return _descriptionText!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const MarketingCard._internal(
      {required this.id,
      required imageUrl,
      required headerText,
      required descriptionText,
      createdAt,
      updatedAt})
      : _imageUrl = imageUrl,
        _headerText = headerText,
        _descriptionText = descriptionText,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory MarketingCard(
      {String? id,
      required String imageUrl,
      required String headerText,
      required String descriptionText}) {
    return MarketingCard._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        imageUrl: imageUrl,
        headerText: headerText,
        descriptionText: descriptionText);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MarketingCard &&
        id == other.id &&
        _imageUrl == other._imageUrl &&
        _headerText == other._headerText &&
        _descriptionText == other._descriptionText;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("MarketingCard {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("imageUrl=" + "$_imageUrl" + ", ");
    buffer.write("headerText=" + "$_headerText" + ", ");
    buffer.write("descriptionText=" + "$_descriptionText" + ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt!.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  MarketingCard copyWith(
      {String? imageUrl, String? headerText, String? descriptionText}) {
    return MarketingCard._internal(
        id: id,
        imageUrl: imageUrl ?? this.imageUrl,
        headerText: headerText ?? this.headerText,
        descriptionText: descriptionText ?? this.descriptionText);
  }

  MarketingCard copyWithModelFieldValues(
      {ModelFieldValue<String>? imageUrl,
      ModelFieldValue<String>? headerText,
      ModelFieldValue<String>? descriptionText}) {
    return MarketingCard._internal(
        id: id,
        imageUrl: imageUrl == null ? this.imageUrl : imageUrl.value,
        headerText: headerText == null ? this.headerText : headerText.value,
        descriptionText: descriptionText == null
            ? this.descriptionText
            : descriptionText.value);
  }

  MarketingCard.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _imageUrl = json['imageUrl'],
        _headerText = json['headerText'],
        _descriptionText = json['descriptionText'],
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'imageUrl': _imageUrl,
        'headerText': _headerText,
        'descriptionText': _descriptionText,
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'imageUrl': _imageUrl,
        'headerText': _headerText,
        'descriptionText': _descriptionText,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core.QueryModelIdentifier<MarketingCardModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<MarketingCardModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final IMAGEURL = amplify_core.QueryField(fieldName: "imageUrl");
  static final HEADERTEXT = amplify_core.QueryField(fieldName: "headerText");
  static final DESCRIPTIONTEXT =
      amplify_core.QueryField(fieldName: "descriptionText");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "MarketingCard";
    modelSchemaDefinition.pluralName = "MarketingCards";

    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
          authStrategy: amplify_core.AuthStrategy.PUBLIC,
          operations: const [
            amplify_core.ModelOperation.CREATE,
            amplify_core.ModelOperation.UPDATE,
            amplify_core.ModelOperation.DELETE,
            amplify_core.ModelOperation.READ
          ]),
      amplify_core.AuthRule(
          authStrategy: amplify_core.AuthStrategy.OWNER,
          ownerField: "owner",
          identityClaim: "cognito:username",
          provider: amplify_core.AuthRuleProvider.USERPOOLS,
          operations: const [
            amplify_core.ModelOperation.CREATE,
            amplify_core.ModelOperation.UPDATE,
            amplify_core.ModelOperation.DELETE,
            amplify_core.ModelOperation.READ
          ])
    ];

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: MarketingCard.IMAGEURL,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: MarketingCard.HEADERTEXT,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: MarketingCard.DESCRIPTIONTEXT,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.nonQueryField(
            fieldName: 'createdAt',
            isRequired: false,
            isReadOnly: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.nonQueryField(
            fieldName: 'updatedAt',
            isRequired: false,
            isReadOnly: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.dateTime)));
  });
}

class _MarketingCardModelType extends amplify_core.ModelType<MarketingCard> {
  const _MarketingCardModelType();

  @override
  MarketingCard fromJson(Map<String, dynamic> jsonData) {
    return MarketingCard.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'MarketingCard';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [MarketingCard] in your schema.
 */
class MarketingCardModelIdentifier
    implements amplify_core.ModelIdentifier<MarketingCard> {
  final String id;

  /** Create an instance of MarketingCardModelIdentifier using [id] the primary key. */
  const MarketingCardModelIdentifier({required this.id});

  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{'id': id});

  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
      .entries
      .map((entry) => (<String, dynamic>{entry.key: entry.value}))
      .toList();

  @override
  String serializeAsString() => serializeAsMap().values.join('#');

  @override
  String toString() => 'MarketingCardModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is MarketingCardModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
