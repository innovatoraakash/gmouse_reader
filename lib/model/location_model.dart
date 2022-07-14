class LocationModel {
  String name;
  String latitude;
  String longitude;
  int radius;

  LocationModel(
      {required this.name,
      required this.latitude,
      required this.longitude,
      required this.radius});
}

List<LocationModel> locationData = [
  LocationModel(
      name: "Tinkune",
      latitude: "27.684896",
      longitude: "85.348125",
      radius: 100),
  LocationModel(
      name: "Aalok nagar",
      latitude: "27.684336",
      longitude: "85.348125",
      radius: 100),
  LocationModel(
      name: "Santinagar",
      latitude: "27.686106",
      longitude: "85.336782",
      radius: 100),
  LocationModel(
      name: "buddhanagar",
      latitude: "27.687398",
      longitude: "85.330563",
      radius: 100),
  LocationModel(
      name: "sankhamul",
      latitude: "27.684974",
      longitude: "85.332981",
      radius: 100),
  LocationModel(
      name: "Thapagaun",
      latitude: "27.691394",
      longitude: "85.332310",
      radius: 10),
  LocationModel(
      name: "Baneswor",
      latitude: "27.688394",
      longitude: "85.335487",
      radius: 100),
  LocationModel(
      name: "maitighar",
      latitude: "27.694552",
      longitude: "85.320440",
      radius: 100),
  LocationModel(
      name: "babarmahal",
      latitude: "27.691664",
      longitude: "85.324420",
      radius: 100),
  LocationModel(
      name: "anamnagar",
      latitude: "27.693873",
      longitude: "85.327763",
      radius: 100),
];
