

from app.services.fingerprint_service import FingerprintService


service = FingerprintService()

text1 = "قانون نيوتن الثاني"

text2 = "   قانون   نيوتن   الثاني   "

hash1 = service.content_hash(text1)

hash2 = service.content_hash(text2)

print(hash1)

print(hash2)

print(hash1 == hash2)