from cryptography.hazmat.primitives import serialization, hashes
from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from base64 import b64encode, b64decode
from dotenv import load_dotenv
import os


class CryptoService:
    def __init__(self):
        self.private_key_dir = "keys"
        self.private_key_path = os.path.join(self.private_key_dir, "private_key.pem")
        self.passphrase = os.getenv("AI_PRIVATE_KEY_PASS")
        self.salt = os.getenv("AI_PRIVATE_KEY_SALT").encode()
        self.key_pair = self.get_key_pair()

    def get_key_pair(self):
        private_key = rsa.generate_private_key(
            public_exponent=65537, key_size=4096, backend=default_backend()
        )
        public_key = private_key.public_key()
        return private_key, public_key

    def get_secret_key(self, passphrase):
        kdf = PBKDF2HMAC(
            algorithm=hashes.SHA256(),
            length=32,
            salt=self.salt,
            iterations=65536,
            backend=default_backend(),
        )
        key = kdf.derive(passphrase.encode())
        return key

    def encrypt_private_key(self, private_key_bytes, passphrase):
        key = self.get_secret_key(passphrase)
        cipher = Cipher(
            algorithms.AES(key),
            modes.CFB8(b"0000000000000000"),
            backend=default_backend(),
        )
        encryptor = cipher.encryptor()
        return encryptor.update(private_key_bytes) + encryptor.finalize()

    def decrypt_private_key(self, encrypted_private_key_bytes, passphrase, iv):
        key = self.get_secret_key(passphrase)
        cipher = Cipher(algorithms.AES(key), modes.CFB8(iv), backend=default_backend())
        decryptor = cipher.decryptor()
        return decryptor.update(encrypted_private_key_bytes) + decryptor.finalize()

    def encrypt_data(self, data, public_key):
        cipher_text = public_key.encrypt(
            data.encode(),
            padding.OAEP(
                mgf=padding.MGF1(algorithm=hashes.SHA512()),
                algorithm=hashes.SHA512(),
                label=None,
            ),
        )
        return cipher_text

    def decrypt_data(self, encoded_string):
        encrypted_data = b64decode(encoded_string)
        private_key, _ = self.key_pair
        plain_text = private_key.decrypt(
            encrypted_data,
            padding.OAEP(
                mgf=padding.MGF1(algorithm=hashes.SHA1()),
                algorithm=hashes.SHA512(),
                label=None,
            ),
        )
        return plain_text.decode("utf-8")

    def get_public_key(self):
        _, public_key = self.key_pair
        public_key_bytes = public_key.public_bytes(
            encoding=serialization.Encoding.DER,
            format=serialization.PublicFormat.SubjectPublicKeyInfo,
        )
        return b64encode(public_key_bytes).decode("utf-8")
