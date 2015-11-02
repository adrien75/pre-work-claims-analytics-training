# This script trains a Random Forest model,
# saves a sample submission, and plots the relative importance
# of the variables.

#load libraries
library(ggplot2)
library(randomForest)

#import data
train <- read.csv("../data/train.csv", stringsAsFactors=FALSE)
test  <- read.csv("../data/test.csv",  stringsAsFactors=FALSE)

#features creation
createFeatures <- function(data) {
  features <- c("Pclass",
                "Age",
                "Sex",
                "Parch",
                "SibSp",
                "Fare",
                "Embarked")
  fea <- data[,features]
  #Random Forest doesn't handle missing values.
  fea$Age[is.na(fea$Age)] <- -1  
  fea$Fare[is.na(fea$Fare)] <- median(fea$Fare, na.rm=TRUE)
  fea$Embarked[fea$Embarked==""] = "S"
  fea$Sex      <- as.factor(fea$Sex)
  fea$Embarked <- as.factor(fea$Embarked)
  return(fea)
}

rf <- randomForest(createFeatures(train), as.factor(train$Survived), ntree=100, importance=TRUE)

submission <- data.frame(PassengerId = test$PassengerId)
submission$Survived <- predict(rf, extractFeatures(test))
write.csv(submission, file = "random_forest_r_submission.csv", row.names=FALSE)

imp <- importance(rf, type=1)
featureImportance <- data.frame(Feature=row.names(imp), Importance=imp[,1])

p <- ggplot(featureImportance, aes(x=reorder(Feature, Importance), y=Importance)) +
     geom_bar(stat="identity", fill="#53cfff") +
     coord_flip() + 
     theme_light(base_size=20) +
     xlab("") +
     ylab("Importance") + 
     ggtitle("Random Forest Feature Importance\n") +
     theme(plot.title=element_text(size=18))

ggsave("feature_importance.png", p)
