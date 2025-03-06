// lib/models/registration_form.dart
class RegistrationForm {
  String? institutionName;
  String? address;
  String? city;
  String? postalCode;
  String? contactPerson;
  String? contactNumber;
  String? emailAddress;
  String? institutionType;

  Map<String, String?> validate() {
    final errors = <String, String?>{};
    errors['institutionName'] = institutionName == null || institutionName!.isEmpty
        ? 'Institution name is required'
        : institutionName!.length < 3
        ? 'Institution name must be at least 3 characters'
        : null;
    errors['city'] = city == null || city!.isEmpty
        ? 'City is required'
        : city!.length < 3
        ? 'City must be at least 3 characters'
        : null;
    errors['contactPerson'] = contactPerson == null || contactPerson!.isEmpty
        ? 'Contact person is required'
        : contactPerson!.length < 3
        ? 'Contact person name must be at least 3 characters'
        : null;
    errors['contactNumber'] = contactNumber == null || contactNumber!.isEmpty
        ? 'Contact number is required'
        : contactNumber!.length != 10
        ? 'Contact number must be 10 digits'
        : null;
    errors['emailAddress'] = emailAddress != null &&
        emailAddress!.isNotEmpty &&
        !RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(emailAddress!)
        ? 'Please enter a valid email'
        : null;
    errors['postalCode'] = postalCode != null &&
        postalCode!.isNotEmpty &&
        postalCode!.length != 6
        ? 'Postal code must be 6 digits'
        : null;
    errors['institutionType'] = institutionType == null ? 'Please select an institution type' : null;

    return errors;
  }
}
