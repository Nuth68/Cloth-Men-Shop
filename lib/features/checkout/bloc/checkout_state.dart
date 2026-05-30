abstract class CheckoutState {
  const CheckoutState();
}

class CheckoutInitial extends CheckoutState {
  const CheckoutInitial();
}

class CheckoutLoading extends CheckoutState {
  const CheckoutLoading();
}

class CheckoutSuccess extends CheckoutState {
  const CheckoutSuccess();
}

class CheckoutFailure extends CheckoutState {
  final String message;
  const CheckoutFailure(this.message);
}
