# ==========================================================
# ÉTAPE 8 : PRÉVISION (FORECASTING)
# ==========================================================

# 1. Charger les bibliothèques nécessaires
library(forecast)

# ----------------------------------------------------------
# IMPORTANT : supprimer l'ancien modèle en mémoire
# ----------------------------------------------------------

rm(modele_arima)

# ----------------------------------------------------------
# Ré-estimation FORCÉE du modèle optimal
# ----------------------------------------------------------

modele_arima <- Arima(
  serie_ts,
  order = c(p_opt, d_opt, q_opt)
)

# Vérification du modèle utilisé
cat("\n")
cat("-----------------------------------\n")
cat("MODÈLE UTILISÉ POUR LES PRÉVISIONS :\n")
cat("ARIMA(", p_opt, ",", d_opt, ",", q_opt, ")\n")
cat("-----------------------------------\n")

# Résumé du modèle
summary(modele_arima)

# ----------------------------------------------------------
# 2. Prévisions sur 8 trimestres
# ----------------------------------------------------------

h_period <- 8

previsions <- forecast(
  modele_arima,
  h = h_period
)

# ----------------------------------------------------------
# 3. Affichage des prévisions numériques
# ----------------------------------------------------------

cat("\n--- PRÉVISIONS DU TAUX DE CHÔMAGE (2026-2027) ---\n")

print(previsions)

# ----------------------------------------------------------
# 4. Charger les données TEST
# ----------------------------------------------------------

test_data <- read.csv("src/chomage_test.csv")

# Vérifier les colonnes
print(names(test_data))

# Transformation en série temporelle
test_ts <- ts(
  test_data$Taux,
  frequency = 4,
  start = c(2022,1)
)

# ----------------------------------------------------------
# 5. VISUALISATION DES PRÉVISIONS
# ----------------------------------------------------------

# Création dossier plots
if(!dir.exists("plots")) {
  dir.create("plots")
}

# Sauvegarde PNG
png(
  "plots/prevision_finale_chomage.png",
  width = 1000,
  height = 600
)

# Graphe prévisions
plot(
  previsions,
  main = paste0(
    "Prévision du Taux de Chômage - ARIMA(",
    p_opt, ",", d_opt, ",", q_opt, ")"
  ),
  ylab = "Taux (%)",
  xlab = "Temps (Trimestres)",
  col = "blue",
  lwd = 2
)

# Série TEST réelle
lines(
  test_ts,
  col = "red",
  lwd = 2,
  type = "b"
)

# Série TRAIN
lines(
  serie_ts,
  col = "black",
  lwd = 2
)

# Légende
legend(
  "topleft",
  legend = c(
    "Train",
    "Prévisions ARIMA",
    "Valeurs Réelles TEST"
  ),
  col = c("black", "blue", "red"),
  lty = 1,
  lwd = 2,
  bty = "n"
)

# Fermer PNG
dev.off()

# ----------------------------------------------------------
# 6. AFFICHAGE DANS RSTUDIO
# ----------------------------------------------------------

plot(
  previsions,
  main = paste0(
    "Prévision du Taux de Chômage - ARIMA(",
    p_opt, ",", d_opt, ",", q_opt, ")"
  ),
  ylab = "Taux (%)",
  xlab = "Temps (Trimestres)",
  col = "blue",
  lwd = 2
)

lines(
  test_ts,
  col = "red",
  lwd = 2,
  type = "b"
)

lines(
  serie_ts,
  col = "black",
  lwd = 2
)

legend(
  "topleft",
  legend = c(
    "Train",
    "Prévisions ARIMA",
    "Valeurs Réelles TEST"
  ),
  col = c("black", "blue", "red"),
  lty = 1,
  lwd = 2,
  bty = "n"
)

# ----------------------------------------------------------
# 7. PERFORMANCE DU MODÈLE
# ----------------------------------------------------------

cat("\n--- PERFORMANCE DU MODÈLE SUR LE TEST ---\n")

performance <- accuracy(
  previsions,
  test_ts
)

print(performance)
