String formatNumber(int number) {
  return number.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+$)'),
    (Match match) => '${match[1]}.',
  );
}
