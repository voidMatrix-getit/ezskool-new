/// Parses delimited data into a list of maps.
///
/// [data] is the input list of maps containing the delimited string.
/// [delimiter] is the character used to separate fields.
/// [keys] is the list of keys to map the separated fields.
library;
//library;
// List<Map<String, String>> parseDelimitedData({
//   required List<Map<String, dynamic>> data,
//   required List<String> keys,
//   String delimiter = '~',
//   String fieldName = 'x',
// }) {
//   return data.map((item) {
//     // Split the delimited string by the provided character
//     List<String> values = item[fieldName]?.split(delimiter) ?? [];
//
//     // Map the split values to the provided keys
//     return Map.fromIterables(
//       keys,
//       List.generate(keys.length, (index) => values.length > index ? values[index] : ''),
//     );
//   }).toList();
// }

List<Map<String, String>> parseDelimitedData({
  required List<Map<String, dynamic>> data,
  required List<String> keys,
  String delimiter = '~',
  String fieldName = 'x',
}) {
  return data.map((item) {
    // Check if the required field exists
    if (!item.containsKey(fieldName) || item[fieldName] == null) {
      throw ArgumentError('Missing or null field: $fieldName in $item');
    }

    // Split the delimited string by the provided character
    List<String> values = item[fieldName].toString().split(delimiter);

    // Ensure the keys align with the values
    if (values.length < keys.length) {
      values = values + List.filled(keys.length - values.length, '');
    }

    // Map the split values to the provided keys
    return Map.fromIterables(
      keys,
      List.generate(keys.length, (index) => values[index]),
    );
  }).toList();
}

List<Map<String, dynamic>> parseJsonToMapList(List<dynamic> jsonList) {
  return jsonList
      .map((item) => Map<String, dynamic>.from(item as Map))
      .toList();
}

List<Map<String, String>> parseTildeSeparatedData(
    List<dynamic> data, List<String> keys) {
  return data.map((entry) {
    List<String> values = entry['x'].split('~');
    return Map.fromIterables(keys, values);
  }).toList();
}
