#  GÉNÉRER LE TABLEAU COMPARATIF ARIMA 

# 1. Définir les plages pour p et q (ex: de 0 à 4)
p_max <- 4
q_max <- 4
d <- 1 # Fixé selon votre différenciation

# 2. Initialiser une structure pour stocker les résultats
resultats <- data.frame()

# 3. Boucle sur les combinaisons de p et q
for (p_val in 0:p_max) {
  for (q_val in 0:q_max) {
    
    # On utilise tryCatch pour éviter que le code s'arrête si un modèle ne converge pas
    try({
      # Estimation du modèle
      fit <- arima(serie_ts, order = c(p_val, d, q_val), method = "ML")
      
      # Calcul de la p-valeur de Box-Pierce (sur les résidus, lag 10 par défaut)
      bp_test <- Box.test(residuals(fit), lag = 10, type = "Box-Pierce")
      p_valeur_bp <- bp_test$p.value
      
      # Stockage des informations
      ligne <- data.frame(
        Modele = paste0("ARIMA(", p_val, ",", d, ",", q_val, ")"),
        p_valeur_BP = round(p_valeur_bp, 4),
        AIC = round(AIC(fit), 2)
      )
      
      resultats <- rbind(resultats, ligne)
    }, silent = TRUE)
  }
}

# 4. Trier le tableau par AIC (du plus petit au plus grand)
resultats_tries <- resultats[order(resultats$AIC), ]

# 5. Afficher le tableau final
print("Tableau comparatif des modèles (Trié par AIC) :")
print(resultats_tries)

# 6. Optionnel : Sauvegarder en CSV pour l'ouvrir dans Excel
# write.csv(resultats_tries, "comparaison_arima.csv", row.names = FALSE)
# --- SÉLECTION AUTOMATIQUE DU MODÈLE OPTIMAL ---

# 1. On ne garde que les modèles statistiquement valides (p-valeur > 0.05)
modeles_valides <- resultats[resultats$p_valeur_BP > 0.05, ]

# 2. Parmi les valides, on trouve la ligne avec l'AIC le plus bas
if (nrow(modeles_valides) > 0) {
  meilleur_indice <- which.min(modeles_valides$AIC)
  modele_optimal_nom <- modeles_valides$Modele[meilleur_indice]
  aic_optimal <- modeles_valides$AIC[meilleur_indice]
  
  cat("\n----------------------------------------------\n")
  cat("RÉSULTAT DE LA SÉLECTION :\n")
  cat("Le modèle optimal sélectionné est :", modele_optimal_nom, "\n")
  cat("Avec un AIC de :", aic_optimal, "\n")
  cat("----------------------------------------------\n")
  
  # 3. Extraction des paramètres p, d, q pour la suite
  # On extrait les chiffres du nom "ARIMA(p,d,q)"
  params <- as.numeric(gsub("[^0-9]", "", unlist(strsplit(modele_optimal_nom, ","))))
  p_opt <- params[1]
  d_opt <- params[2]
  q_opt <- params[3]
  
  # 4. Ré-estimer le modèle final pour les prévisions
  modele_final <- arima(serie_ts, order = c(p_opt, d_opt, q_opt), method = "ML")
  
} else {
  print("Aucun modèle n'a été validé par le test de Box-Pierce.")
}

# ÉTAPE 6 : ESTIMATION DU MODÈLE OPTIMAL IDENTIFIÉ

# Estimation du modèle optimal trouvé automatiquement

modele_arima <- Arima(
  serie_ts,
  order = c(p_opt, d_opt, q_opt)
)

# Résumé complet du modèle
summary(modele_arima)

cat("\n")
cat("ESTIMATION DU MODÈLE ARIMA\n")

cat("Modèle estimé : ARIMA(",
    p_opt, ",", d_opt, ",", q_opt, ")\n")

# Coefficients estimés
print(modele_arima$coef)

# Critères de qualité
cat("AIC :", AIC(modele_arima), "\n")
cat("BIC :", BIC(modele_arima), "\n")
