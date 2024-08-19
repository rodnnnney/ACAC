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
import 'package:collection/collection.dart';

import 'ModelProvider.dart';

/** This is an auto generated class representing the RestaurantInfoCard type in your schema. */
class RestaurantInfoCard extends amplify_core.Model {
  static const classType = const _RestaurantInfoCardModelType();
  final String id;
  final String? _restaurantName;
  final LatLong? _location;
  final String? _address;
  final String? _imageSrc;
  final String? _imageLogo;
  final String? _scannerDataMatch;
  final Time? _hours;
  final double? _rating;
  final List<String>? _cuisineType;
  final int? _reviewNum;
  final List<String>? _discounts;
  final String? _discountPercent;
  final String? _phoneNumber;
  final String? _gMapsLink;
  final String? _websiteLink;
  final List<String>? _topRatedItemsImgSrc;
  final List<String>? _topRatedItemsName;
  final List<String>? _topRatedItemsPrice;
  final int? _timesVisited;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  RestaurantInfoCardModelIdentifier get modelIdentifier {
    return RestaurantInfoCardModelIdentifier(id: id);
  }

  String get restaurantName {
    try {
      return _restaurantName!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  LatLong get location {
    try {
      return _location!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get address {
    try {
      return _address!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get imageSrc {
    try {
      return _imageSrc!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get imageLogo {
    try {
      return _imageLogo!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get scannerDataMatch {
    try {
      return _scannerDataMatch!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  Time get hours {
    try {
      return _hours!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  double get rating {
    try {
      return _rating!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  List<String> get cuisineType {
    try {
      return _cuisineType!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  int get reviewNum {
    try {
      return _reviewNum!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  List<String> get discounts {
    try {
      return _discounts!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get discountPercent {
    try {
      return _discountPercent!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get phoneNumber {
    try {
      return _phoneNumber!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get gMapsLink {
    try {
      return _gMapsLink!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get websiteLink {
    try {
      return _websiteLink!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  List<String> get topRatedItemsImgSrc {
    try {
      return _topRatedItemsImgSrc!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  List<String> get topRatedItemsName {
    try {
      return _topRatedItemsName!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  List<String>? get topRatedItemsPrice {
    return _topRatedItemsPrice;
  }

  int get timesVisited {
    try {
      return _timesVisited!;
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

  const RestaurantInfoCard._internal(
      {required this.id,
      required restaurantName,
      required location,
      required address,
      required imageSrc,
      required imageLogo,
      required scannerDataMatch,
      required hours,
      required rating,
      required cuisineType,
      required reviewNum,
      required discounts,
      required discountPercent,
      required phoneNumber,
      required gMapsLink,
      required websiteLink,
      required topRatedItemsImgSrc,
      required topRatedItemsName,
      topRatedItemsPrice,
      required timesVisited,
      createdAt,
      updatedAt})
      : _restaurantName = restaurantName,
        _location = location,
        _address = address,
        _imageSrc = imageSrc,
        _imageLogo = imageLogo,
        _scannerDataMatch = scannerDataMatch,
        _hours = hours,
        _rating = rating,
        _cuisineType = cuisineType,
        _reviewNum = reviewNum,
        _discounts = discounts,
        _discountPercent = discountPercent,
        _phoneNumber = phoneNumber,
        _gMapsLink = gMapsLink,
        _websiteLink = websiteLink,
        _topRatedItemsImgSrc = topRatedItemsImgSrc,
        _topRatedItemsName = topRatedItemsName,
        _topRatedItemsPrice = topRatedItemsPrice,
        _timesVisited = timesVisited,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory RestaurantInfoCard(
      {String? id,
      required String restaurantName,
      required LatLong location,
      required String address,
      required String imageSrc,
      required String imageLogo,
      required String scannerDataMatch,
      required Time hours,
      required double rating,
      required List<String> cuisineType,
      required int reviewNum,
      required List<String> discounts,
      required String discountPercent,
      required String phoneNumber,
      required String gMapsLink,
      required String websiteLink,
      required List<String> topRatedItemsImgSrc,
      required List<String> topRatedItemsName,
      List<String>? topRatedItemsPrice,
      required int timesVisited}) {
    return RestaurantInfoCard._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        restaurantName: restaurantName,
        location: location,
        address: address,
        imageSrc: imageSrc,
        imageLogo: imageLogo,
        scannerDataMatch: scannerDataMatch,
        hours: hours,
        rating: rating,
        cuisineType: cuisineType != null
            ? List<String>.unmodifiable(cuisineType)
            : cuisineType,
        reviewNum: reviewNum,
        discounts: discounts != null
            ? List<String>.unmodifiable(discounts)
            : discounts,
        discountPercent: discountPercent,
        phoneNumber: phoneNumber,
        gMapsLink: gMapsLink,
        websiteLink: websiteLink,
        topRatedItemsImgSrc: topRatedItemsImgSrc != null
            ? List<String>.unmodifiable(topRatedItemsImgSrc)
            : topRatedItemsImgSrc,
        topRatedItemsName: topRatedItemsName != null
            ? List<String>.unmodifiable(topRatedItemsName)
            : topRatedItemsName,
        topRatedItemsPrice: topRatedItemsPrice != null
            ? List<String>.unmodifiable(topRatedItemsPrice)
            : topRatedItemsPrice,
        timesVisited: timesVisited);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RestaurantInfoCard &&
        id == other.id &&
        _restaurantName == other._restaurantName &&
        _location == other._location &&
        _address == other._address &&
        _imageSrc == other._imageSrc &&
        _imageLogo == other._imageLogo &&
        _scannerDataMatch == other._scannerDataMatch &&
        _hours == other._hours &&
        _rating == other._rating &&
        DeepCollectionEquality().equals(_cuisineType, other._cuisineType) &&
        _reviewNum == other._reviewNum &&
        DeepCollectionEquality().equals(_discounts, other._discounts) &&
        _discountPercent == other._discountPercent &&
        _phoneNumber == other._phoneNumber &&
        _gMapsLink == other._gMapsLink &&
        _websiteLink == other._websiteLink &&
        DeepCollectionEquality()
            .equals(_topRatedItemsImgSrc, other._topRatedItemsImgSrc) &&
        DeepCollectionEquality()
            .equals(_topRatedItemsName, other._topRatedItemsName) &&
        DeepCollectionEquality()
            .equals(_topRatedItemsPrice, other._topRatedItemsPrice) &&
        _timesVisited == other._timesVisited;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("RestaurantInfoCard {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("restaurantName=" + "$_restaurantName" + ", ");
    buffer.write("location=" +
        (_location != null ? _location!.toString() : "null") +
        ", ");
    buffer.write("address=" + "$_address" + ", ");
    buffer.write("imageSrc=" + "$_imageSrc" + ", ");
    buffer.write("imageLogo=" + "$_imageLogo" + ", ");
    buffer.write("scannerDataMatch=" + "$_scannerDataMatch" + ", ");
    buffer.write(
        "hours=" + (_hours != null ? _hours!.toString() : "null") + ", ");
    buffer.write(
        "rating=" + (_rating != null ? _rating!.toString() : "null") + ", ");
    buffer.write("cuisineType=" +
        (_cuisineType != null ? _cuisineType!.toString() : "null") +
        ", ");
    buffer.write("reviewNum=" +
        (_reviewNum != null ? _reviewNum!.toString() : "null") +
        ", ");
    buffer.write("discounts=" +
        (_discounts != null ? _discounts!.toString() : "null") +
        ", ");
    buffer.write("discountPercent=" + "$_discountPercent" + ", ");
    buffer.write("phoneNumber=" + "$_phoneNumber" + ", ");
    buffer.write("gMapsLink=" + "$_gMapsLink" + ", ");
    buffer.write("websiteLink=" + "$_websiteLink" + ", ");
    buffer.write("topRatedItemsImgSrc=" +
        (_topRatedItemsImgSrc != null
            ? _topRatedItemsImgSrc!.toString()
            : "null") +
        ", ");
    buffer.write("topRatedItemsName=" +
        (_topRatedItemsName != null ? _topRatedItemsName!.toString() : "null") +
        ", ");
    buffer.write("topRatedItemsPrice=" +
        (_topRatedItemsPrice != null
            ? _topRatedItemsPrice!.toString()
            : "null") +
        ", ");
    buffer.write("timesVisited=" +
        (_timesVisited != null ? _timesVisited!.toString() : "null") +
        ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt!.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  RestaurantInfoCard copyWith(
      {String? restaurantName,
      LatLong? location,
      String? address,
      String? imageSrc,
      String? imageLogo,
      String? scannerDataMatch,
      Time? hours,
      double? rating,
      List<String>? cuisineType,
      int? reviewNum,
      List<String>? discounts,
      String? discountPercent,
      String? phoneNumber,
      String? gMapsLink,
      String? websiteLink,
      List<String>? topRatedItemsImgSrc,
      List<String>? topRatedItemsName,
      List<String>? topRatedItemsPrice,
      int? timesVisited}) {
    return RestaurantInfoCard._internal(
        id: id,
        restaurantName: restaurantName ?? this.restaurantName,
        location: location ?? this.location,
        address: address ?? this.address,
        imageSrc: imageSrc ?? this.imageSrc,
        imageLogo: imageLogo ?? this.imageLogo,
        scannerDataMatch: scannerDataMatch ?? this.scannerDataMatch,
        hours: hours ?? this.hours,
        rating: rating ?? this.rating,
        cuisineType: cuisineType ?? this.cuisineType,
        reviewNum: reviewNum ?? this.reviewNum,
        discounts: discounts ?? this.discounts,
        discountPercent: discountPercent ?? this.discountPercent,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        gMapsLink: gMapsLink ?? this.gMapsLink,
        websiteLink: websiteLink ?? this.websiteLink,
        topRatedItemsImgSrc: topRatedItemsImgSrc ?? this.topRatedItemsImgSrc,
        topRatedItemsName: topRatedItemsName ?? this.topRatedItemsName,
        topRatedItemsPrice: topRatedItemsPrice ?? this.topRatedItemsPrice,
        timesVisited: timesVisited ?? this.timesVisited);
  }

  RestaurantInfoCard copyWithModelFieldValues(
      {ModelFieldValue<String>? restaurantName,
      ModelFieldValue<LatLong>? location,
      ModelFieldValue<String>? address,
      ModelFieldValue<String>? imageSrc,
      ModelFieldValue<String>? imageLogo,
      ModelFieldValue<String>? scannerDataMatch,
      ModelFieldValue<Time>? hours,
      ModelFieldValue<double>? rating,
      ModelFieldValue<List<String>?>? cuisineType,
      ModelFieldValue<int>? reviewNum,
      ModelFieldValue<List<String>?>? discounts,
      ModelFieldValue<String>? discountPercent,
      ModelFieldValue<String>? phoneNumber,
      ModelFieldValue<String>? gMapsLink,
      ModelFieldValue<String>? websiteLink,
      ModelFieldValue<List<String>?>? topRatedItemsImgSrc,
      ModelFieldValue<List<String>?>? topRatedItemsName,
      ModelFieldValue<List<String>?>? topRatedItemsPrice,
      ModelFieldValue<int>? timesVisited}) {
    return RestaurantInfoCard._internal(
        id: id,
        restaurantName:
            restaurantName == null ? this.restaurantName : restaurantName.value,
        location: location == null ? this.location : location.value,
        address: address == null ? this.address : address.value,
        imageSrc: imageSrc == null ? this.imageSrc : imageSrc.value,
        imageLogo: imageLogo == null ? this.imageLogo : imageLogo.value,
        scannerDataMatch: scannerDataMatch == null
            ? this.scannerDataMatch
            : scannerDataMatch.value,
        hours: hours == null ? this.hours : hours.value,
        rating: rating == null ? this.rating : rating.value,
        cuisineType: cuisineType == null ? this.cuisineType : cuisineType.value,
        reviewNum: reviewNum == null ? this.reviewNum : reviewNum.value,
        discounts: discounts == null ? this.discounts : discounts.value,
        discountPercent: discountPercent == null
            ? this.discountPercent
            : discountPercent.value,
        phoneNumber: phoneNumber == null ? this.phoneNumber : phoneNumber.value,
        gMapsLink: gMapsLink == null ? this.gMapsLink : gMapsLink.value,
        websiteLink: websiteLink == null ? this.websiteLink : websiteLink.value,
        topRatedItemsImgSrc: topRatedItemsImgSrc == null
            ? this.topRatedItemsImgSrc
            : topRatedItemsImgSrc.value,
        topRatedItemsName: topRatedItemsName == null
            ? this.topRatedItemsName
            : topRatedItemsName.value,
        topRatedItemsPrice: topRatedItemsPrice == null
            ? this.topRatedItemsPrice
            : topRatedItemsPrice.value,
        timesVisited:
            timesVisited == null ? this.timesVisited : timesVisited.value);
  }

  RestaurantInfoCard.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _restaurantName = json['restaurantName'],
        _location = json['location'] != null
            ? json['location']['serializedData'] != null
                ? LatLong.fromJson(new Map<String, dynamic>.from(
                    json['location']['serializedData']))
                : LatLong.fromJson(
                    new Map<String, dynamic>.from(json['location']))
            : null,
        _address = json['address'],
        _imageSrc = json['imageSrc'],
        _imageLogo = json['imageLogo'],
        _scannerDataMatch = json['scannerDataMatch'],
        _hours = json['hours'] != null
            ? json['hours']['serializedData'] != null
                ? Time.fromJson(new Map<String, dynamic>.from(
                    json['hours']['serializedData']))
                : Time.fromJson(new Map<String, dynamic>.from(json['hours']))
            : null,
        _rating = (json['rating'] as num?)?.toDouble(),
        _cuisineType = json['cuisineType']?.cast<String>(),
        _reviewNum = (json['reviewNum'] as num?)?.toInt(),
        _discounts = json['discounts']?.cast<String>(),
        _discountPercent = json['discountPercent'],
        _phoneNumber = json['phoneNumber'],
        _gMapsLink = json['gMapsLink'],
        _websiteLink = json['websiteLink'],
        _topRatedItemsImgSrc = json['topRatedItemsImgSrc']?.cast<String>(),
        _topRatedItemsName = json['topRatedItemsName']?.cast<String>(),
        _topRatedItemsPrice = json['topRatedItemsPrice']?.cast<String>(),
        _timesVisited = (json['timesVisited'] as num?)?.toInt(),
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'restaurantName': _restaurantName,
        'location': _location?.toJson(),
        'address': _address,
        'imageSrc': _imageSrc,
        'imageLogo': _imageLogo,
        'scannerDataMatch': _scannerDataMatch,
        'hours': _hours?.toJson(),
        'rating': _rating,
        'cuisineType': _cuisineType,
        'reviewNum': _reviewNum,
        'discounts': _discounts,
        'discountPercent': _discountPercent,
        'phoneNumber': _phoneNumber,
        'gMapsLink': _gMapsLink,
        'websiteLink': _websiteLink,
        'topRatedItemsImgSrc': _topRatedItemsImgSrc,
        'topRatedItemsName': _topRatedItemsName,
        'topRatedItemsPrice': _topRatedItemsPrice,
        'timesVisited': _timesVisited,
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'restaurantName': _restaurantName,
        'location': _location,
        'address': _address,
        'imageSrc': _imageSrc,
        'imageLogo': _imageLogo,
        'scannerDataMatch': _scannerDataMatch,
        'hours': _hours,
        'rating': _rating,
        'cuisineType': _cuisineType,
        'reviewNum': _reviewNum,
        'discounts': _discounts,
        'discountPercent': _discountPercent,
        'phoneNumber': _phoneNumber,
        'gMapsLink': _gMapsLink,
        'websiteLink': _websiteLink,
        'topRatedItemsImgSrc': _topRatedItemsImgSrc,
        'topRatedItemsName': _topRatedItemsName,
        'topRatedItemsPrice': _topRatedItemsPrice,
        'timesVisited': _timesVisited,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core
      .QueryModelIdentifier<RestaurantInfoCardModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<RestaurantInfoCardModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final RESTAURANTNAME =
      amplify_core.QueryField(fieldName: "restaurantName");
  static final LOCATION = amplify_core.QueryField(fieldName: "location");
  static final ADDRESS = amplify_core.QueryField(fieldName: "address");
  static final IMAGESRC = amplify_core.QueryField(fieldName: "imageSrc");
  static final IMAGELOGO = amplify_core.QueryField(fieldName: "imageLogo");
  static final SCANNERDATAMATCH =
      amplify_core.QueryField(fieldName: "scannerDataMatch");
  static final HOURS = amplify_core.QueryField(fieldName: "hours");
  static final RATING = amplify_core.QueryField(fieldName: "rating");
  static final CUISINETYPE = amplify_core.QueryField(fieldName: "cuisineType");
  static final REVIEWNUM = amplify_core.QueryField(fieldName: "reviewNum");
  static final DISCOUNTS = amplify_core.QueryField(fieldName: "discounts");
  static final DISCOUNTPERCENT =
      amplify_core.QueryField(fieldName: "discountPercent");
  static final PHONENUMBER = amplify_core.QueryField(fieldName: "phoneNumber");
  static final GMAPSLINK = amplify_core.QueryField(fieldName: "gMapsLink");
  static final WEBSITELINK = amplify_core.QueryField(fieldName: "websiteLink");
  static final TOPRATEDITEMSIMGSRC =
      amplify_core.QueryField(fieldName: "topRatedItemsImgSrc");
  static final TOPRATEDITEMSNAME =
      amplify_core.QueryField(fieldName: "topRatedItemsName");
  static final TOPRATEDITEMSPRICE =
      amplify_core.QueryField(fieldName: "topRatedItemsPrice");
  static final TIMESVISITED =
      amplify_core.QueryField(fieldName: "timesVisited");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "RestaurantInfoCard";
    modelSchemaDefinition.pluralName = "RestaurantInfoCards";

    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
          authStrategy: amplify_core.AuthStrategy.PUBLIC,
          operations: const [
            amplify_core.ModelOperation.CREATE,
            amplify_core.ModelOperation.UPDATE,
            amplify_core.ModelOperation.DELETE,
            amplify_core.ModelOperation.READ
          ])
    ];

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: RestaurantInfoCard.RESTAURANTNAME,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
        fieldName: 'location',
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.embedded,
            ofCustomTypeName: 'LatLong')));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: RestaurantInfoCard.ADDRESS,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: RestaurantInfoCard.IMAGESRC,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: RestaurantInfoCard.IMAGELOGO,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: RestaurantInfoCard.SCANNERDATAMATCH,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
        fieldName: 'hours',
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.embedded,
            ofCustomTypeName: 'Time')));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: RestaurantInfoCard.RATING,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: RestaurantInfoCard.CUISINETYPE,
        isRequired: true,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.collection,
            ofModelName: amplify_core.ModelFieldTypeEnum.string.name)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: RestaurantInfoCard.REVIEWNUM,
        isRequired: true,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: RestaurantInfoCard.DISCOUNTS,
        isRequired: true,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.collection,
            ofModelName: amplify_core.ModelFieldTypeEnum.string.name)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: RestaurantInfoCard.DISCOUNTPERCENT,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: RestaurantInfoCard.PHONENUMBER,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: RestaurantInfoCard.GMAPSLINK,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: RestaurantInfoCard.WEBSITELINK,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: RestaurantInfoCard.TOPRATEDITEMSIMGSRC,
        isRequired: true,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.collection,
            ofModelName: amplify_core.ModelFieldTypeEnum.string.name)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: RestaurantInfoCard.TOPRATEDITEMSNAME,
        isRequired: true,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.collection,
            ofModelName: amplify_core.ModelFieldTypeEnum.string.name)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: RestaurantInfoCard.TOPRATEDITEMSPRICE,
        isRequired: false,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.collection,
            ofModelName: amplify_core.ModelFieldTypeEnum.string.name)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: RestaurantInfoCard.TIMESVISITED,
        isRequired: true,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)));

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

class _RestaurantInfoCardModelType
    extends amplify_core.ModelType<RestaurantInfoCard> {
  const _RestaurantInfoCardModelType();

  @override
  RestaurantInfoCard fromJson(Map<String, dynamic> jsonData) {
    return RestaurantInfoCard.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'RestaurantInfoCard';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [RestaurantInfoCard] in your schema.
 */
class RestaurantInfoCardModelIdentifier
    implements amplify_core.ModelIdentifier<RestaurantInfoCard> {
  final String id;

  /** Create an instance of RestaurantInfoCardModelIdentifier using [id] the primary key. */
  const RestaurantInfoCardModelIdentifier({required this.id});

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
  String toString() => 'RestaurantInfoCardModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is RestaurantInfoCardModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
