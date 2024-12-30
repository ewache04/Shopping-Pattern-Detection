# Step 1: Load required libraries
# List of required packages
required_packages <- c("arules", "arulesViz", "RColorBrewer")

# Function to check if a package is installed
is_package_installed <- function(package_name) {
  return(package_name %in% installed.packages())
}

# Function to load library if installed, otherwise prompt user to install
load_library <- function(package_name) {
  if (!is_package_installed(package_name)) {
    install.packages(package_name)
    library(package_name, character.only = TRUE)
    message("Package '", package_name, "' has been installed and loaded successfully.")
  } else {
    library(package_name, character.only = TRUE)
    message("Package '", package_name, "' has been loaded successfully.")
  }
}

# Check and load required libraries
for (package in required_packages) {
  load_library(package)
}

# Step 2: Load the Groceries dataset
# Define the dataset name variable
dataset_name <- "Groceries"

if (!exists(dataset_name)) {
  data(Groceries)  # Load the Groceries dataset
  message("Dataset 'Groceries' has been loaded.")
} else {
  message("Dataset '", dataset_name, "' already exists.")
}

# Step 3: Apply the Apriori algorithm
rules <- apriori(Groceries, parameter = list(supp = 0.01, conf = 0.2))

# Check if rules were generated
if (length(rules) > 0) {
  print("Apriori algorithm applied successfully. Rules generated.")

  # Step 4: Inspect the first 10 rules
  inspect_results <- inspect(head(rules, n = 10))
  print("First 10 rules inspected:")
  print(inspect_results)
} else {
  print("Apriori algorithm applied, but no rules were generated.")
}

# Step 5: Generate an item frequency plot
tryCatch({
  itemFrequencyPlot(Groceries, topN = 20, col = brewer.pal(8, "Pastel2"), main = "Top 20 Items by Frequency")
  print("Item frequency plot generated successfully.")
}, error = function(e) {
  print("Error generating item frequency plot:")
  print(e)
})

# Step 6: Create a box plot of lift values for rules
tryCatch({
  lift_values <- quality(rules)$lift
  boxplot(lift_values, main = "Box Plot of Lift Values", ylab = "Lift", xlab = "Rules")

  # Save the box plot
  dev.copy(png, "boxplot_lift.png")
  dev.off()
  print("Box plot saved as 'boxplot_lift.png'.")
}, error = function(e) {
  print("Error creating box plot:")
  print(e)
})

# Step 7: Analysis and conclusion
cat("\nAnalysis and Conclusion:\n")
cat("1. The 'Groceries' dataset contains", length(Groceries), "transactions.\n")
cat("2. Generated", length(rules), "association rules.\n")
cat("3. Frequent items and associations indicate complementary product pairings, useful for product placement and promotions.\n")
cat("4. Recommendations:\n")
cat("   - Group complementary products together in stores.\n")
cat("   - Offer discounts on products frequently bought together.\n")
cat("   - Use the insights to optimize marketing strategies.\n")
