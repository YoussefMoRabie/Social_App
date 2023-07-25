import 'package:fpdart/fpdart.dart';
import 'package:social_app/core/core.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
