NB.* myStats.ijs: my statistical fns.

NB.* redoLnLabels: replace ln values w/original values in x labels of ln plot.
NB.* norm01: normalize series to map from zero to one.
NB.* covariance: Calculate covariance of two vectors -> covariance (atom).
NB.* autoCorr: auto-correlation of y for lag of x.
NB.* wmean: weighted mean of y weighted by x
NB.* wdev: weighted deviation of y weighted by x
NB.* wssdev: weighted sum of squares of deviation of y weighted by x
NB.* wvar: weighted variance of y weighted by x
NB.* wstddev: weighted standard deviation of y weighted by x
NB.* shapedRand: generate random numbers from distribution shaped by parameters.
NB.* intraclassCorrelation: calc intraclass correlation given mat of classes by items.
NB.* collectFncStats: collect statistics on results of function.
NB.* boxMueller: Box-Mueller (polar) method to gen samples of normal dist.
NB.* bMcore: core calculation to generate standard normal samples.
NB.* winsorizeAtVal: winsorize at specified (low, high) value.
NB.* winsorizeAtPct: winsorize at percent from bottom and top; 0->none.
NB.* winsorizeAt: winsorize top and bottom at xth highest/lowest observation.
NB.* usus: my usual descriptive stats: min, max, mean, stddev
NB.* bivariate_normal: random numbers normally distributed along 2 dimensions
NB.* normalrand: choose y normally distributed random numbers
NB.* minPtn: partition into x parts numeric vector y to min diffs of sums.
NB.* parameterizedMats: create npt integer matrixes according to 3 parameters.
NB.* myMatInv: cover for %.-> return code;<answer or _.
NB.* myCholeski: cover for Choleski decomposition->return code;<answer or _.
NB.* powerMean: generalized mean: for N&powerMean for N: _1: harmonic; 1:
NB.* normSeries: normalize numeric series so it has same mean and stddev as
NB.* AllCombos: make mat of all possible distinct y things taken x at a time.
NB.* rmlt: remove elements of y < x
NB.* tr: (matrix) trace function
NB.* medianAbsDev: median absolute deviation.
NB.* setPlotColors: set plot colors to emphasize contrast between adjacent
NB.* genSD: generalize stddev to use arb exponent instead of 2.
NB.* plotHistoMulti: given title >0{x, plot 20 bucket histogram of multiple
NB.* histoDistrib: histogram distribution: count how many numbers in vector y
NB.* upperTri: return upper triangle of square mat y.
NB.* lowerTri: return lower triangle of square mat y.
NB.* corrStbl: correlation (more stable than "corr" from statfns.ijs).
NB.* crosscorrMat: build cross-correlation matrix between rows of 2 input mats.
NB.* corrMat: build correlation matrix of rows of input matrix.
NB.* SpearmanRho: Spearman's rank correlation coefficient for 2 rows of mat of
NB.* MAD: Mean Absolute Deviation
NB.* HurstExponent: calculate Hurst exponent (rescaled range analysis)
NB.* ret1p: 1-period return
NB.* KendallTau: calculate Kendalls tau (rank correlation coefficient) given
NB.* winsorize: cap high and low outliers of vec y at x (low, high) level(s).
NB.* fr: Nub frequencies
NB.* frtab: Frequency table
NB.* ptPairUp: pair up numbers x apart->complex nums for point (dot) plot.
NB.* mstat: xth moment of y
NB.* beta1: skewness
NB.* beta2: kurtosis (A&S)
NB.* gamma1:  skewness (Karl Fisher)
NB.* gamma2: kurtosis excess
NB.* skewSmall: skew for small sample.
NB.* stderr: standard error
NB.* teststat: test statistic: %/(skewSmall,stderr) y
NB.* mode: mode (largest category) of distribution.
NB.* pearson1: skew1 according to K. Pearson
NB.* pearson2: skew2 according to K. Pearson
NB.* quartile: breakpoint (max value) at which vector y ends quartile x
NB.* yule: Yule skewness measure
NB.* gamma: Gamma function of y
NB.* beta: Beta function of x and y
NB.* poissDist: Poisson distribution of states x with average number y
NB.* d29: xth moment of y
NB.* quantilify: make partition to break ordered vec y into x quantiles.
NB.* ntilebps: return breakpoint values of x-tiles of y; e.g. 4 ntile y -> quartiles;
NB.* bpntile: break vector into pieces based on (internal) breakpoints x
NB.* ntilebps: return breakpoint values of x-tiles of y; e.g. 4 ntilebps y
NB.* internalBPs: calculate internal breakpoints from quantile group.
NB.* kurtQuantile: kurtosis by quantiles, Chou, p.73.
NB.* kurt: kurtosis according to Excel documentation.
NB.* skew: skewness according to Excel documentation.
NB.* corrCoeff: coefficients of linear correlation between 2 columns of y
NB.* dFourierTransform: discrete Fourier transform due to Curtis Jones.
NB.* ftbasis: Basis function for Fourier transform
NB.* fourierTform: Fourier transform
NB.* invFourierTform: Inverse Fourier transform

NB. require 'plot'
require 'stats'
3 : 0 ''
   if. IFJ6 do. load jpath '~system\packages\math\matfacto.ijs'
   else. load jpath '~addons\math\misc\matfacto.ijs' end.
)

