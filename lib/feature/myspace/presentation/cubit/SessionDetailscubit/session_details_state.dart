import 'package:equatable/equatable.dart';

import '../../../domain/entities/ConsultationEntity.dart';


/// Session details states
abstract class SessionDetailsState extends Equatable {
  const SessionDetailsState();

  @override
  List<Object?> get props => [];
}

class SessionDetailsInitial extends SessionDetailsState {}

class SessionDetailsLoading extends SessionDetailsState {}

class SessionDetailsLoaded extends SessionDetailsState {
  final SessionDetailsEntity session;

  const SessionDetailsLoaded(this.session);

  @override
  List<Object?> get props => [session];
}

class SessionDetailsError extends SessionDetailsState {
  final String message;

  const SessionDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
