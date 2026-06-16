class CustomerResponse {
  final int status;
  final bool success;
  final String message;
  final List<Customer> data;

  CustomerResponse({
    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) {
    return CustomerResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] != null && json['data']['results'] != null)
          ? (json['data']['results'] as List<dynamic>)
                .map((e) => Customer.fromJson(e))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Customer {
  final String id;
  final String name;

  Customer({required this.id, required this.name});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id']?.toString() ?? json['customer_id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['customer_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
