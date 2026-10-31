from app.database.base import Base
from app.database.session import engine

# Import all models
from app.models.user import User
from app.models.student import Student
from app.models.teacher import Teacher
from app.models.classroom import Classroom
from app.models.subject import Subject
from app.models.unit import Unit
from app.models.lesson import Lesson
from app.models.content import Content
from app.models.learning_session import LearningSession
from app.models.grade import Grade
from app.models.semester import Semester
from app.models.academic_year import AcademicYear


def init_db():
    Base.metadata.create_all(bind=engine)