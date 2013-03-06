#!/usr/bin/R

# Run this script to generate the object file that trains the model on the
# steel strain data.  Should take less than an hour or so.

library(gppois)
data(steelStrain)

# Training data
d.strain <- Dataset(id="steel.strain", data=steelStrain, X.names=c("X", "Y"),
  column="exx", data.offset=0)

# Testing data (true data inside the gap)
d.gap <- Dataset(id="gap.points", data=steelStrainGap, X.names=c("X", "Y"),
  column="exx", data.offset=0)

# Set up our model:
M.aniso <- Model(id="aniso")

# Setup and add the Covariance.  First, make some educated guesses about
# lengthscales.
ell.bounds <- c(0.1, 10)
sigma.f.relative <- c(0.1, 10)
sigma.n.bounds <- diff(range(d.strain$dpts)) * c(1e-7, 1e-3)

# Then, setup the Covariance object:
Cov.2d <- CovarianceSEAniso2D(id="signal", theta.1=0,
  ell.1.bounds=ell.bounds, ell.2.bounds=ell.bounds,
  sigma.f.bounds=sigma.f.relative * sd(d.strain$dpts))

# Then, add it to the Model
M.aniso$AddCovariance(Cov.2d)
M.aniso$SetNoiseBounds(sigma.n.bounds)

# Train the model (the slow part)
M.aniso$Train(d=d.strain)
post <- M.aniso$PosteriorInterval(d=d.strain)

# Save the file for speedy access later.
x.gap.surface <- GriddedConvexHull(X=d.gap$X, spacing=0.2)
save(x.gap.surface, d.strain, d.gap, M.aniso, file='custom/trained.RO')

################################################################################
# Make the animation

# Load libraries
library(animation)
library(Cairo)

# Set parameters
open3d()
width <- 1000  # pixels
height <- 600  # pixels
par3d(windowRect = 50 + c(0, 0, width, height))
view3d(theta=45, phi=25, zoom=0.4)
n.frames <- 200
N <- 10
x.entire.surface <- GriddedConvexHull(X=d.strain$X, spacing=0.6)

M.aniso$SetNoiseBounds(sigma.vals=2e-6)
L <- M.aniso$L(d=d.strain, X.out=x.entire.surface)
m.post <- M.aniso$PosteriorMean(d=d.strain, X.out=x.entire.surface)
time.mat <- (L %*% BubblingRandomMatrix(
n.pts=nrow(x.entire.surface), N=N, n.times=n.frames))
time.mat <- time.mat + as.vector(m.post)
for (i in 1:n.frames) {
  d.strain$Plot2D(dist.factor=0.15, max.points=Inf, Y.scale=500, clear=TRUE)
  PlotSurface(X=x.entire.surface, Y=time.mat[, i])
  rgl.snapshot(filename=sprintf('custom/steel_strain/steel_strain_%04d.png', i), top=TRUE)
}

rgl.close()
