# PHASE 3 : ÉTUDE DE LA STATIONNARITÉ 


# 1. Chargement des packages (si ce n'est pas déjà fait)
library(tseries)
library(forecast)
library(gridExtra) # Pour combiner les graphes si besoin

# 2. Création de la série temporelle
# On utilise la colonne taux_chomage identifiée précédemment
train_ts <- ts(train_data$taux_chomage, frequency = 4, start = c(2006, 1))

# 3. Visualisation de la série originale

plot(train_ts, 
     main="Série Temporelle : Taux de Chômage au Maroc", 
     ylab="Taux (%)", 
     xlab="Années", 
     col="blue", 
     lwd=2)

# 4. Analyse de l'Autocorrélogramme (ACF et PACF)
# On définit une zone de 1 ligne et 2 colonnes pour les graphes
par(mfrow=c(1,2))

# ACF : Utile pour voir la stationnarité et la saisonnalité
Acf(train_ts, main="ACF - Série Originale", lag.max = 20)

# PACF : Utile pour identifier l'ordre de la partie AR (p)
Pacf(train_ts, main="PACF - Série Originale", lag.max = 20)

# On remet l'affichage à la normale
par(mfrow=c(1,1))

# 5. Test de Dickey-Fuller Augmenté (ADF)

print("--------------------------------------------------")
print("RÉSULTATS DU TEST ADF (STATIONNARITÉ)")
print("--------------------------------------------------")
adf_result <- adf.test(train_ts)
print(adf_result)

# 6. Conclusion automatique
if(adf_result$p.value > 0.05) {
  cat("\nCONCLUSION : La p-value (", adf_result$p.value, ") est > 0.05.\n")
  cat("La série est NON STATIONNAIRE. Il faut appliquer une différenciation.\n")
} else {
  cat("\nCONCLUSION : La p-value est < 0.05. La série est STATIONNAIRE.\n")
  
  
  
  
  
  # Créer les dossiers nécessaires s'ils n'existent pas
  if(!dir.exists("plots")) dir.create("plots")
  if(!dir.exists("results")) dir.create("results")
  
  # Sauvegarde du rapport ADF
  writeLines(capture.output(adf_result), "results/stationarity_test_report.txt")
  
  # Sauvegarde du plot ACF/PACF
  png("plots/acf_pacf_original.png", width = 1000, height = 500)
  par(mfrow=c(1,2))
  Acf(train_ts, main="ACF Série Originale")
  Pacf(train_ts, main="PACF Série Originale")
  dev.off()
