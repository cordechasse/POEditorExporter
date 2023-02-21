//
// Created by Nicolas Bush on 17/11/2021.
// Copyright (c) 2021 Nicolas Bush. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
	
  // La méthode GET demande une représentation de la ressource spécifiée. Les requêtes GET doivent uniquement être utilisées afin de récupérer des données.
  case get = "GET"
  
  // La méthode HEAD demande une réponse identique à une requête GET pour laquelle on aura omis le corps de la réponse (on a uniquement l'en-tête).
  case head = "HEAD"
  
  // La méthode POST est utilisée pour envoyer une entité vers la ressource indiquée. Cela  entraîne généralement un changement d'état ou des effets de bord sur le serveur.
  case post = "POST"
  
  // La méthode PUT remplace toutes les représentations actuelles de la ressource visée par le contenu de la requête.
  case put = "PUT"
  
  // La méthode DELETE supprime la ressource indiquée.
  case delete = "DELETE"
  
  // La méthode CONNECT établit un tunnel vers le serveur identifié par la ressource cible.
  case connect = "CONNECT"
  
  // La méthode OPTIONS est utilisée pour décrire les options de communications avec la ressource visée.
  case options = "OPTIONS"
  
  // La méthode TRACE réalise un message de test aller/retour en suivant le chemin de la ressource visée.
  case trace = "TRACE"
  
  //La méthode PATCH est utilisée pour appliquer des modifications partielles à une ressource.
  case patch = "PATCH"
}
