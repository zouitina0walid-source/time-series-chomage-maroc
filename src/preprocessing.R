library(tidyverse)

# 1. Read raw
raw_data <- read.csv2("../data/raw/chomage_maroc.csv", header = FALSE, fileEncoding = "latin1")

# 2. Extract (Dates f row 2, Taux f row 3)
# Smiyat dyal l-trimestres khasshom y-kono character nqi
dates_raw <- as.character(raw_data[2, ])
taux_raw <- as.character(raw_data[3, ])

# 3. Build Clean Data
# Khassna n-bdaw mn l-column 3 (hit 1 u 2 fihom "Périodes" u "Sexe")
clean_data <- data.frame(
  Date = dates_raw[3:length(dates_raw)],
  Taux = as.numeric(taux_raw[3:length(taux_raw)])
) %>%
  filter(!is.na(Taux)) %>%
  # Inverser l'ordre (2006 -> 2025) bach l-graphe y-koun s-hih
  arrange(desc(row_number()))

# 4. Split 80/20
n <- nrow(clean_data)
train_idx <- round(0.8 * n)
data_train <- clean_data[1:train_idx, ]
data_test <- clean_data[(train_idx + 1):n, ]

# 5. Export
write.csv(clean_data, "../data/processed/chomage_clean.csv", row.names = FALSE)
write.csv(data_train, "../data/processed/chomage_train.csv", row.names = FALSE)
write.csv(data_test, "../data/processed/chomage_test.csv", row.names = FALSE)

print("Check ")
print(head(data_train))
