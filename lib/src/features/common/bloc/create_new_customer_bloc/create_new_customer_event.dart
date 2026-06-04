import 'package:equatable/equatable.dart';
import 'package:service_app/src/features/common/domain/usecase/create_new_customer_usecase.dart';

abstract class CreateNewCustomerEvent extends Equatable {
  const CreateNewCustomerEvent();

  @override
  List<Object?> get props => [];
}

class CreateNewCustomerSubmitEvent extends CreateNewCustomerEvent {
  final CreateNewCustomerParams params;

  const CreateNewCustomerSubmitEvent(this.params);

  @override
  List<Object?> get props => [params];
}
