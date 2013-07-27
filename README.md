# ECC Example

This is an example of how to sign and verify data with an EC key pair using Erlang/OTP.

## Prerequisites

* openssl
* R16B01 or higher (ECC support was first introduced in this patch level)

## Method

This example uses rebar to compile and run the code:

    $ rebar compile eunit

Some example private and public key files are supplied with this example.
If you would prefer to roll your own, these were the commands used to generate the keys:

    $ openssl ecparam -out ecdsa.pem -name sect571r1 -genkey
    $ openssl ec -in ecdsa.pem -pubout -out ecdsa.pub
