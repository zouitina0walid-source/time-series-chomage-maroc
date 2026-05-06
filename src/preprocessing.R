library(tidyverse)

# 1. Read raw
raw_data <- read.csv2("../data/raw/chomage_maroc.csv", header = FALSE, fileEncoding = "latin1", stringsAsFactors = FALSE)

# 2. Trouver la ligne qui contient les dates (contient "2025T4")
idx_dates <- which(apply(raw_data, 1, function(x) any(grepl("2025T4", x))))
# 3. Trouver la ligne qui contient "Total"
idx_values <- which(apply(raw_data, 1, function(x) any(grepl("Total", x))))

# Log pour debug (Goliya chno t-la3 lik f console)
print(paste("Dates trouvées à la ligne:", idx_dates))
print(paste("Valeurs trouvées à la ligne:", idx_values))

# 4. Extraire proprement
row_dates <- as.character(raw_data[idx_dates, ])
row_values <- as.character(raw_data[idx_values, ])

# 5. Build
clean_data <- data.frame(
  Date = row_dates[3:length(row_dates)],
  Taux = row_values[3:length(row_values)]
) %>%
  mutate(Taux = as.numeric(as.character(Taux)),
         Date = trimws(Date)) %>%
  filter(!is.na(Taux), Date != "") %>%
  arrange(desc(row_number()))

# Export
write.csv(clean_data, "../data/processed/chomage_clean.csv", row.names = FALSE)
write.csv(clean_data[1:round(0.8*nrow(clean_data)), ], "../data/processed/chomage_train.csv", row.names = FALSE)
write.csv(clean_data[(round(0.8*nrow(clean_data))+1):nrow(clean_data), ], "../data/processed/chomage_test.csv", row.names = FALSE)

print("Check final f console:")
print(head(clean_data))