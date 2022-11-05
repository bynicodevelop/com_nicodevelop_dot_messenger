extension StringCasingExtension on String {
  String toTitleCase() => replaceAll(RegExp(" +"), " ")
      .split(" ")
      .map((str) => str.substring(0, 1).toUpperCase() + str.substring(1))
      .join(" ");
}
