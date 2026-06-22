abstract class CheckoutEvent {
  const CheckoutEvent();
}

class PlaceOrderEvent extends CheckoutEvent {
  final List<Map<String, dynamic>> items;
  final double total;
  final String address;
  const PlaceOrderEvent({required this.items, required this.total, required this.address});
}
