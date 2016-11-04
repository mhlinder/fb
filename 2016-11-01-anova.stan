
data {
  int<lower=1> N;
  int<lower=1> k;

  real y[N];
  matrix[N,k] X;
}

parameters {
  real<lower=0> s2;
  vector[k] tau;
}

model {
  tau ~ normal(750, 250^2);
  s2 ~ inv_gamma(.0001, .0001);

  y ~ normal(X * tau, s2);
}

