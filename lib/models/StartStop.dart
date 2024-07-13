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

/** This is an auto generated class representing the StartStop type in your schema. */
class StartStop {
  final String? _start;
  final String? _stop;

  String get start {
    try {
      return _start!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get stop {
    try {
      return _stop!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  const StartStop._internal({required start, required stop})
      : _start = start,
        _stop = stop;

  factory StartStop({required String start, required String stop}) {
    return StartStop._internal(start: start, stop: stop);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StartStop && _start == other._start && _stop == other._stop;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("StartStop {");
    buffer.write("start=" + "$_start" + ", ");
    buffer.write("stop=" + "$_stop");
    buffer.write("}");

    return buffer.toString();
  }

  StartStop copyWith({String? start, String? stop}) {
    return StartStop._internal(
        start: start ?? this.start, stop: stop ?? this.stop);
  }

  StartStop copyWithModelFieldValues(
      {ModelFieldValue<String>? start, ModelFieldValue<String>? stop}) {
    return StartStop._internal(
        start: start == null ? this.start : start.value,
        stop: stop == null ? this.stop : stop.value);
  }

  StartStop.fromJson(Map<String, dynamic> json)
      : _start = json['start'],
        _stop = json['stop'];

  Map<String, dynamic> toJson() => {'start': _start, 'stop': _stop};

  Map<String, Object?> toMap() => {'start': _start, 'stop': _stop};

  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "StartStop";
    modelSchemaDefinition.pluralName = "StartStops";

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'start',
            isRequired: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'stop',
            isRequired: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.string)));
  });
}
