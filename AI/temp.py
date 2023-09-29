import base64
import os
import requests

from cryptography.hazmat.primitives import serialization, hashes
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.backends import default_backend
from base64 import b64decode

from dotenv import load_dotenv


def encrypt_string_with_public_key(public_key_string, string_to_encrypt):
    # Convert the public key from a string back to a public key object
    public_key_bytes = b64decode(public_key_string)
    public_key = serialization.load_der_public_key(
        public_key_bytes, backend=default_backend()
    )

    # Encrypt the string using the public key
    cipher_text = public_key.encrypt(
        string_to_encrypt.encode(),
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA1()),
            algorithm=hashes.SHA512(),
            label=None,
        ),
    )

    return cipher_text


# Fetch the public key string from the endpoint
load_dotenv()
response = requests.get("http://127.0.0.1:6000/public-key")
data = response.json()
pks = data["public-key"]

print(base64.b64encode(encrypt_string_with_public_key(
    pks,
    os.getenv("KOJA_ID_SECRET")
)).decode("ascii"))

