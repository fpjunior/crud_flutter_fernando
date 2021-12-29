import 'package:flutter/material.dart';

class ProdutoModel {
  final String id;
  final String name;
  final String description;
  final String urlImage;

  const ProdutoModel({
    this.id,
    @required this.name,
    @required this.description,
    @required this.urlImage,
  });
}
