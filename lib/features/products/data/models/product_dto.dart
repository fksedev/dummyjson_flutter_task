import '../../domain/entities/product.dart';

class ProductReviewDto {
  const ProductReviewDto({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
  });

  final int rating;
  final String comment;
  final String date;
  final String reviewerName;

  factory ProductReviewDto.fromJson(Map<String, dynamic> json) {
    return ProductReviewDto(
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comment: json['comment'] as String? ?? '',
      date: json['date'] as String? ?? '',
      reviewerName: json['reviewerName'] as String? ?? 'Anonymous',
    );
  }

  ProductReview toEntity() {
    return ProductReview(
      rating: rating,
      comment: comment,
      date: date,
      reviewerName: reviewerName,
    );
  }
}

class ProductDimensionsDto {
  const ProductDimensionsDto({
    required this.width,
    required this.height,
    required this.depth,
  });

  final double width;
  final double height;
  final double depth;

  factory ProductDimensionsDto.fromJson(Map<String, dynamic> json) {
    return ProductDimensionsDto(
      width: (json['width'] as num?)?.toDouble() ?? 0,
      height: (json['height'] as num?)?.toDouble() ?? 0,
      depth: (json['depth'] as num?)?.toDouble() ?? 0,
    );
  }

  ProductDimensions toEntity() {
    return ProductDimensions(width: width, height: height, depth: depth);
  }
}

class ProductDto {
  const ProductDto({
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
  final List<ProductReviewDto> reviews;
  final String? brand;
  final String? sku;
  final double? weight;
  final ProductDimensionsDto? dimensions;
  final String? availabilityStatus;
  final String? warrantyInformation;
  final String? shippingInformation;
  final String? returnPolicy;
  final int? minimumOrderQuantity;
  final String? barcode;

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    final images = (json['images'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList();
    final tags = (json['tags'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList();
    final reviews = (json['reviews'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(ProductReviewDto.fromJson)
        .toList();

    final dimensionsJson = json['dimensions'];
    final metaJson = json['meta'];

    return ProductDto(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      thumbnail: json['thumbnail'] as String? ?? '',
      images: images,
      tags: tags,
      reviews: reviews,
      brand: json['brand'] as String?,
      sku: json['sku'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      dimensions: dimensionsJson is Map<String, dynamic>
          ? ProductDimensionsDto.fromJson(dimensionsJson)
          : null,
      availabilityStatus: json['availabilityStatus'] as String?,
      warrantyInformation: json['warrantyInformation'] as String?,
      shippingInformation: json['shippingInformation'] as String?,
      returnPolicy: json['returnPolicy'] as String?,
      minimumOrderQuantity: (json['minimumOrderQuantity'] as num?)?.toInt(),
      barcode: metaJson is Map<String, dynamic>
          ? metaJson['barcode'] as String?
          : null,
    );
  }

  Product toEntity() {
    return Product(
      id: id,
      title: title,
      description: description,
      category: category,
      price: price,
      discountPercentage: discountPercentage,
      rating: rating,
      stock: stock,
      thumbnail: thumbnail,
      images: images,
      tags: tags,
      reviews: reviews.map((e) => e.toEntity()).toList(),
      brand: brand,
      sku: sku,
      weight: weight,
      dimensions: dimensions?.toEntity(),
      availabilityStatus: availabilityStatus,
      warrantyInformation: warrantyInformation,
      shippingInformation: shippingInformation,
      returnPolicy: returnPolicy,
      minimumOrderQuantity: minimumOrderQuantity,
      barcode: barcode,
    );
  }
}

class ProductPageDto {
  const ProductPageDto({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  final List<ProductDto> products;
  final int total;
  final int skip;
  final int limit;

  factory ProductPageDto.fromJson(Map<String, dynamic> json) {
    final products = (json['products'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(ProductDto.fromJson)
        .toList();

    return ProductPageDto(
      products: products,
      total: (json['total'] as num?)?.toInt() ?? products.length,
      skip: (json['skip'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? products.length,
    );
  }

  ProductPage toEntity() {
    return ProductPage(
      products: products.map((e) => e.toEntity()).toList(),
      total: total,
      skip: skip,
      limit: limit,
    );
  }
}
