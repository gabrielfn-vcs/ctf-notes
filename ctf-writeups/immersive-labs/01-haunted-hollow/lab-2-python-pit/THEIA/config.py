class BaseConfig:
    """Base configuration"""
    TESTING = False
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = 'b3471d1a-993d-11eb-bacf-3bc0a276fa06'
    BCRYPT_LOG_ROUNDS = 4
    TOKEN_EXPIRATION_DAYS = 30
    TOKEN_EXPIRATION_SECONDS = 0
    SQLALCHEMY_DATABASE_URI = "sqlite:////opt/app/app.db"


class DevelopmentConfig(BaseConfig):
    """DevelopmentConfig"""


class TestingConfig(BaseConfig):
    """Testing configuration"""
    TESTING = True


class ProductionConfig(BaseConfig):
    """Production configuration"""
