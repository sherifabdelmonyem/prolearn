from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    # =====================================================
    # Application
    # =====================================================

    app_name: str = "ProLearn"
    version: str = "2.0.0"
    debug: bool = True
    API_V1_PREFIX: str = "/api/v1"

    # =====================================================
    # Database
    # =====================================================

    database_url: str

    # =====================================================
    # Redis
    # =====================================================

    redis_url: str = "redis://localhost:6379"

    # =====================================================
    # JWT Authentication
    # =====================================================

    secret_key: str

    algorithm: str = "HS256"

    token_expire_minutes: int = 60

    refresh_token_expire_days: int = 30

    # =====================================================
    # AI
    # =====================================================

    openai_api_key: str = ""

    elevenlabs_api_key: str = ""

    # =====================================================
    # WhatsApp
    # =====================================================

    whatsapp_token: str = ""

    model_config = SettingsConfigDict(
        env_file=".env",
        case_sensitive=False,
        extra="ignore",
    )


@lru_cache
def get_settings():
    return Settings()


settings = get_settings()