NB.* redoLnLabels: replace ln values w/original values in x labels of ln plot.
redoLnLabels=: 3 : 0
   'xlabel ',}.;' ',&.>(":&.>0.1 roundNums (] % 10 ^ [: (<.) 10&^.) y),&.>'E',&.>":&.><.10&^.y   
NB.EG OTHERPLOTARGS=: redoLnLabels ^;>{.ss=. ... plotHistoMulti ^.nums NB. Label log plot with ^ numbers.
)

NB.* norm01: normalize series to map from zero to one.
norm01=: (]%>./)@:(]-<./)

NB.* covariance: Calculate covariance of two vectors -> covariance (atom).
covariance =: 3 : 0
   y covariance y   NB. If no x, variance of y
:
   if. 0 = #y do. '' return. end.
   (+/ (x-(+/x) % #x)* y-(+/y) % #y) % #x
NB.EG 0.666667 -: 1 2 3 covariance 1 2 3
NB.EG (i. 3 3) covariance"1/ |: i. 3 3  NB. covariance matrix
)

NB.* autoCorr: auto-correlation of y for lag of x.
autoCorr=: (13 : '(x ([: +/ ((] }.~ [: - [) - [: (+/ % #) ]) * }. - [: (+/ % #) ]) y) % ([: +/ [: *: ] - +/ % #) y')"0 1

NB. Weighted versions of descriptive stats, courtesy Ric Sherlock.
NB.* wmean: weighted mean of y weighted by x
wmean=: +/@[ %~ +/@:*
NB.* wdev: weighted deviation of y weighted by x
wdev=: ] -"_1 _ wmean
NB.* wssdev: weighted sum of squares of deviation of y weighted by x
wssdev=: [ +/@:* *:@wdev
NB.* wvar: weighted variance of y weighted by x
wvar=: (#@-.&0 %~ <:@#@-.&0 * +/)@[ %~ wssdev
NB.* wstddev: weighted standard deviation of y weighted by x
wstddev=: %:@wvar
NB.EG 5.82237 = 1 1 0 0 4 1 2 1 0 wstddev 2 3 5 7 11 13 17 19 23

NB.* shapedRand: generate random numbers from distribution shaped by parameters.
shapedRand=: 3 : 0
NB. #, min, max, skewness (<1: low, 1: mid-point, >1:high), how
NB. peaked (1: flat, >10: good approximation of normal)
   'y min max skw pkd'=. 5{.y
   'skw pkd'=. (0=skw,pkd){&.>(skw,1);pkd,10
   assert. skw>0
   assert. (pkd>0) *. pkd=<.pkd
   assert. (y>0)*.y=<.y
   xx=. (min,max) scaleNums (%skw)^~+/(pkd,y)?@$0
NB.EG rndnums=. pkdSkew 1000 10 90 0.5 3
NB. 1000 #s from 10 to 100, skewed lower (<1), fairly flat (slightly normal).
)

NB.* intraclassCorrelation: calc corr btw classes of mat of classes by items
intraclassCorrelation=: 3 : 0
   sc=. y
   C=. (*:+/,sc)%#,sc              NB. Correction term
   SST=: C-~+/*:,sc                NB. Total SS
   SSBC=: C-~(1{$sc)%~+/*:+/"1 sc  NB. Sum of Squares between classes
   dofbc=. <:#sc                   NB. degrees of freedom for SSBC
   doft=. <:#,sc                   NB. degrees of freedom for SST
   BCMS=: SSBC%<:#sc               NB. Between Classes Mean Squares
   WMS=: (SST-SSBC)%(#,sc)-#sc     NB. Within classes Mean Square
   R=: (BCMS-WMS)%BCMS+WMS*<:1{$sc NB. Intraclass correlation
)

NB.* collectFncStats: collect statistics on results of function.
collectFncStats=: 1 : 0
   'ntc npc'=. y   NB. # to collect, # per collection (fnc arg)
   cav=. ntc$_.
   for_ix. i. ntc do. cav=. (u npc) ix}cav end.
NB.EG (mean@normalrand) collectFncStats 10000 100 NB. mean of 100 runs of normalrand 10000
)

NB.* boxMueller: Box-Mueller (polar) method to gen samples of normal dist.
boxMueller=: 3 : 0
   rns=. i.0
   while. y>#rns=. rns,,bMcore y do. end.
   rns=. y{.rns
)

NB.* bMcore: core calculation to generate standard normal samples.
bMcore=: 3 : 0
   s=. +/*:vv=. <:+:?0$~2,y
   incircle=. (s<:1)*.s~:0
   ar=. ^.s#~incircle
   rr=. (incircle#"1 vv)*"1 %:(incircle#s)%~-+:ar
)

NB.* winsorizeAtVal: winsorize at specified (low, high) value.
winsorizeAtVal=: 13 : '(y<:>./x)>:<./x'
NB.* winsorizeAtPct: winsorize at percent from bottom and top; 0->none.
winsorizeAtPct=: 4 : 0
   pcts=. <.0.5+x*#grd=. /:y
NB.   (y<.y{~grd{~-1>._1{pcts)>.y{~grd{~0>.<:0{pcts
   (y>.y{~grd{~0>.<:0{pcts)<.y{~grd{~-1>._1{pcts
NB.EG (0 0 2 3 5 6 6 8 17 17)-:0.2 0.2 winsorizeAtPct _9 0 2 3 5 6 6 8 17 93
NB.EG (0 0 2 3 5 6 6 8 8 8)-:0.2 0.3 winsorizeAtPct _9 0 2 3 5 6 6 8 17 93
NB.EG (2 2 2 3 4 5 6 7 8 9 9 9)-: 0.25 0.25 winsorizeAtPct i.12
)

NB.* winsorizeAt: winsorize top and bottom at xth highest/lowest observation.
winsorizeAt=: 13 : 'y#~(y>y{~x{/:y)*.y<y{~x{\:y'
winsorizeAt=: 4 : 0
   grd=. /:y
   y=. (y<:y{~x{grd) }y,:y{~x{grd
   y=. (y>:y{~(-x){grd) }y,:y{~(-x){grd
)

NB.* usus: my usual descriptive stats: min, max, mean, stddev
usus=: 3 : 0
   if. 0=L. y do. (]`|: @.(1<#$y))(<./,>./,mean (,`,: @.(1<#$y)) stddev) y
   else. (<./,>./,mean,stddev)&> y end.
)

NB.* bivariate_normal: random numbers normally distributed along 2 dimensions
NB. From: Roelof K. Brouwer <rbrouwer@tru.ca>	
NB. Reply-To: General forum <general@jsoftware.com>
NB. To: general@jsoftware.com
NB. Date: Jan 28, 2006 8:00 AM
NB. Subject: [Jgeneral] plotting
bivariate_normal=: 4 : 0
   'm0 m1 a0 a1 a2'=. x
NB. first two numbers is the mean. 3rd and 5th is the variance in each
NB. dimension, middle is the correlation I think.
   (m0+a0*z0),"0 0 m1+(a1*z0=.normalrand  y)+a2*normalrand  y
)

NB.* normalrand: choose y normally distributed random numbers (from statdist.ijs)
normalrand=: 3 : 0
   (2 o. +: o. rand01 y) * %: - +: ^. rand01 y
)

rand01=: ?@$ 0:

NB.* normrand01: y samples from (0,1) normal distribution.  Adapted from
NB. APL Quote-Quad 19710611 vol. III, No. 1, article by Robert Goodell Brown,
NB. p. 28:
NB.  RANDSAMP n generates n random samples from the normal distribution (0,1)
NB.  exactly.  The trick is to use a bivariate normal distribution which can be
NB.  integrated in closed form.  The first random vector selects an annulus
NB.  according to the desired probability, and the second a random angle to
NB.  project the annulus back onto the x-axis.
normrand01=: 3 : '(1 o. 0.001*?y$>.o. 2000)*-:_2*^0.001*?y$1000'

NB. tplot=.,/((t,(4 2 1 1 1 *t),(7 3 1 1 1 *t),:(10 5 1 1 1 *t=.1000  1000 400 10 400))bivariate_normal("1 0) >.1000%4)

NB.* minPtn: partition into x parts numeric vector y to min diffs of sums.
minPtn=: 4 : 0
   brkpt=. x%~+/y
   bestguess=. 1,2>/\brkpt|ss=. +/\y
   msr=. 3 : '+/|2-~/\+/&>y'
   bestmsr=. msr bestguess<;.1 y
   for_fudge. 100%~brkpt*_10+i.35 do.
       newguess=. 1,2>/\(brkpt+fudge)|ss
       if. bestmsr>newmsr=. msr newguess<;.1 y do.
           bestguess=. newguess [ bestmsr=. newmsr
       end.
   end.
   bestmsr;<bestguess
)

parameterizedMats=: 3 : 0
NB.* parameterizedMats: create npt integer matrixes according to 3 parameters.
   'min shp max0 npt'=. 4{.y,100       NB. Minimum, shape (square mat), initial
   min+&.>?&.>(<2$shp)$&.>npt$<>:max0   NB. max value, [Number per Try].
)

myMatInv=: 3 : 0
NB.* myMatInv: cover for %.-> return code;<answer or _.
   rc=. 1 [ ans=. _
   try. ans=. %. y catch. rc=. 0 end.
   rc;<ans                    NB. rc: 0 failure, 1 success.
)

myCholeski=: 3 : 0
NB.* myCholeski: cover for Choleski decomposition->return code;<answer or _.
   rc=. 1 [ ans=. _
   try. ans=. choleski y catch. rc=. 0 end.
   rc;<ans                    NB. rc: 0 failure, 1 success.
)

kCovar=: 4 : 0
   md=. y-mean y
   (<:(#y)-x)%~+/(md}.~-x)*x}.md
)

powerMean=: 4 : 0
NB.* powerMean: generalized mean: for N&powerMean for N: _1: harmonic; 1:
NB. arithmetic; 2: root mean square; 0: ->geometric as N->0 but =1 @ 0.
  (%x)^~mean y^x
)

pm=: ([: % [) ^~ [: (+/ % #) ] ^ [   NB.* pm: tacit form of powerMean above.

normSeries=: 3 : 0
NB.* normSeries: normalize numeric series so it has same mean and stddev as
NB. another series; x is mean and stddev of target.
NB.   ((mean,stddev) y) normSeries y     NB. -> standard norm if no target
   0 1 normSeries y                    NB. -> standard norm if no target
:
   x=. x,.(mean,stddev) y            NB. Target & source mean & stddev
   'tm sm'=. 0{x                       NB. Target and source means
   tm+(y-sm)*%/1{x
)

AllCombos=: 4 : 0
NB.* AllCombos: make mat of all possible distinct y things taken x at a time.
   comb=. ,.basis=. i.y
   while. 0<x=. <:x do.
       maxs=. >./"1 comb
       newcol=. maxs rmlt&.><basis
       lens=. ;#&.>newcol
       comb=. (lens#comb),.;newcol
   end.
   comb
)

rmlt=: 4 : 'y#~y>x'             NB.* rmlt: remove elements of y < x
rmlt=: (]#~<)                      NB.* rmlt: remove elements of y < x
tr=: +/@:((<0 1)&|:)               NB.* tr: (matrix) trace function
medianAbsDev=: median@(|@-median)  NB.* medianAbsDev: median absolute deviation.

setPlotColors=: 3 : 0
NB.* setPlotColors: set plot colors to emphasize contrast between adjacent
NB. entries->easier to distinguish adjacent bars in multi-histogram.
   load 'logo'
   hl=. <.-:#pp=. <"1 pal11_38
   pp=. ,(hl{.pp),.hl}.pp
   STDCLR_jzplot_=: >,|:4 7$(256$9{.1)#pp
NB. Maybe we want light and dark to alternate more:
   alt=. (#STDCLR_jzplot_)$0 1
   max=. 255-"(0 1)STDCLR_jzplot_
   STDCLR_jzplot_=: <.STDCLR_jzplot_+max<.(128*alt)*255%~max
NB.EG STDCLR_jzplot_=: setPlotColors ''
)

step=: ,
to=: 4 : 0
NB.* to: e.g. <start num> to <end num> [step <increment>]
   if. 2~:#y=. ,y do. y=. 2{.y,1 end.
   x +  (1{y) * (*x-~0{y) * i. >:<.0.5+(|x-0{y)%1{y
)
range=: >./-<./
NB.* genSD: generalize stddev to use arb exponent instead of 2.
genSD=: 4 : '((+/(|y-mean y)^x)%<:#y)^%x'
NB. x=. 1 is MAD: Mean Absolute Deviation.

plotHistoMulti=: 4 : 0
NB.* plotHistoMulti: given title >0{x, plot 20 bucket histogram of multiple
NB. rows of numbers y; optional bar labels are space-separated words >1{x.
NB. Optional flag >2{x: 1 -> sort cumulative sum of ascending values;
NB. _1-> sort reverse cumulative sum.
NB. "21" below because includes 1 extra bucket for spillage: low values.
   if. 0>4!:0 <'NB' do. NB=. 21<.>:#~.,openbox y end.     NB. Num buckets
   y=. (]`,: @. ((0=L. y)*.(1=#$y)*.1~:#y)) y NB. Vec->1 row mat
   'pltit keylabel cumv'=. 3{.boxopen x NB. Plot title, labels for multiple items, show accumulated values of input.
   if. 0>4!:0 <'PCT' do. PCT=. 0 end.   NB. Assume numbers should not be percents.
   if. 0=#cumv do. cumv=. 0 end.        NB. Plot cumulative sum or not.
   mmy=. (<./;<./&.>y),>./;>./&.>y      NB. Min and max values of all ys
   if. 0>4!:0 <'BKTS' do.               NB. "0.99*" -> division < least.
       BKTS=. (0.99*0{mmy) to (1.00001*1{mmy) step NB%~|-/mmy
   end.
   if. 0=4!:0 <'FORCEBKT' do. NB. Force a particular bucket division, eg. 0.
       BKTS=. BKTS+FORCEBKT-BKTS{~0{/:|BKTS-FORCEBKT
   end.
   xlbls=. (": &.>(PCT{0.01 0.1) roundNums (PCT{1 100)*BKTS),&.><(PCT#'%'),' '
   xlbls=. ;xlbls                       NB. Keep original labels for cumulative
   xlbls=. ('_';'-') stringreplace xlbls NB.  plot because seems more useful.
   if. 1=#y do. plargs=. 'hist' else. plargs=. 'bar' end.
   plargs=. plargs,';plotcaption Histogram;title ',pltit,';xlabel ',xlbls
   plargs=. plargs,';labelfont "Courier New" 14;keyfont "Courier New" 16'
   plargs=. plargs,';keystyle fat'
   if. -.nameExists 'PLOTSZ' do. PLOTSZ=. 'output PDF 1000 1000' end.
   plargs=. plargs,';',PLOTSZ
   if. 0=#keylabel do. keylabel=. ":i.#y end.
   plargs=. plargs,(1~:#y)#';key ',keylabel NB. No key if only 1 data series.
   if. 0=4!:0 <'OTHERPLOTARGS' do. plargs=. plargs,';',OTHERPLOTARGS end.
   if. 0=L. y do. y=. <"1 y end.     NB. Make all boxed data
   BKTS=. <BKTS
   if. 1=|cumv do.
       if. 1=cumv do.
           plargs plot rsd=. (]}.~[:-0={:) >+/\"1 &.> >&.>2{&.> BKTS histoDistrib&.>y
       else.
           plargs plot rsd=. (]}.~[:-0={:) >(+/\&.|.)&.> >&.>2{&.> BKTS histoDistrib&.> y
       end.
   else.
NB.       plargs plot (]}."1~[:-0*./ .={:"1)>&>2{&.> rsd=. BKTS histoDistrib&.> y
       plargs plot >&>2{&.> rsd=. BKTS histoDistrib&.> y
   end.
   BKTS;xlbls;plargs;pltit;<rsd    NB. Return parms in case we want to tweak.
NB.EG ds3=. +/&.>(_1e2&+@?)&.>(mul,&.>1000)$&.>>:2e2 [ mul=. 2 6 18
NB.EG ds3=. >ds3%&.>>./|;ds3
NB.EG xx=. ('3 Normal Approximations';":mul) plotHistoMulti ds3
NB.EG xx=. ('3 Cumulative Normal Approximations';(":mul);1) plotHistoMulti ds3
NB. To save plot as .WMF file: pd 'save wmf ',flnm
)

histoDistrib=: 3 : 0
NB.* histoDistrib: histogram distribution: count how many numbers in vector y
NB. into are in each of x evenly-spaced bins; vector x is specific bin-breaks.
   10 histoDistrib y
:
   vec=. y
   if. 1=#$x do. numbuckets=. <:#frets=. x
   else. numbuckets=. x
NB.   span=. -/range=. 1 _1+(>./ , <./)vec   NB. 1 more or less than extremes
       span=. -/range=. (>./ , <./)vec
       frets=. (1{range)+(span%>:numbuckets)*i.numbuckets
   end.
NB. Also figure how far apart dividing points (frets) should be to have
NB.  equal number per bucket.
   if. numbuckets<:#vec do.   NB. (vec{~/:vec) -: (/:~vec) but latter->limit err.
       equifrets=. (vec{~/:vec){~<.0.5+(}.i.>:numbuckets)*(>:numbuckets)%~#vec
       equifrets=. (<./vec),equifrets            NB. start at lowest element
   else. equifrets=. 0 end.
   npb=. ->:2-/\((#frets)+#vec),~_1,I. (#frets)>/: frets,vec
   equifrets;frets;<npb
NB.EG >25 histoDistrib +/_100+?10 1000$201   NB. Pseudo-normal distribution.
)

keypos_doc_=: 0 : 0
keypos - a list of up to three positions from:
    left center right
    top middle bottom
    inside outside 

First-letter abbreviations are supported. The default is lti, or equivalently: left top inside. 
)

NB.* upperTri: return upper triangle of square mat y.
upperTri=: 3 : '(,+./\"1 ($y)$_1|.(>:1{$y){.1)#,y'
NB.EG upperTri i.5 5
NB.* lowerTri: return lower triangle of square mat y.
lowerTri=: 3 : '(,*./\"1 -.($y)$(>:1{$y){.1)#,y'

NB.* corrStbl: correlation (more stable than "corr" from statfns.ijs).
corrStbl=: (+/@:* % *&(+/)&.:*:)&(- +/ % #)

crosscorrMat=: 13 : 'x corrStbl"1/y'
crosscorrMatOld=: 4 : 0
NB.* crosscorrMat: build cross-correlation matrix between rows of 2 input mats.
   N=. ;#&.>x;y
   ccm=. N$1.1-1.1
   for_ii. i.0{N do.
       cc1r=. ;corrCoeff&.>(<ii{x),.&.><"1 y
       ccm=. (cc1r) ii}ccm
   end.
   ccm
NB.EG eg=. (+/\"1 i. 3 3) crosscorrMat i. 3 3
NB.EG eg -: }."1 >{.&.>corrMat &.> (+/\&.><"1 i.3 3),&.><i. 3 3
)

corrMat=: 3 : 0
NB.* corrMat: build correlation matrix of rows of input matrix
   mnc =. ] -"1 +/%#        NB. adjust rows by their means
   sscp =. |: (+/ . *) ]    NB. sum squares
   ((sscp@mnc)@(mnc %"1 stddev) % <:@#) y
)

corrMatOld=: 3 : 0
NB.* corrMatOld: build correlation matrix of columns of input matrix
   N=. #y
   cm=. (2$N)$1.1-1.1
   for_ii. >:i.<:N do.
       c1r=. ;corrCoeff&.>(<(<:ii){y),.&.><"1 ii}.y
       cm=. ((-N){.0.5,c1r) (<:ii)}cm
   end.
   cm=. ((-N){.0.5) _1}cm
   cm+|:cm
)

compareKendallSpearman=: 3 : 0
   'numsamps sampsz samplen'=. 3{.y,10000 100
   ms=. (numsamps,2 2)$0
   sampsz=. (>:sampsz),samplen
   for_ii. i.numsamps do.
       rr=. /:"(1) ?sampsz$1e7                    NB. Random ranks: true values
       ksrr=. (2 KendallTau\/:"1 rr),.2 SpearmanRho\rr NB.  should -> 0.
       ms=. ((mean,stddev)"1 |:ksrr) ii}ms
   end.
   ms;<(a:,'Mean';'SD'),('Kendall';'Spearman'),.8{.&.>j2n&.>0.000001 roundNums mean ms
)

SpearmanRho=: 3 : 0
NB.* SpearmanRho: Spearman's rank correlation coefficient for 2 rows of mat of
NB. ranks.
   N=. 1{$y
   1-6*+/(*:-/y)%N*<:*:N
NB.EG SpearmanRho /:"(1) ?2 100$1000
)

combSDMAD=: 3 : 0
   (MAD y)(+/*-/)stddev y
)

varexpSD=: 4 : 0
NB.* varexpSD: variable exponent standard deviation.
NB.   %:(+/(dev y)^x)%<:@#y
   dy=. dev y
   xx=. (+/(*dy)*(|dy)^x)%<:@#y
   (*xx)*%:|xx
)

MAD=: 3 : 'mean@:|@:dev "1 y'     NB.* MAD: Mean Absolute Deviation

signGrpDev=: 3 : 0
NB.* signGrpDev: signed deviation, from group mean, for each row of mat.
   mat=. y
   mm=. mean ,mat
   len=. <:1{$mat
   df=. mat-"1 0 mm
   mds=. +/"1 (*df)**:df
   (*mds)*%:|mds%len
)

ccd=: [:+/\]-avg              NB.* ccd: cumulative centered distribution
ccr=: (max-min)@:ccd          NB.* ccr: cum centered range
rescaledRange=: ([:mean,:~@[(ccr%stddev);._3])"0 1     NB.* rescaledRange: rescaled range

HurstExponent=: 3 : 0
NB.* HurstExponent: calculate Hurst exponent (rescaled range analysis)
NB. per Peters: Fractal Market Analysis. Use, e.g., thusly:
NB.      RND„+\.001×¯1000+?100½2001    © Random walk
NB.      RND„1+RND-˜/RND               © Ensure all > 0 (‰1)
NB.      COLORPLOT (¼½RND),[¯.5]RND ª 0.25 HurstExponent RND
NB.¸ x:DPP: Drop Portion (0ˆDPP[0]<1) off end to avoid noisy tails;
NB. DPP[1] plot (1) or not(0); DPP[2] limit to # of windows: 2<DPP[2]<0.5*$ts;
NB. DPP[3] is % to drop from start of RS.
   0.05 0 2 0.10 HurstExponent y
:
   ts=. y [ dpp=. 4{.x
   if. 5<:#ts do.
       wlen=. #winszs=. (2{dpp)+i.<.-:<:#ts
       rs=. winszs rescaledRange ts
       mask=. ((i.wlen)>:wlen*3{dpp)*.(i.wlen)<:wlen*1-0{dpp
       if. 1<+/mask do.
           intslp=. (^.mask#rs)%.1,.^.mask#winszs
           if. 1{dpp do. plot (^.rs),(^.winszs),:(^.rs)%^.winszs end.
           1;<intslp        NB. return code; intercept, slope (=exponent)
       else. 0;<'Mask too tight with parms: ','.',~":dpp end.
   else. 0;<'Must have >: 5 elements.' end.
NB.EG 'rc ie'=. HurstExponent >:rnd-<./rnd=. +/\0.001*_1000+?100$2001
)

ret1ToMultiP=: 4 : 0"1
NB.* ret1ToMultiP: convert 1-period to multi-period returns.
   plen=. x
NB. Convert returns as "r" to "1+r" and make cumulative.
   2 ret1p\(*/\>:y)#~(#y)$plen{.1
)

NB.* ret1p: 1-period return given vec of return indexes.
ret1p=: 13 : '<:(}.y)%}:y'"1
NB.EG    ret1p 3 4
NB.EG 0.33333333
NB.EG 2 ret1p\ ?100$10

KendallTau=: 3 : 0
NB.* KendallTau: calculate Kendalls tau (rank correlation coefficient) given
NB. 2 row mat y of ranks.
   max=. -:*/0 _1+1{$y
   actual=. +/;<:&.>2*&.>=/&.>>&.>(<"1}:|:y)<&.>&.><"1(}.i.1{$y)}.&.>/<"1 y
   actual%max
NB.EG    KendallTau /:"1 ?2 100$1000
NB.EG    KendallTau >i.&.>10 10
NB.EG 1
NB.EG    KendallTau (i.10),:|.i.10
NB.EG _1
)

winsorize=: 4 : 0
NB.* winsorize: cap high and low outliers of vec y at x (low, high) level(s).
  'low high'=. (1 _1*0 1+<.0.5+x*#y){/:~y
  low>.high<.y
NB.EG 0.01 winsorize ?10000$1000001  NB. Top and bottom 1%
)

coinsert_test_ 'base'

t_winsorize_test_=: 3 : 0
   if. 0=#y do.
       ans=. 0 1 2 3 4 5 6 6 6 6;1 1 2 3 4 5 6 6 6 6;1 1 2 3 4 5 6 7 8 9;3 3 3 3 4 5 6 6 6 6
       parms=. 0 0.25;0.1 0.25;0.1 0;0.25
       src=. <i.10
   else. 'ans parms src'=. y end.
   assert. *./ans-:&>parms winsorize&.>src
)

fr=: +/"1 @ =                 NB.* fr: Nub frequencies
frtab=: ~. ,. fr              NB.* frtab: Frequency table
frtab=: 3 : 0                 NB.* frtab: Frequency table (more efficient)
   y=. y/:y
   difs=. 2-~/\(#y),~I. 1,2~:/\y
   if. -.isNum y do. difs=. <"0 difs [ y=. <"1 ,.y end.
   difs,.~.y
)

frtab=: 3 : 0
   cts=. #/.~ y          NB. Count # of each unique item.
   if. -.isNum y do.     NB. Special case enclosed, text mat, text vec,
       if. (L.=0:) y do. (<"0 cts),.<"0 ~.y else. 
           if. 2=#$y do. (<"0 cts),.<"1 ~.y else. (<"0 cts),.<"0 ~.y end.
       end.
   else. cts,.~.y end.   NB. and simple numeric vec.
NB.EG (1 2 3 2 1,. 11 22 33 222 99) -: frtab 11 22 22 33 33 33 222 222 99
)

NB.* ptPairUp: pair up numbers x apart->complex nums for point (dot) plot.
ptPairUp=: 4 : '1 0j1+/ . *~ (y}.~-x),.x}.y'
ptPairUp=: ([:>:[)({.j.{:)\]
NB.EG 'dot;pensize 3' plot 25 ptPairUp 1 o. steps _1p1 1p1 100 NB. 3/4 circle

mstat=: 4 : '(#y)%~+/(y-mean y)^x'       NB.* mstat: xth moment of y
beta1=: 3 : '(*:3 mstat y)%3^~2 mstat y'   NB.* beta1: skewness
beta2=: 3 : '(4 mstat y)%*:2 mstat y'      NB.* beta2: kurtosis (A&S)
gamma1=: 3 : '(3 mstat y)%1.5^~2 mstat y'  NB.* gamma1: skewness (Karl Fisher)
gamma2=: 3 : '3-~(4 mstat y)%*:*:stddev y' NB.* gamma2: alternate spelling
gamma2=: _3&+@:beta2                         NB.* gamma2: kurtosis excess
skewSmall=: 3 : '((*:#y)*3 mstat y)%*/(1 2-~#y),3^~stddev y'
stderr=: 3 : '%:(*/6,(#y)-0 1)%*/(#y)+_2 1 3'
teststat=: 3 : '%/(skewSmall,stderr) y'
mode=: ~. {~ [: (i. >./) #/.~           NB.* mode: (per Johann Hibschman): member of largest category.
pearson1=: 3 : '((mean y)-mode y)%stddev y'         NB.* pearson1: skew1
pearson2=: 3 : '3*((mean y)-median y)%stddev y'     NB.* pearson2: skew2
quartile=: 4 : 'x{4 ntilebps y'            NB.* quartile: xth quartile lim
yule=: 3 : '(+/(2 0 quartile y),_2*median y)%-/2 0 quartile y' NB.* yule: skewness

gamma=: !@<:                  NB.* gamma: Gamma function of y
beta=: *&gamma % gamma@+      NB.* beta: Beta function of x and y
poissDist=: ^@-@] * ^~ % !@[  NB.* poissDist: Poisson distribution of states x with average number y
poissDist=: (^@-@] * ^~ % !@[)~    NB.* poissDist: Poisson distribution of states y with average number x
NB. Or, given the average rate of occurrence x, calculate the probability of an observed # occurrences y.
d29=: (+/@((]-+/@]%#@])^[)%#@])"1  NB.* d29: xth moment of y

NB.* quantilify: make partition to break ordered vec y into x quantiles.
quantilify=: 4 : '1 (1 roundNums (i.x)*x%~#y)}(#y)$0'

NB.* ntile: break vector into x equally-sized pieces based on ascending values.
ntile=: 4 : 0"(0 1)
   grdy=. /:~y
   brkptixs=. roundNums (>:i.<:x)*x%~#y NB. Internal breakpoints only
   brkptixs=. grdy i. brkptixs{grdy     NB. Adjust for breaks across =values.
   ptn=. (1) (0,brkptixs)}0$~#y
   ptn<;.1 grdy
)

NB.* bpntile: break vector into pieces based on (internal) breakpoints x
bpntile=: 4 : 0
   grd=. /:x,y
   ptn=. 1,(1) (grd i. i.#x)}0$~#grd
   ptn<;._1 ] 0,grd{x,y
)

NB.* bpntileix: index vector elements by breakpoint-based quantiles.
bpntileix=: 4 : 0
   grd=. /:x,y
   ptn=. 1,grd e. i.#x
   tt=. ptn<;._1 ] 0,grd
   ((#&>tt)#i.#tt) ((;tt)-#x)}_1$~#y
)

ntilebps=: 4 : 0
NB.* ntilebps: return breakpoint values of x-tiles of y; e.g. 4 ntilebps y
NB.  -> quartiles; 0-based so "1st" quartile is 0{4 ntilebps y.
   quant=. x
   y=. /:~y
   wh=. 0 1#:(i.quant)*quant%~#y  NB. Where partition points are exactly
   'n f'=. |:wh                    NB. whole and fractional part of partitions
   1|.+/"1 ((1-f),.f)*(n+/_1 0){y NB. "1|." moves top quantile to end.
)

NB.* internalBPs: calculate internal breakpoints from quantile group.
internalBPs=: 13 : '-:(}:>./&>y)+}.<./&>y'
internalBPs_usage_=: 0 : 0
   ]bp=. internalBPs 3 ntile rr=. ?12$20
9.5 14
   bp bpntile bp,/:~rr
+-------+---------------+--------------+
|2 5 7 9|9.5 10 10 12 13|14 15 15 18 18|
+-------+---------------+--------------+
   (/:~rr),:/:~bp bpntileix rr
2 5 7 9 10 10 12 13 15 15 18 18
0 0 0 0  1  1  1  1  2  2  2  2
)

internalBPs0=: 4 : 0"0 1
   grdy=. y{~gv=. /:y
   brkptixs=. <.0.5+(>:i.<:x)*x%~#y     NB. Internal breakpoints only
   brkptixs=. grdy i. brkptixs{grdy     NB. Adjust for breaks across =values.
   }.-:+/y{~gv{~0 1-~/ brkptixs         NB. Break between edges
)

NB.* kurtQuantile: kurtosis by quantiles, Chou, p.73.
kurtQuantile=: 3 : '(-:-/2 0 quartile y)%-/8 0{10 ntilebps y'

kurt=: 3 : 0
NB.* kurt: kurtosis according to Excel documentation.
   (((*/0 1+#y)%*/1 2 3-~#y)*+/((y-mean y)%stddev y)^4)-(3**:_1+#y)%*/_2 _3+#y
NB.EG _0.15179963720842=kurt 3 4 5 2 3 4 5 6 4 7
)

skew=: 3 : 0
NB.* skew: skewness according to Excel documentation.
   ((#y)%(*/_1 _2+#y))*+/((y-mean y)%stddev y)^3
NB.EG 0.35954307140680=skew 3 4 5 2 3 4 5 6 4 7
)

corrCoeff=: 3 : 0
NB.* corrCoeff: coefficients of linear correlation between 2 columns of y
   avgdif=. y-"(1 1)mean y
   (+/*/"1 avgdif)%%:*/+/*:avgdif
)

bucketVals=: 3 : 0
NB. bucketVals: given numeric (real) vector and number of buckets into
NB. which to group values, return bucket boundaries and number of elements
NB. per bucket.
   'nb vec'=. (0{,y);<}.,y
   maxmin=. ((>./),<./) vec
   bkts=. (1{maxmin)+(i.nb)*nb%~-/maxmin
NB. 2 ways to do this:
NB. }.+/(vec</bkts,_)*.vec>:/__,bkts
   <:2-~/\(nb+#vec),~(/:bkts,vec)i. i.nb
)

bucketValsCompare=: 3 : 0
NB. bucketValsCompare: given numeric (real) vector and number of buckets into
NB. which to group values, return bucket boundaries and number of elements
NB. per bucket.  Use (less efficient) compare method.
   'nb vec'=. (0{,y);<}.,y
   maxmin=. ((>./),<./) vec
   bkts=. (1{maxmin)+(i.nb)*nb%~-/maxmin
NB. 2 ways to do this:
   }.+/(vec</bkts,_)*.vec>:/__,bkts
NB.   <:2-~/\(nb+#vec),~(/:bkts,vec)i. i.nb
)

dFourierTransform=: 3 : 0
NB.* dFourierTransform: discrete Fourier transform due to Curtis Jones.
   j=. i.n=. #y
   f=. y +/ . * ^ o. 0j2*j */ j%n
)
NB.    dFourierTransform i. 4
NB. 6 _2j_2 _2 _2j2
NB.    dFourierTransform i. 5
NB. 10 _2.5j_3.44095 _2.5j_0.812299 _2.5j0.812299 _2.5j3.44095
NB.    dFourierTransform i. 2 2
NB. 1 _1
NB. 5 _1

noteOnDFT=: 0 : 0
Date: Tue, 15 Apr 2003 02:14:53 -0300
From: "News Gateway" <owner-apl-l@sol.sun.csd.unb.ca>
Subject: Re: Looking for a really terse FFT...
To: APL-L@LISTSERV.UNB.CA

X-From: "Curtis A. Jones" <Curtis_Jones@prodigynet>

~rr~, Devon,
Here's a discrete Fourier transform.  It may not be fast, but it's
terse:

J{<-}(-#IO)+{iota}N{<-}{rho}X
F{<-}X+.{times}*{pitimes}0J2{times}J{jot}.{times}J{divide}N

It assumes your APL can do complex arithmetic.

The data in the "time" domain are in a vector, X
The results, in the "frequency" domain, are assigned to F.

I don't know if the size of X must be a power of 2.  The fast Fourier
transforms that emulate this usually require the number of elements in
the time domain to be 2, 4, 8, 16, 32... This is not an FFT per se, but
with a math coprocessor it might be fast enough.   Curtis
)

bibliography=: 0 : 0
A&S: Abramowitz and Stegun, 1972.
Chou, Ya-lun; Statistical Analysis, 2nd Edition; Holt, Rhinehart, Winston; 1984.
K&K: Kenney and Keeping, 1951.
)

NB. Fourier transform from Raul Miller: http://www.jsoftware.com/jwiki/Guides/Fourier_Transform
NB.* ftbasis: Basis function for Fourier transform
ftbasis=: %: %~ 0j2p1&% ^@* */~@i.
NB.* fourierTform: Fourier transform
fourierTform=: +/ .* ftbasis@#
NB.* invFourierTform: Inverse Fourier transform
invFourierTform=: +/ .* %.@basis@#            NB.*ifft: Inverse Fourier transform

fftAndBackEG=: 0 : 0
   1e_9*<. 0.5+1e9*ift ft i.10          NB. Elim spurious complex #s by rounding
0 1 2 3 4 5 6 7 8 9
   1e_9*<. 0.5+1e9*0{"1+. ift ft i.10   NB. Better->all real types.
0 1 2 3 4 5 6 7 8 9
)
