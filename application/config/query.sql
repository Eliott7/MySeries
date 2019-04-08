

### check_user
# Obtient les informations de connection d un utilisateur,
# à partir de son email.
#
# Utilisation
#   permet de tester si un utilisateur existe
#   permet d authentifier un utilisateur existant
#   permet de récupérer la dernière date de connection
#
# Paramètre
#   :email
#
# Retourne les champs suivants :
#   id
#   password
#   lastVisit

SELECT id,password,lastVisit FROM user
  WHERE email = :email;

### register_user
# Ajoute un utilisateur dans la base de données. Il faut configurer
# le mail, le password et la dernière date de connection (lastVisit)
# check_user a déjà été utilisé pour vérifier qu il n y pas d utilisateur avec
# le même email dans la base
#
# Paramètres
#   :email
#   :password
#

INSERT INTO user(email,password,lastVisit)
  VALUES (:email,:password,CURDATE());


### get_all_series
# Obtient les images de toutes les séries.
# On triera les séries par age décroissant, et on retourne toutes les données
#
# Utilisation
#   Les séries retournées sont affichées sur la page d accueil
#
# Paramètre
#   :limit
#

SELECT * FROM serie
ORDER BY premiere DESC
LIMIT :limit;

### get_serie
# Obtient toutes les informations sur une série
#
#
# Paramètre
#    :id

SELECT * FROM serie
WHERE id=:id;

### get_cast
# Obtient les paires rôles/acteurs pour une série donnée
#
# Paramètre
#    :id

SELECT personnage.urlImage AS p_image,personnage.nom AS p_nom,
       personne.id AS a_id, personne.nom AS a_nom FROM jouer
JOIN personnage ON jouer.idPersonnage = personnage.id
JOIN personne ON jouer.idPersonne = personne.id
WHERE idSerie=:id;

### get_season_list
# Obtient la liste des saisons pour une série donnée
#
# Paramètre
#    :id

SELECT saison, MAX(numero) AS nb, MIN(premiere) AS debut, MAX(premiere) AS fin
FROM episode
WHERE idSerie=:id
GROUP BY saison
ORDER BY saison;

### get_episode_list
# Obtient la liste des episodes pour une série donnée
#
# Paramètre
#    :id

SELECT * FROM episode
WHERE idSerie=:id AND saison=:saison
ORDER BY saison,numero;

### get_crew_list
# Obtient la liste des membres de l équipe de tournage
#
# Paramètre
#    :id

SELECT * FROM poste
JOIN personne ON personne.id = poste.idPersonne
WHERE idSerie=:id;

### get_person
# Obtient les infos d une personne
#
# Paramètre
#    :id

SELECT * FROM personne
WHERE id=:id;


### get_actor_role
# Obtient les personnage joués ainsi que les séries correspondantes
#
# Paramètre
#    :id

SELECT serie.id AS s_id, serie.nom AS s_nom, serie.urlImage AS s_image,
      personnage.nom AS p_nom, personnage.urlImage AS p_image FROM jouer
JOIN personnage ON jouer.idPersonnage=personnage.id
JOIN serie ON jouer.idSerie = serie.id
WHERE idPersonne=:id;

### get_crew_role
# Obtient la liste des postes occuppés dans les équipes des Séries
#
# Paramètre
#    :id

SELECT serie.id AS s_id, serie.nom AS s_nom, serie.urlImage AS s_image,
       titre FROM poste
JOIN serie ON poste.idSerie = serie.id
WHERE idPersonne=:id;
