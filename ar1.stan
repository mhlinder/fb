
data {
  int<lower=0> T;
  real x[T];
  real x0;
}

parameters {
  real alpha;
  real<lower=-1,upper=1> phi;
  real s2;
}

model {
  alpha ~ normal(750, 250^2);
  phi ~ uniform(-1, 1);
  s2 ~ inv_gamma(.0001, .0001);

  x[1] ~ normal(alpha + phi*x0, s2);
  for (t in 2:T)
    x[t] ~ normal(alpha + phi*x[t-1], s2);
}


