
clear all;
Paillier = MPaillier(64);

plaintext1 = java.math.BigInteger('50');             
ciphertext1 = Paillier.encrypt(plaintext1);
Minus1 = Paillier.encrypt(Paillier.getN().subtract(plaintext1));
decodetext1 = Paillier.decrypt(Minus1);

plaintext2 = java.math.BigInteger('20');             
ciphertext2 = Paillier.encrypt(plaintext2);
decodetext2 = Paillier.decrypt(ciphertext2);

CiphertextP1P2 = Minus1.multiply(ciphertext2).mod(Paillier.getNsquare());
decodetextP1P2 = Paillier.decrypt(CiphertextP1P2)


	