#install.packages("scidesignR")
library(scidesignR)
# See available datasets
data(package = "scidesignR")

################################ PART 1 #######################################

View(fertdat)
??ferdat
summary(fertdat)
# RQ: Does Fertilizer Level A have higher wheat yield than Fertilizer Level B
# Experimental unit:
# Response factor: fert - wheat yield
# Treatment factor: trt - Level of fertilizer (A or B)
fertdat$trt

# Extract yields for Fertilizer A
yA <- fertdat$fert[fertdat$trt == "A"]
# Extract yields for Fertilizer B
yB <- fertdat$fert[fertdat$trt == "B"]

################################# EDA:

######### Summaries:
summary(yA); sd(yA); quantile(yA,prob=c(0.25,0.75))
summary(yB); sd(yB); quantile(yB,prob=c(0.25,0.75))

######### Plots:
wheatdat <- stack(data.frame(yA,yB))

###### Create Emperical CDF plots
plot.ecdf(yB,xlab="yield", main="Empirical CDF Fertilizer")
plot.ecdf(yA,col="blue",pch=2,add=T);abline(v=20,lty=2)

####### Create side-by-side boxplot
boxplot(values~ind,data=wheatdat) 

####### Create QQPlots and Shapiro test for normality
qqnorm(yA,main = "Fertilizer A");qqline(yA) 
shapiro.test(yA)
# p-value = 0.9227 => Don't have enough evidence to say it is not normal

qqnorm(yB,main = "Fertilizer B");qqline(yB)
shapiro.test(yB)
# p-value = 0.5322 => Don't have enough evidence to say it is not normal

var.test(yA, yB)
t.test(yA,yB,var.equal = TRUE,alternative = "greater") # 95 % CI
######################################################
######## Two-Sided Randomization p-value (Not needed because of research question, but can change research question if you want to)
#tbar <- mean(res)
#pval_twosided <- sum(abs(res-tbar)>=abs(observed-tbar))/N
#round(pval_twosided,2)


# t.test(yB, yA, var.equal = TRUE)


################################ PART 2 #######################################

power.t.test(power = 0.8, delta = mean(yA)-mean(yB), 
             sd = sqrt((var(yA) + var(yB)) / 2), 
             sig.level = 0.05, type = "two.sample",
             alternative = "two.sided")

#Simulation-based power check ####

set.seed(123)
B <- 5000
reject <- numeric(B)
for (b in 1:B) {
  xA <- rnorm(length(yA), mean = mean(yA), sd = sd(yA))
  xB <- rnorm(length(yB), mean = mean(yB), sd = sd(yB))
  reject[b] <- t.test(xA, xB, alternative = "two.sided", var.equal = TRUE)$p.value < 0.05
}
mean(reject)


################################ PART 3A #######################################

View(painstudy)
?painstudy

pain = painstudy$pain
trt = as.factor(painstudy$trt)
aov.pain <- aov(pain~trt,data=painstudy) #anova(lm(pain~trt))
summary(aov.pain)
plot(aov.pain$fitted.values,aov.pain$residuals,ylab="Residuals",
     xlab="Fitted",main="Pain Study")
abline(h=0)

boxplot(pain~trt)


############## Checking Assumption: Normality

sapply(split(pain,trt),mean)
sapply(split(pain,trt),sd)

qqnorm(aov.pain$residuals, main="Normal Q-Q Plot for pain study")
qqline(aov.pain$residuals)
anova(lm(pain~trt))
contrasts(trt) <- contr.treatment(3); contrasts(trt) 

#contrasts(trt) <- contr.sum(3); contrasts(trt) 

class(trt)

lm.pain <- lm(pain~trt);
summary(lm.pain)$coefficients
model.matrix(lm.pain)

############# Checking Assumption: Constant Variance
plot(aov.pain$fitted.values,aov.pain$residuals,ylab="Residuals",xlab="Fitted",
     main="Pain study")
abline(h=0)


#### Multiple Comparison
pairwise.t.test(pain,trt,p.adjust.method = "bonferroni")
########
pairwise.t.test(pain,trt,p.adjust.method = "none")
########

TukeyHSD(aov.pain)
plot(TukeyHSD(aov.pain))

################################ PART 3B #######################################
data("shoedat_obs")
shoe_long <- data.frame(
  boy = factor(rep(shoedat_obs$boy, each = 2)),
  material = factor(rep(c("A", "B"), times = nrow(shoedat_obs))),
  side = factor(c(rbind(shoedat_obs$sideA, shoedat_obs$sideB))),
  wear = c(rbind(shoedat_obs$wearA, shoedat_obs$wearB))
)

shoe_long
tapply(shoe_long$wear, shoe_long$material, mean)

model_blocked <- aov(wear ~ material + boy, data = shoe_long)
summary(model_blocked)

model_unblocked <- aov(wear ~ material, data = shoe_long)
summary(model_unblocked) 

################################ PART 3C #######################################

View(BR_LatSq)
?BR_LatSq

latinsq.auto <- lm(value~Treat+as.factor(Dogs)+as.factor(Weeks),data=BR_LatSq)
anova(latinsq.auto)
summary(latinsq.auto)
######################################################
####### Checking the Assumptions
qqnorm(latinsq.auto$residuals,main="Q-Q Plot for weight loss")
qqline(latinsq.auto$residuals)
###
plot(latinsq.auto$fitted.values,latinsq.auto$residuals,ylab="Residuals",
     xlab="Fitted", main="weight loss")
abline(h=0)
##############


################################ PART 4 #######################################

View(wtlossdat)
?wtlossdat

############## Interaction Plots
interaction.plot(wtlossdat$A,wtlossdat$B,wtlossdat$y, type="l"
,xlab="Level of food diary",trace.label="Level of increasing activity", 
ylab="Weight loss (kg)")

interaction.plot(wtlossdat$A,wtlossdat$C,wtlossdat$y, type="l", 
xlab="Level of food diary",trace.label="Level of home visit", 
ylab="Weight loss (kg)")

interaction.plot(wtlossdat$C,wtlossdat$B,wtlossdat$y, type="l",
xlab="Level of home visit",trace.label="Level of increasing activity", 
ylab="Weight loss (kg)")

############# Linear Model for a $2^k$ Factorial Design 
fact.mod <-lm(y~A*B*C,data=wtlossdat)
round(summary(fact.mod)$coefficients,2)
round(2*fact.mod$coefficients,2)

#################################   Full-Normal Plots  
options(warn=-1)
library(FrF2) 
DanielPlot(fact.mod, autolab=F, main="Normal plot of effects")

################################## Half-Normal Plots   
library(FrF2) 
DanielPlot(fact.mod,half=TRUE,autolab=F,  main="Half-Normal plot of effects")

###################### Lenth’s Method 
library(BsMD)
LenthPlot(fact.mod,cex.fac = 0.8)
