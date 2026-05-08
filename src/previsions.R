
# ÉTAPE 8 : PRÉVISION (FORECASTING)

# 1. Charger les bibliothèques nécessaires
library(forecast)


# 2. Prévisions sur 8 trimestres


h_period <- 8

previsions <- forecast(modele_arima,
                       h = h_period)


# 3. Affichage des prévisions numériques


cat("\n--- PRÉVISIONS DU TAUX DE CHÔMAGE (2026-2027) ---\n")

print(previsions)

# 4. Charger les données TEST

test_data <- read.csv("src/chomage_test.csv")

# Vérifier le nom exact de la colonne
print(names(test_data))

# Transformer en série temporelle
test_ts <- ts(test_data$Taux,
              frequency = 4,
              start = c(2022,1))


# 5. VISUALISATION DES PRÉVISIONS

# Création dossier plots
if(!dir.exists("plots")) dir.create("plots")

# Sauvegarde PNG
png("plots/prevision_finale_chomage.png",
    width = 1000,
    height = 600)

# Affichage des prévisions
plot(previsions,
     main = "Prévision du Taux de Chômage au Maroc (ARIMA)",
     ylab = "Taux (%)",
     xlab = "Temps (Trimestres)",
     col = "blue",
     lwd = 2)

# Ajouter les valeurs réelles TEST
lines(test_ts,
      col = "red",
      lwd = 2,
      type = "b")

# Ajouter la série originale train
lines(serie_ts,
      col = "black",
      lwd = 2)

# Légende
legend("topleft",
       legend = c("Train", "Prévisions ARIMA", "Valeurs Réelles TEST"),
       col = c("black", "blue", "red"),
       lty = 1,
       lwd = 2,
       bty = "n")

# Fermer le fichier PNG
dev.off()

# 6. AFFICHER DIRECTEMENT LA FIGURE DANS RStudio

plot(previsions,
     main = "Prévision du Taux de Chômage au Maroc (ARIMA)",
     ylab = "Taux (%)",
     xlab = "Temps (Trimestres)",
     col = "blue",
     lwd = 2)

lines(test_ts,
      col = "red",
      lwd = 2,
      type = "b")

lines(serie_ts,
      col = "black",
      lwd = 2)

legend("topleft",
       legend = c("Train", "Prévisions ARIMA", "Valeurs Réelles TEST"),
       col = c("black", "blue", "red"),
       lty = 1,
       lwd = 2,
       bty = "n")

# 7. PERFORMANCE DU MODÈLE

cat("\n--- PERFORMANCE DU MODÈLE SUR LE TEST ---\n")

performance <- accuracy(previsions, test_ts)

print(performance)