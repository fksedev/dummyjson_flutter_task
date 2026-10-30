import 'package:equatable/equatable.dart';

class ProductReview extends Equatable {
  const ProductReview({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
  });

  final int rating;
  final String comment;
  final String date;
  final String reviewerName;

  @override
  List<Object?> get props => [rating, comment, date, reviewerName];
}

class ProductDimensions extends Equatable {
  const ProductDimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  final double width;
  final double height;
  final double depth;

  String get label =>
      '${width.toStringAsFixed(1)} × ${height.toStringAsFixed(1)} × ${depth.toStringAsFixed(1)}';

  @override
  List<Object?> get props => [width, height, depth];
}

class Product extends Equatable {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.thumbnail,
    required this.images,
    required this.tags,
    required this.reviews,
    this.brand,
    this.sku,
    this.weight,
    this.dimensions,
    this.availabilityStatus,
    this.warrantyInformation,
    this.shippingInformation,
    this.returnPolicy,
    this.minimumOrderQuantity,
    this.barcode,
  });

  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String thumbnail;
  final List<String> images;
  final List<String> tags;
  final List<ProductReview> reviews;
  final String? brand;
  final String? sku;
  final double? weight;
  final ProductDimensions? dimensions;
  final String? availabilityStatus;
  final String? warrantyInformation;
  final String? shippingInformation;
  final String? returnPolicy;
  final int? minimumOrderQuantity;
  final String? barcode;

  double get discountedPrice =>
      price * (1 - (discountPercentage.clamp(0, 100) / 100));

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    category,
    price,
    discountPercentage,
    rating,
    stock,
    thumbnail,
    images,
    tags,
    reviews,
    brand,
    sku,
    weight,
    dimensions,
    availabilityStatus,
    warrantyInformation,
    shippingInformation,
    returnPolicy,
    minimumOrderQuantity,
    barcode,
  ];
}

class ProductPage extends Equatable {
  const ProductPage({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  bool get hasMore => skip + products.length < total;

  @override
  List<Object?> get props => [products, total, skip, limit];
}
