1) X_train/test contains the readings
2) Y_train/test contains the activeID of activity being done while reading was taken
3) Sunject contains the subject ID from which the reading was taken
4) These 3 were combined using data.frame and columns names were assigned using the features set
5) This was done for both training and test data sets before combing them using rbind
6) Then from the features the ones measuring either mean or standard deviation were subsetted and this subsetted data was used to create final tidy data set
