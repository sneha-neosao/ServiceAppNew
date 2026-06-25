import 'package:equatable/equatable.dart';

abstract class AmcReportsHistoryEvent extends Equatable {
  const AmcReportsHistoryEvent();

  @override
  List<Object> get props => [];
}

class GetAmcReportsHistoryEvent extends AmcReportsHistoryEvent {
  final String? customerName;
  final String? siteName;
  final String? dateFrom;
  final String? dateTo;

  const GetAmcReportsHistoryEvent({
    this.customerName,
    this.siteName,
    this.dateFrom,
    this.dateTo,
  });

  @override
  List<Object> get props => [
    if (customerName != null) customerName!,
    if (siteName != null) siteName!,
    if (dateFrom != null) dateFrom!,
    if (dateTo != null) dateTo!,
  ];
}
