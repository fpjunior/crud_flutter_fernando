import 'package:flutter/material.dart';

class ProdutoModel {
  final String id;
  final String name;
  final String description;
  final String urlImage;
  final String urlImage2;

  const ProdutoModel({
    this.id,
    @required this.name,
    @required this.description,
    @required this.urlImage,
    @required this.urlImage2,
  });
}
