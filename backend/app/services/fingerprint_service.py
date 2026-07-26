

import hashlib
import re


class FingerprintService:
    """
    Generates fingerprints for files and educational content.
    """

    @staticmethod
    def file_hash(file_bytes: bytes) -> str:
        """
        SHA256 of raw file.
        """
        return hashlib.sha256(file_bytes).hexdigest()

    @staticmethod
    def normalize_text(text: str) -> str:
        """
        Normalize educational text before hashing.
        """

        text = text.lower()

        text = re.sub(r"\s+", " ", text)

        return text.strip()

    @staticmethod
    def content_hash(text: str) -> str:
        """
        SHA256 of normalized content.
        """

        normalized = FingerprintService.normalize_text(text)

        return hashlib.sha256(
            normalized.encode("utf-8")
        ).hexdigest()