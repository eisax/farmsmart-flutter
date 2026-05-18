//typedef Transformer<A,B> = B Function(A);

abstract class ObjectTransformer<A, B> {
  B transform({
    required A from,
  });
}
