function [n_pk, g_pk, lambda_sk, mu_sk] = paillierKeygen(p, q)
% p = 17;
% q = 19;
phi = (p-1) * (q-1);

n = p * q;

g = n + 1;
mLambda = phi;
mMu = speedPowerMod(phi, phi-1, n);

n_pk = n;
g_pk = g;
lambda_sk = mLambda;
mu_sk = mMu;
end