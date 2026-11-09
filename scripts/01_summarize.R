# read in the cars data and save to a variable
data <- read.csv("data/raw/mtcars.csv")

# calculate the mean mpg for cars
mean <- mean(data$mpg)
write.csv(mean,"output/mean_mpg.csv")
