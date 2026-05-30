abstract class CheckoutEvent {
  const CheckoutEvent();
}

class PlaceOrderEvent extends CheckoutEvent {
  final String address;
  const PlaceOrderEvent(this.address);
}
