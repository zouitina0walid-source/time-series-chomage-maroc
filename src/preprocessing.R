library(tidyverse)

# 1. Lecture correcte du fichier CSV
raw_data <- read.csv("data/raw/chomage_maroc.csv", 
                     sep = ";", 
                     skip = 1, 
                     header = TRUE, 
                     check.names = FALSE)

# Supprimer les colonnes vides éventuelles
raw_data <- raw_data[, colnames(raw_data) != ""]

# 2. Transformation des données
clean_data <- raw_data[1, ] %>%
  pivot_longer(cols = everything(),
               names_to = "Date",
               values_to = "Taux") %>%
  mutate(Date = gsub("X", "", Date)) %>%
  arrange(desc(row_number()))

# 3. Export
write.csv(clean_data, 
          "data/processed/chomage_clean.csv", 
          row.names = FALSE)

print("Fichier généré avec succès !")
# ---  DIVISION DES DONNÉES ---

# 1. Lecture du jeu de données complet
data_complete <- read.csv("data/processed/chomage_clean.csv")

# 2. Le dataset contient 80 observations (de 2006T1 à 2025T4)
# Ensemble d'entraînement : observations de 1 à 72 (de 2006 à fin 2023)
train_set <- data_complete[1:72, ]

# Ensemble de test : observations de 73 à 80 (années 2024 et 2025)
test_set <- data_complete[73:80, ]

# 3. Enregistrement des sous-ensembles dans des fichiers CSV
write.csv(train_set, "data/processed/chomage_train.csv", row.names = FALSE)
write.csv(test_set, "data/processed/chomage_test.csv", row.names = FALSE)

# Message de confirmation
print("Les ensembles d'entraînement (72 observations) et de test (8 observations) ont été créés avec succès.")