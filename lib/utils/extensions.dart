extension DescribeDate on DateTime {
  String describeTime() {
    final current = DateTime.now();
    final difference = this.difference(current);

    String description = switch (difference) {
      
      Duration(inDays: -1) => "Yesterday",
      Duration(inDays: 0) => "Today",

      Duration(inDays: _) => "${'$day'.padLeft(2, '0')}/${'$month'.padLeft(2, '0')}/$year"
    };

    return description;
  }
}