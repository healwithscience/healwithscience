
extension StringExtension on String {
    String capitalizes() {
      return "${this[0].toUpperCase()}${this.substring(1)}";
    }
}


extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}