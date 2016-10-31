
data {
  int<lower=0> T;
  real x0;
  real x[T];
}

parameters {
  real alpha;
  real<lower=0> s2;
  real<lower=-1,upper=1> phi;
}

transformed parameters {
  real mu[T];

  mu[1] = x0;
  for (i in 2:T)
    mu[i] = alpha + phi*mu[i-1];
}

model {
  s2 ~ inv_gamma(0.0001, 0.0001);
  phi ~ uniform(-1, 1);

  for (i in 1:T)
    x[i] ~ normal(mu[i], s2);
}

