
# ÉTAPE 5 : MÉTHODE DE BOX-JENKINS
# Identification automatique des paramètres ARIMA(p,d,q)


# Charger les packages
library(forecast)
library(tseries)


# 1. Différenciation d'ordre 1


serie_diff1 <- diff(serie_ts, differences = 1)


# 2. Visualisation de la série stationnaire


plot(serie_diff1,
     main = "Série différenciée d'ordre 1",
     col = "blue",
     lwd = 2,
     ylab = "Différences")

# 3. ACF : Identification de q


acf_result <- acf(serie_diff1,
                  lag.max = 20,
                  plot = TRUE,
                  main = "Autocorrélogramme (ACF)",
                  col = "darkblue",
                  lwd = 2)


# 4. PACF : Identification de p


pacf_result <- pacf(serie_diff1,
                    lag.max = 20,
                    plot = TRUE,
                    main = "Autocorrélogramme Partiel (PACF)",
                    col = "red",
                    lwd = 2)


# 5. AFFICHAGE COMBINÉ


tsdisplay(serie_diff1,
          main = "Analyse Box-Jenkins")


# 6. IDENTIFICATION AUTOMATIQUE DE p, d, q


# d = ordre de différenciation
d <- 1

# Recherche automatique du meilleur modèle ARIMA
modele_auto <- auto.arima(serie_ts,
                          seasonal = FALSE,
                          stepwise = FALSE,
                          approximation = FALSE)

# Affichage du meilleur modèle
print(modele_auto)


# 7. EXTRACTION DES PARAMÈTRES p,d,q


p <- modele_auto$arma[1]
q <- modele_auto$arma[2]
d <- modele_auto$arma[6]


# 8. AFFICHAGE DES VRAIES VALEURS


cat("\n")

cat("Identification du modèle ARIMA\n")


cat("Valeur de p (AR) :", p, "\n")
cat("Valeur de d (Différenciation) :", d, "\n")
cat("Valeur de q (MA) :", q, "\n")


# 9. INTERPRÉTATION AUTOMATIQUE


if(p > 0){
  cat("La PACF montre une composante autorégressive AR(", p, ").\n")
} else {
  cat("Aucune composante AR importante détectée.\n")
}

if(q > 0){
  cat("L'ACF montre une composante moyenne mobile MA(", q, ").\n")
} else {
  cat("Aucune composante MA importante détectée.\n")
}

cat("La série a nécessité", d,
    "différenciation(s) pour devenir stationnaire.\n")

# 10. MODÈLE FINAL
cat("Modèle retenu : ARIMA(",
    p, ",", d, ",", q, ")\n")

# ÉTAPE 6 : ESTIMATION DU MODÈLE ARIMA

# Estimation du modèle identifié précédemment
# Exemple : ARIMA(p,d,q)

modele_arima <- Arima(serie_ts,
                      order = c(p, d, q))


# ÉTAPE 6 : ESTIMATION DU MODÈLE ARIMA


# Estimation du modèle identifié précédemment
# Exemple : ARIMA(p,d,q)

modele_arima <- Arima(serie_ts,
                      order = c(p, d, q))

# Résumé complet du modèle
summary(modele_arima)


# Affichage des coefficients estimés


cat("\n")

cat("ESTIMATION DU MODÈLE ARIMA\n")


cat("Modèle estimé : ARIMA(",
    p, ",", d, ",", q, ")\n")



print(modele_arima$coef)




# Critères de qualité du modèle


cat("AIC  :", AIC(modele_arima), "\n")
cat("BIC  :", BIC(modele_arima), "\n")


# ÉTAPE 7 : VALIDATION DU MODÈLE


cat("\n")

cat("VALIDATION DU MODÈLE\n")



# 1. Résidus du modèle


residus <- residuals(modele_arima)

# Visualisation des résidus
plot(residus,
     main = "Résidus du modèle ARIMA",
     col = "blue",
     lwd = 2)

abline(h = 0, col = "red")


# 2. Histogramme des résidus


hist(residus,
     breaks = 10,
     main = "Histogramme des résidus",
     col = "lightblue")


# 3. ACF des résidus


acf(residus,
    main = "ACF des résidus")


# 4. Test de Ljung-Box
# H0 : les résidus sont indépendants (bruit blanc)


ljung_test <- Box.test(residus,
                       lag = 10,
                       type = "Ljung-Box")

print(ljung_test)


# 5. Interprétation automatique du test


if(ljung_test$p.value > 0.05){
  
  cat("Les résidus sont indépendants.\n")
  cat("Le modèle ARIMA est valide.\n")
  
} else {
  
  cat("Les résidus restent autocorrélés.\n")
  cat("Le modèle ARIMA n'est pas satisfaisant.\n")
}


# 6. Vérification automatique complète


checkresiduals(modele_arima)


# 7. Comparaison valeurs réelles vs ajustées


valeurs_ajustees <- fitted(modele_arima)

plot(serie_ts,
     col = "black",
     lwd = 2,
     main = "Valeurs réelles vs ajustées",
     ylab = "Taux")

lines(valeurs_ajustees,
      col = "red",
      lwd = 2)

legend("topright",
       legend = c("Réel", "Ajusté"),
       col = c("black", "red"),
       lwd = 2)


# 8. Calcul des erreurs


erreurs <- accuracy(modele_arima)

cat("\n")

cat("MESURES DE PERFORMANCE\n")


print(erreurs)
