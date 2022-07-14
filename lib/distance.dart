import 'dart:math';

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.0174532925199;
  var dlat = lat1 - lat2;
  var dlong = lon1 - lon2;
  var a =
      pow(sin(dlat*p / 2), 2) + cos(lat1*p) * cos(lat2*p) * pow(sin(dlong*p / 2), 2);
  
  return 12742 * asin(sqrt(a));
}
