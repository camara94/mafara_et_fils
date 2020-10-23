import 'package:mafara_et_fils/model/coordonneesSuplementaire.dart';
class Apropos {
	final String adresse;
	final String contact;
	final CoordonneesSuplementaire coordonneesSuplementaire;
	final DateTime dateCreation;
	final String description;
	final String horaire;
	final String image;
	final String produits;
	Apropos(
		{
			this.adresse,
			this.contact, 
			this.coordonneesSuplementaire, 
			this.dateCreation, 
			this.description,
			this.horaire,
			this.image,
			this.produits
		}
	      );

}
