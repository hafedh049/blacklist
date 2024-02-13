import 'package:flutter/material.dart';

@immutable
final class ProductModel {
  final String productName;
  final String productDate;
  final String productReference;
  final String productCategory;
  final double productOldPrice;
  final double productNewPrice;
  final int productQuantity;
  final int productStockAlert;

  const ProductModel({
    required this.productName,
    required this.productDate,
    required this.productReference,
    required this.productCategory,
    required this.productOldPrice,
    required this.productNewPrice,
    required this.productQuantity,
    required this.productStockAlert,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productName: json['productName'] as String,
      productDate: json['productDate'] as String,
      productReference: json['productReference'] as String,
      productCategory: json['productCategory'] as String,
      productOldPrice: double.parse((json['productOldPrice'] as String)),
      productNewPrice: double.parse(json['productNewPrice'] as String),
      productQuantity: int.parse(json['productQuantity'] as String),
      productStockAlert: int.parse(json['productStockAlert'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'productDate': productDate,
      'productReference': productReference,
      'productCategory': productCategory,
      'productOldPrice': productOldPrice,
      'productNewPrice': productNewPrice,
      'productQuantity': productQuantity,
      'productStockAlert': productStockAlert,
    };
  }
}
