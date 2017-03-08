#!/usr/bin/python

import sys
import base64

cleartext = sys.argv[1]

while len(cleartext) % 12 != 0:
    cleartext += chr(0x00)

decryption_key = [0x7d, 0x89, 0x52, 0x23, 0xd2, 0xbc, 0xdd, 0xea, 0xa3, 0xb9, 0x1f]

i = 0
cryptotext = ""

for ch in cleartext:
    b = ord(ch) ^ decryption_key[i]
    cryptotext += chr(b)
    i += 1
    i = i % len(decryption_key)

result = base64.b64encode(cryptotext)


print("Shared Secret: %s" %(result))
