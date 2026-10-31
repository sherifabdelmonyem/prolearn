from datetime import datetime, timedelta, timezone

from jose import JWTError
from jose import jwt

from passlib.context import CryptContext

from app.core.settings import settings

# ==========================================================
# Password Hashing
# ==========================================================

pwd_context = CryptContext(
    schemes=["bcrypt"],
    deprecated="auto",
)


def hash_password(password: str) -> str:
    return pwd_context.hash(password)


def verify_password(
    password: str,
    hashed_password: str,
) -> bool:
    return pwd_context.verify(
        password,
        hashed_password,
    )


# ==========================================================
# JWT
# ==========================================================

def create_access_token(data: dict) -> str:
    to_encode = data.copy()

    expire = datetime.now(
        timezone.utc,
    ) + timedelta(
        minutes=settings.token_expire_minutes,
    )

    to_encode.update(
        {
            "exp": expire,
        }
    )

    return jwt.encode(
        to_encode,
        settings.secret_key,
        algorithm=settings.algorithm,
    )


def decode_token(
    token: str,
):
    try:
        payload = jwt.decode(
            token,
            settings.secret_key,
            algorithms=[
                settings.algorithm,
            ],
        )

        return payload

    except JWTError:
        return None