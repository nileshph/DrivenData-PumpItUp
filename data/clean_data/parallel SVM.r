
library(parallelSVM)
library(doParallel)

train <- read.csv("C:/Users/nileshpharate/Documents/GitHub/ML-Project/data/clean_data/training.csv",na.strings=c("", "NA"))
test  <- read.csv("C:/Users/nileshpharate/Documents/GitHub/ML-Project/data/normalized/testing.csv",na.strings=c("", "NA"))

x<-train[complete.cases(train),];
str(x)
train[!complete.cases(train),]

train <- na.omit(train)

train <- train[!apply(is.na(train) | train == " ", 1, all),]

cores<-detectCores()
#Create cluster with desired number of cores, leave one open for the machine         
#core processes
cl <- makeCluster(cores[1]-1)
#Register cluster
registerDoParallel(cl)

x1<- subset(train, select = -status_group)
y<- train$status_group

apply(x1, MARGIN = 2, FUN = function(x) sum(is.na(x)))

x <- x1;
parallel_svm <- parallelSVM(x, y , 
                            numberCores = detectCores() - 1, 
                            samplingSize = 0.2, scale = TRUE, type = NULL, 
                            kernel = "radial", degree = 3, 
                            gamma = if (is.vector(x)) 1 else 1/ncol(x), 
                            coef0 = 0, cost = 1, nu = 0.5, class.weights = NULL, 
                            cachesize = 40, tolerance = 0.001, epsilon = 0.1, 
                            shrinking = TRUE, cross = 0, probability = FALSE, 
                            fitted = TRUE,
                            na.action = na.omit)

