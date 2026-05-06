# ----------------------------------------------------------------------------
# ÉTAPE 2 : VISUALISATION DES DONNÉES (TRAIN)
# ----------------------------------------------------------------------------

# 1. Charger les packages
library(ggplot2)

# 2. Charger les données d'apprentissage (Train)
# RStudio khass ikoun dakhul f l-projet (.Rproj)
train_data <- read.csv("data/processed/chomage_train.csv")

# 3. Préparer l'axe du temps (Dates trimestrielles)
# On crée une séquence chronologique pour que l'affichage soit propre
train_data$Date_Format <- seq(as.Date("2006-03-01"), by="quarter", length.out=nrow(train_data))

# 4. Tracer le graphique de la série temporelle
p <- ggplot(train_data, aes(x = Date_Format, y = Taux)) +
  geom_line(color = "#2c3e50", size = 1) +     # Ligne de la série
  geom_point(color = "#e74c3c", size = 1.5) +   # Points pour chaque trimestre
  scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
  labs(
    title = "Évolution du Taux de Chômage au Maroc (Diplômés Supérieurs)",
    subtitle = "Période d'apprentissage : 2006 - 2021 | Source : HCP",
    x = "Années",
    y = "Taux de Chômage (%)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 12),
    axis.title = element_text(face = "bold")
  )

# 5. Afficher le plot
print(p)

# 6. Sauvegarder automatiquement le plot dans un dossier 'plots'
if(!dir.exists("plots")) dir.create("plots")
ggsave("plots/chomage_train_plot.png", plot = p, width = 10, height = 6)
