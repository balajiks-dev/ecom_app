class TypeConverter {
  static T? parse<T extends Object>(dynamic value, {bool nullable = true}) {
    dynamic returnValue;
    switch (T) {
      case String:
        returnValue = (value != null ? value.toString() : (nullable ? null : ''));
        break;
      case int:
        returnValue = (int.tryParse(value.toString()) ?? (nullable ? null : 0));
        break;
      case double:
        returnValue = (double.tryParse(value.toString()) ?? (nullable ? null : 0.0));
        break;
      case bool:
        returnValue = (tryParseBool(value.toString()) ?? (nullable ? null : false));
        break;
      default:
        returnValue = null;
    }
    return returnValue;
  }

  static bool? tryParseBool(String? value) {
    if (value == null) {
      return null;
    }

    if (value.toLowerCase() == 'true' || value.toLowerCase() == '1') {
      return true;
    } else if (value.toLowerCase() == 'false' || value.toLowerCase() == '0') {
      return false;
    } else {
      return null;
    }
  }
}
