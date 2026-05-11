/// Model representing a single commissioning assignment.
class CommissioningModel {
  final int id;
  final String companyName;
  final String location;
  final String members;

  const CommissioningModel({
    required this.id,
    required this.companyName,
    required this.location,
    required this.members,
  });

  factory CommissioningModel.fromJson(Map<String, dynamic> json) {
    return CommissioningModel(
      id: json['id'] as int,
      companyName: json['company_name'] as String,
      location: json['location'] as String,
      members: json['members'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'company_name': companyName,
        'location': location,
        'members': members,
      };

  // ── Static dummy data — 10 records ───────────────────────────────────────
  static const List<CommissioningModel> dummyList = [
    CommissioningModel(
      id: 1,
      companyName: 'Global Infotech',
      location: 'Main Server Room',
      members: 'Vinod Patil, Prashant Shinde',
    ),
    CommissioningModel(
      id: 2,
      companyName: 'Reliance Mart',
      location: 'Chiller Plant',
      members: 'Rahul Deshmukh',
    ),
    CommissioningModel(
      id: 3,
      companyName: 'Sharma Pumps Ltd.',
      location: 'Pump House B2',
      members: 'Amit Joshi, Suresh Kadam',
    ),
    CommissioningModel(
      id: 4,
      companyName: 'Tata Motors Plant',
      location: 'Assembly Line 4',
      members: 'Rajesh More',
    ),
    CommissioningModel(
      id: 5,
      companyName: 'Star Hospital',
      location: 'HVAC Mechanical Room',
      members: 'Priya Nair, Deepak Rao',
    ),
    CommissioningModel(
      id: 6,
      companyName: 'Mahindra Logistics',
      location: 'Warehouse Zone C',
      members: 'Sanjay Patil',
    ),
    CommissioningModel(
      id: 7,
      companyName: 'Infosys Campus',
      location: 'Data Centre Floor 3',
      members: 'Nikhil Kulkarni, Anand Shah',
    ),
    CommissioningModel(
      id: 8,
      companyName: 'Bajaj Auto Works',
      location: 'Compressor Room',
      members: 'Vishal Thakur',
    ),
    CommissioningModel(
      id: 9,
      companyName: 'Pune Municipal Corp.',
      location: 'Water Treatment Unit',
      members: 'Rohit Gavhane, Tejas Mane',
    ),
    CommissioningModel(
      id: 10,
      companyName: 'Cipla Pharmaceuticals',
      location: 'Clean Room Block A',
      members: 'Sneha Jadhav, Pratik Sawant',
    ),
  ];
}
