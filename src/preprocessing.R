# =============================================================================
# PROJET : Analyse et Prévision du Chômage au Maroc — Méthode Box-Jenkins
# SCRIPT  : 01_preprocessing.R — Phase 1 : Nettoyage, Pivotement, Division
# SOURCE  : HCP — Taux de chômage des diplômés de niveau supérieur (Total)
# PÉRIODE : 2006 T1 → 2025 T4  (80 observations trimestrielles)
# =============================================================================


# -----------------------------------------------------------------------------
# 0. PACKAGES
# -----------------------------------------------------------------------------

packages <- c("tidyverse", "lubridate", "zoo")

invisible(lapply(packages, function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) install.packages(pkg)
}))

library(tidyverse)    # dplyr, tidyr, readr, ggplot2
library(lubridate)    # manipulation des dates
library(zoo)          # format yearqtr pour séries trimestrielles


# -----------------------------------------------------------------------------
# 1. IMPORTATION DU FICHIER BRUT
# -----------------------------------------------------------------------------

# Le fichier HCP est structuré ainsi :
#   Ligne 1 : "Périodes" | NA | 2025T4 | 2025T3 | ... | 2006T1  (ordre décroissant)
#   Ligne 2 : "Type diplôme" | "Sexe" | NA | NA | ...            (métadonnées)
#   Ligne 3 : "Ayant un diplôme: Niveau supérieur" | "Total" | 25.7 | 25.7 | ...

chemin_brut <- "../data/raw/chomage_maroc.csv"

data_brute <- read_delim(
  file           = chemin_brut,
  delim          = ";",
  col_names      = FALSE,
  show_col_types = FALSE
)

cat("=== Fichier brut chargé :", nrow(data_brute), "lignes x",
    ncol(data_brute), "colonnes ===\n\n")


# -----------------------------------------------------------------------------
# 2. EXTRACTION ET PIVOTEMENT (Wide → Long)
# -----------------------------------------------------------------------------

# Récupération des périodes (ligne 1, colonnes 3 à fin)
periodes <- data_brute[1, 3:ncol(data_brute)] %>%
  unlist() %>% as.character() %>% na.omit() %>% as.vector()

# Récupération des valeurs (ligne 3, colonnes 3 à fin)
valeurs <- data_brute[3, 3:ncol(data_brute)] %>%
  unlist() %>% as.character() %>% as.vector()

# Alignement : garder uniquement les positions avec une période valide
n_periodes <- length(periodes)
valeurs    <- valeurs[seq_len(n_periodes)]

# Construction du dataframe long
data_long <- tibble(
  periode      = periodes,
  taux_chomage = as.numeric(valeurs)
) %>%
  filter(!is.na(periode), !is.na(taux_chomage))

cat("=== Pivotement terminé :", nrow(data_long), "observations ===\n")


# -----------------------------------------------------------------------------
# 3. DÉCOMPOSITION DE LA PÉRIODE ET TRI CHRONOLOGIQUE
# -----------------------------------------------------------------------------

data_clean <- data_long %>%
  mutate(
    # Extraction de l'année et du trimestre depuis le code "ANNEETx"
    annee     = as.integer(str_sub(periode, 1, 4)),
    trimestre = as.integer(str_sub(periode, -1)),
    
    # Format yearqtr (zoo) — idéal pour les séries temporelles trimestrielles
    date = as.yearqtr(paste0(annee, " Q", trimestre), format = "%Y Q%q"),
    
    # Date de début de trimestre (pour ggplot et ts())
    date_debut = as.Date(date)
  ) %>%
  # Tri chronologique CROISSANT (obligatoire pour Box-Jenkins)
  arrange(annee, trimestre) %>%
  select(date, date_debut, annee, trimestre, periode, taux_chomage)

cat("Période couverte  :", as.character(min(data_clean$date)),
    "→", as.character(max(data_clean$date)), "\n")
cat("Observations totales :", nrow(data_clean), "\n\n")


# -----------------------------------------------------------------------------
# 4. CONTRÔLE QUALITÉ
# -----------------------------------------------------------------------------

# Vérification des valeurs manquantes
n_na <- sum(is.na(data_clean$taux_chomage))
if (n_na > 0) {
  warning(paste("ATTENTION :", n_na, "valeur(s) manquante(s) détectée(s) !"))
} else {
  cat("✔ Aucune valeur manquante.\n")
}

# Vérification de la continuité trimestrielle (pas de trous)
n_attendu <- (max(data_clean$annee) - min(data_clean$annee)) * 4 + max(data_clean$trimestre)
if (nrow(data_clean) == n_attendu) {
  cat("✔ Série continue, aucun trimestre manquant.\n\n")
} else {
  warning(paste("ATTENTION : attendu", n_attendu, "trimestres, trouvé", nrow(data_clean)))
}

cat("=== Statistiques descriptives ===\n")
cat("Min   :", min(data_clean$taux_chomage), "%\n")
cat("Moy   :", round(mean(data_clean$taux_chomage), 2), "%\n")
cat("Max   :", max(data_clean$taux_chomage), "%\n\n")


# -----------------------------------------------------------------------------
# 5. DIVISION TRAIN / TEST  (80 % / 20 %)
# -----------------------------------------------------------------------------

# Calcul des tailles
n       <- nrow(data_clean)
n_train <- round(n * 0.8)   # 64 observations
n_test  <- n - n_train      # 16 observations

# Découpage chronologique strict
# → Train : 2006 T1 — 2021 T4  (64 trimestres)
# → Test  : 2022 T1 — 2025 T4  (16 trimestres)

data_train <- data_clean[1:n_train, ]
data_test  <- data_clean[(n_train + 1):n, ]

cat("=== Division Train / Test ===\n")
cat(sprintf("Train : %d obs. | %s → %s\n",
            nrow(data_train),
            as.character(min(data_train$date)),
            as.character(max(data_train$date))))
cat(sprintf("Test  : %d obs. | %s → %s\n",
            nrow(data_test),
            as.character(min(data_test$date)),
            as.character(max(data_test$date))))
cat(sprintf("Ratio : %.0f%% train / %.0f%% test\n\n",
            100 * n_train / n, 100 * n_test / n))


# -----------------------------------------------------------------------------
# 6. EXPORT DES FICHIERS TRAITÉS
# -----------------------------------------------------------------------------

# Création du dossier s'il n'existe pas
dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)

# Fichier complet nettoyé
write_excel_csv(data_clean, "data/processed/chomage_clean.csv")

# Fichier d'entraînement
write_excel_csv(data_train, "data/processed/chomage_train.csv")

# Fichier de test / validation
write_excel_csv(data_test,  "data/processed/chomage_test.csv")

cat("=== Fichiers exportés dans data/processed/ ===\n")
cat("  ✔ chomage_clean.csv  (", nrow(data_clean), "obs.)\n")
cat("  ✔ chomage_train.csv  (", nrow(data_train), "obs.)\n")
cat("  ✔ chomage_test.csv   (", nrow(data_test),  "obs.)\n\n")

cat("=== Phase 1 terminée avec succès ===\n")


# =============================================================================
# FIN DU SCRIPT 01_preprocessing.R
# =============================================================================