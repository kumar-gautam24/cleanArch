// import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {

  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class CacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}