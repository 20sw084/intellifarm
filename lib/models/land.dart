import 'farmer.dart';
import 'crops/crop.dart';

class Land {
  String? surveyNo;
  String? area;
  List<Farmer>? farmers;
  List<Crop>? crops;

  Land({required this.surveyNo, required this.area, this.farmers, this.crops,});
  // TODO: some search functionality
}
