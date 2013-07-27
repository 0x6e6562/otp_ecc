-module(otp_ecc).

-include_lib("public_key/include/public_key.hrl").

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

ecc_verification_test() ->
    
    %% Read the public and priavte key files (PEM encoded)

    {ok, PrivateBin} = file:read_file("../ecdsa.pem"),
    {ok, PublicBin} = file:read_file("../ecdsa.pub"),

    %% Decipher the public key

    [SPKI] = public_key:pem_decode(PublicBin),
    #'SubjectPublicKeyInfo'{algorithm = Der} = SPKI,
    
    RealSPKI = public_key:der_decode('SubjectPublicKeyInfo', Der),
    
    #'SubjectPublicKeyInfo'{
        subjectPublicKey = {_, Octets},
        algorithm = #'AlgorithmIdentifier'{ parameters = Params}
    } = RealSPKI,
     
    ECPoint = #'ECPoint'{point = Octets},

    %% The parser generates a tag called 'OTPEcpkParameters', but that might be a bug
    %% Use 'EcpkParameters' instead
    
    EcpkParametersPem = {'EcpkParameters', Params, not_encrypted},
    ECParams = public_key:pem_entry_decode(EcpkParametersPem),
    ECPublicKey = {ECPoint, ECParams},

    %% Decipher the private key

    [_OTPEcpkParamsPem, ECPrivateKeyPem] = public_key:pem_decode(PrivateBin),
    ECPrivateKey = public_key:pem_entry_decode(ECPrivateKeyPem),

    %% Create a random message to sign and verify

    Msg = crypto:rand_bytes(32),

    %% Sign the message with the private key

    Sig = public_key:sign(Msg, sha512, ECPrivateKey),

    %% Verify the signature with the public key

    ?assert(public_key:verify(Msg, sha512, Sig, ECPublicKey)).

-endif.