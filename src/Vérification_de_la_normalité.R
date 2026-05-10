# ==========================================================
# ÉTAPE 9 : VÉRIFICATION DE LA NORMALITÉ DES RÉSIDUS
# ==========================================================

cat("\n")
cat("VÉRIFICATION DE LA NORMALITÉ DES RÉSIDUS\n")

# ----------------------------------------------------------
# 1. Extraction des résidus
# ----------------------------------------------------------

residus <- residuals(modele_arima)

# ----------------------------------------------------------
# 2. Test de normalité de Shapiro-Wilk
# H0 : les résidus suivent une loi normale
# ----------------------------------------------------------

shapiro_test <- shapiro.test(residus)

cat("\n--- TEST DE SHAPIRO-WILK ---\n")

print(shapiro_test)

# ----------------------------------------------------------
# 3. Interprétation automatique
# ----------------------------------------------------------

cat("\n--- INTERPRÉTATION ---\n")

if(shapiro_test$p.value > 0.05){
  
  cat("Les résidus suivent une distribution normale.\n")
  cat("Hypothèse de normalité acceptée.\n")
  
} else {
  
  cat("Les résidus ne suivent pas une distribution normale.\n")
  cat("Hypothèse de normalité rejetée.\n")
}

# ----------------------------------------------------------
# 4. Création du dossier plots si nécessaire
# ----------------------------------------------------------

if(!dir.exists("plots")){
  dir.create("plots")
}

# ----------------------------------------------------------
# 5. Sauvegarde du QQ-Plot
# ----------------------------------------------------------

png("plots/qqplot_residus_arima.png",
    width = 800,
    height = 600)

# QQ-Plot
qqnorm(residus,
       main = paste0(
         "QQ-Plot des Résidus - ARIMA(",
         p_opt, ",", d_opt, ",", q_opt, ")"
       ),
       col = "blue",
       pch = 19)

# Ligne théorique normale
qqline(residus,
       col = "red",
       lwd = 2)

dev.off()

# ----------------------------------------------------------
# 6. Affichage du QQ-Plot dans RStudio
# ----------------------------------------------------------

qqnorm(residus,
       main = paste0(
         "QQ-Plot des Résidus - ARIMA(",
         p_opt, ",", d_opt, ",", q_opt, ")"
       ),
       col = "blue",
       pch = 19)

qqline(residus,
       col = "red",
       lwd = 2)

# ----------------------------------------------------------
# 7. Histogramme des résidus avec courbe normale
# ----------------------------------------------------------

hist(residus,
     probability = TRUE,
     breaks = 10,
     col = "lightblue",
     main = "Histogramme des Résidus",
     xlab = "Résidus")

# Ajouter la courbe normale
curve(dnorm(x,
            mean = mean(residus),
            sd = sd(residus)),
      col = "red",
      lwd = 2,
      add = TRUE)

