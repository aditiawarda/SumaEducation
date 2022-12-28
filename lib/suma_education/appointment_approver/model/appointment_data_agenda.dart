import 'package:flutter/foundation.dart';

@immutable
class Agenda {
  final String id;

  const Agenda({
    this.id = "id",
  });

  @override
  bool operator ==(Object other) => other is Agenda && id == other.id;

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => id;
}
