function [n_uint, g_uint, lambda_uint, mu_uint] = paillierKeygen(p_uint, q_uint)
% p_uint = 17;
% q_uint = 19;
phi_uint = (p_uint-1) * (q_uint-1);

n_uint = p_uint * q_uint;

g_uint = n_uint + 1;
lambda_uint = phi_uint;
mu_uint = fastPowerMod(phi_uint, phi_uint-1, n_uint);

% n_pk = n_uint;
% g_pk = g_uint;
% lambda_sk = lambda_uint;
% mu_sk = mu_uint;
end