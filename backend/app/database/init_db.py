from app.database.base import Base
from app.database.session import engine
from app.models.content import Content

# استيراد جميع الـ Models
from app.models.user import User
from app.models.learning_session import LearningSession


def init_db():
    Base.metadata.create_all(bind=engine)