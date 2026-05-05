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