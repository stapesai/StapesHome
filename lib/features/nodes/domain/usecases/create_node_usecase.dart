import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/nodes/data/models/complete_node_pairing_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/request_node_pairing_api_param.dart';
import 'package:stapes_home/features/nodes/domain/repository/node_repository.dart';
import 'package:stapes_home/service_locator.dart';

class RequestNodePairingUseCase implements UseCase<RequestNodePairingParams, RequestNodePairingResponse> {
  @override
  Future<Either<Failure, RequestNodePairingResponse>> call(RequestNodePairingParams params) async {
    return serviceLocator<NodeRepository>().requestNodePairing(params);
  }
}

class CompleteNodePairingUseCase implements UseCase<CompleteNodePairingParams, CompleteNodePairingResponse> {
  @override
  Future<Either<Failure, CompleteNodePairingResponse>> call(CompleteNodePairingParams params) async {
    return serviceLocator<NodeRepository>().completeNodePairing(params);
  }
}
