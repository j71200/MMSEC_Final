classdef MPaillier
    %MPAILLIER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        CERTAINTY = 64;      % certainty with which primes are generated: 1-2^(-CERTAINTY)
        modLength;           % length in bits of the modulus n
        p;                   % a random prime
        q;                   % a random prime (distinct from p)
        lambda;              % lambda = lcm(p-1, q-1) = (p-1)*(q-1)/gcd(p-1, q-1)
        n;                   % n = p*q
        nsquare;             % nsquare = n*n
        g;                   % a random integer in Z*_{n^2}
        mu;                  % mu = (L(g^lambda mod n^2))^{-1} mod n, where L(u) = (u-1)/n
    end
    
    methods
        function MPaillier = MPaillier(modLengthIn) 
            MPaillier.modLength = modLengthIn;
            MPaillier.p = java.math.BigInteger(MPaillier.modLength / 2, MPaillier.CERTAINTY, java.util.Random);

            MPaillier.q = java.math.BigInteger(MPaillier.modLength / 2, MPaillier.CERTAINTY, java.util.Random); % a random prime (distinct from p)
            while MPaillier.q.compareTo(MPaillier.p)==0
                MPaillier.q = java.math.BigInteger(MPaillier.modLength / 2, MPaillier.CERTAINTY, java.util.Random); % a random prime (distinct from p)
            end

            % lambda = lcm(p-1, q-1) = (p-1)*(q-1)/gcd(p-1, q-1)
            tmp1 = (MPaillier.p.subtract(java.math.BigInteger.ONE).multiply(MPaillier.q.subtract(java.math.BigInteger.ONE)));
            tmp2 = MPaillier.p.subtract(java.math.BigInteger.ONE).gcd(MPaillier.q.subtract(java.math.BigInteger.ONE));
            MPaillier.lambda = tmp1.divide(tmp2);
            %obj.lambda = (obj.p.subtract(BigInteger.ONE).multiply(obj.q.subtract(BigInteger.ONE))).divide(obj.p.subtract(BigInteger.ONE).gcd(obj.q.subtract(BigInteger.ONE)));

            MPaillier.n = MPaillier.p.multiply(MPaillier.q);              % n = p*q
            MPaillier.nsquare = MPaillier.n.multiply(MPaillier.n);        % nsquare = n*n

            MPaillier.g = randomZStarNSquare(MPaillier);
            while (MPaillier.g.modPow(MPaillier.lambda, MPaillier.nsquare).subtract(java.math.BigInteger.ONE).divide(MPaillier.n).gcd(MPaillier.n).intValue() ~= 1)
                % generate g, a random integer in Z*_{n^2}
                MPaillier.g = randomZStarNSquare(MPaillier);
            end

            % mu = (L(g^lambda mod n^2))^{-1} mod n, where L(u) = (u-1)/n
            MPaillier.mu = MPaillier.g.modPow(MPaillier.lambda, MPaillier.nsquare).subtract(java.math.BigInteger.ONE).divide(MPaillier.n).modInverse(MPaillier.n);
        end
        function P = getP(obj)
            P = obj.p;
        end
        function Q = getQ(obj)
            Q = obj.q;
        end
        function Lambda = getLambda(obj)
            Lambda = obj.lambda;
        end
        function ModLength = getmodLength(obj)
            ModLength = obj.modLength;
        end
        function N = getN(obj)
            N = obj.n;
        end
        function Nsquare = getNsquare(obj)
            Nsquare = obj.nsquare;
        end
        function G = getG(obj)
            G = obj.g;
        end
        function Mu = getMu(obj)
            Mu = obj.mu;
        end
        function ciphertext = encrypt(obj, m)
            % if m is not in Z_n
            if (m.compareTo(java.math.BigInteger.ZERO) < 0 || m.compareTo(obj.n) >= 0)
                ciphertext = java.math.BigInteger.ONE;
            else 
                % generate r, a random integer in Z*_n
                r = randomZStarN(obj);

                % c = g^m * r^n mod n^2
                ciphertext =  (obj.g.modPow(m, obj.nsquare));
                ciphertext = ciphertext.multiply(r.modPow(obj.n, obj.nsquare));
                ciphertext = ciphertext.mod(obj.nsquare);
            end
        end
        function plaintext = decrypt(obj, c) 
            % if c is not in Z*_{n^2}
            if (c.compareTo(java.math.BigInteger.ZERO) < 0 || c.compareTo(obj.nsquare) >= 0 || c.gcd(obj.nsquare).intValue() ~= 1)
                plaintext = java.math.BigInteger.ONE;
            else
            % m = L(c^lambda mod n^2) * mu mod n, where L(u) = (u-1)/n
            plaintext =  c.modPow(obj.lambda, obj.nsquare).subtract(java.math.BigInteger.ONE).divide(obj.n).multiply(obj.mu).mod(obj.n);
            end        
        end
        
        % return a random integer in Z_n
        function r = randomZN(obj)
            r = java.math.BigInteger(obj.modLength, java.util.Random);
            while (r.compareTo(java.math.BigInteger.ZERO) <= 0 || r.compareTo(obj.n) >= 0)
                r = java.math.BigInteger(obj.modLength, java.util.Random);
            end
        end
        % return a random integer in Z*_n
        function r = randomZStarN(obj)
            r = java.math.BigInteger(obj.modLength, java.util.Random);
            while (r.compareTo(obj.n) >= 0 || r.gcd(obj.n).intValue() ~= 1)
                r = java.math.BigInteger(obj.modLength, java.util.Random);
            end
        end
        % return a random integer in Z*_{n^2}
        function r = randomZStarNSquare(obj)
            r = java.math.BigInteger(obj.modLength*2, java.util.Random);
            while (r.compareTo(obj.nsquare) >= 0 || r.gcd(obj.nsquare).intValue() ~= 1);
                r = java.math.BigInteger(obj.modLength*2, java.util.Random);
            end
        end
    end
end

