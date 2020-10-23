class Produit{
  final String id;
  final String description;
  final String designation;
  final String disponible;
  final String nom;
  final String prix;
  final String quantite;
  final String image;

  Produit({this.id, this.description, this.designation, this.disponible, this.nom, this.prix, this.quantite, this.image});
  Produit.fromJson(Map<String, dynamic> json)
    : id = json["results"]["id"],
      description = json["results"]["description"],
      designation = json["results"]["designation"],
      disponible = json["results"]["disponible"],
      nom = json["results"]["nom"],
      prix = json["results"]["prix"],
      quantite = json["results"]["quantite"],
      image = json["results"]["quantite"];
}