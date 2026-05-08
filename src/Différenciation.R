# ----------------------------------------------------------------------------
# ÉTAPE 4 : STATIONNARITÉ DE LA SÉRIE
# Différenciation d'ordre 1 + Tests ADF et KPSS
# ----------------------------------------------------------------------------

# 1. Installer les packages si nécessaire
install.packages("tseries")
install.packages("forecast")

# 2. Charger les bibliothèques
library(tseries)
library(forecast)

# ----------------------------------------------------------------------------
# 3. Transformer les données en série temporelle
# ----------------------------------------------------------------------------

serie_ts <- ts(train_data$Taux,
               start = c(2006,1),
               frequency = 4)

# ----------------------------------------------------------------------------
# 4. Différenciation d'ordre 1
# Xt' = Xt - Xt-1
# ----------------------------------------------------------------------------

serie_diff1 <- diff(serie_ts, differences = 1)

# Visualisation de la série différenciée
plot(serie_diff1,
     main = "Série différenciée d'ordre 1",
     ylab = "Différence",
     xlab = "Temps",
     col = "blue",
     lwd = 2)

# ----------------------------------------------------------------------------
# 5. Autocorrélogramme après différenciation
# ----------------------------------------------------------------------------

acf(serie_diff1,
    main = "ACF après différenciation d'ordre 1")

pacf(serie_diff1,
     main = "PACF après différenciation d'ordre 1")

# ----------------------------------------------------------------------------
# 6. TEST DE DICKEY-FULLER AUGMENTÉ (ADF)
# H0 : la série est non stationnaire
# H1 : la série est stationnaire
# ----------------------------------------------------------------------------

adf_result <- adf.test(serie_diff1)

print("Résultat du test ADF :")
print(adf_result)

# ----------------------------------------------------------------------------
# 7. TEST KPSS
# H0 : la série est stationnaire
# H1 : la série est non stationnaire
# ----------------------------------------------------------------------------

kpss_result <- kpss.test(serie_diff1)

print("Résultat du test KPSS :")
print(kpss_result)

# ----------------------------------------------------------------------------
# 8. Interprétation automatique
# ----------------------------------------------------------------------------

# ADF
if(adf_result$p.value < 0.05){
  print("ADF : La série est stationnaire.")
} else {
  print("ADF : La série reste non stationnaire.")
}

# KPSS
if(kpss_result$p.value < 0.05){
  print("KPSS : La série est non stationnaire.")
} else {
  print("KPSS : La série est stationnaire.")
}