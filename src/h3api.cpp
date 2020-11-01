#include <Rcpp.h>
#include <h3/h3api.h>

using namespace Rcpp;

double normalize(double degrees) {
  return degsToRads(degrees);
}


//' Return the raw 64 bit inter H3 index from a latitude, longitude and resolution
//' @param lat latitude in degrees
//' @param lon longitude in degrees
//' @param resolution resolution, higher is more granular
// [[Rcpp::export]]
uint64_t coord_to_h3_int(double lat, double lon, int res) {
  GeoCoord input;
  input.lat = normalize(lat);
  input.lon = normalize(lon);
  H3Index index = H3_EXPORT(geoToH3)(&input, res);
  if (index == 0) {
    stop("Error finding index. Check that your resolution is between 1-15.");
  }
  return index;
}

//' Convert an H3 index string to 64 bit integer
//'
//' h3_string_to_int takes an h3 index represented as a hexadecimal string and returns the integer format.
//'
//' @param index h3 index as a hex representation character vector. See \code{\link{getIndexFromCoords}}
// [[Rcpp::export]]
uint64_t h3_string_to_int(String index) {
  uint64_t input = stringToH3(index.get_cstring());
  return input;
}

//' h3_int_to_string takes an h3 integer representation and returns the string format.
//' @param index as an integer representation.
// [[Rcpp::export]]
String h3_int_to_string(uint64_t index) {
  char buf [32];
  h3ToString(index, buf, 32);
  return buf;
}
