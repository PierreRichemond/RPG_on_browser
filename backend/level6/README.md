# Level 6

La plateforme Captain Contrat est maintenant une marketplace

Un avocat qui rejoint la plateforme choisit les services qu'il souhaite / peut proposer et le prix pour ce service.
Le client choisit ensuite son niveau de prestation en fonction de l'offre proposée par un des avocats.

Le prix de la commande est égale à la somme du :
- Prix du service initial (Prix Captain Contrat) si le client n'a pas choisi d'avocat dans sa commande
- Prix du service proposé par l'avocat, si cet avocat possède ce service et a configuré un prix dessus

Résultat souhaité
- 1.  Proposer une structure de données pour la base de données `data.json`
- 2.  Ainsi que le code pour calculer le prix de la commande en prenant en compte les problématiques des challenges précédents

Rappel :
- Documents et Produits facturable soit par l’avocat, soit par le client
- Dans les 2 cas un frais de service peut être collecté par Captain Contrat `service_fee`
- Un code promo peut être appliqué sur la commande. Il est applicable sur les Documents et/ou Produits.
- Certains produits ou documents ne peuvent pas recevoir de code promo. Il faut pouvoir spécifier cette information directement sur l’élément
