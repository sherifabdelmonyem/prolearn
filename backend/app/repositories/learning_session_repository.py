from sqlalchemy.orm import Session

from app.models.learning_session import LearningSession


class LearningSessionRepository:

    # =====================================================
    # Create
    # =====================================================

    @staticmethod
    def create(
        db: Session,
        session: LearningSession,
    ) -> LearningSession:

        db.add(session)
        db.commit()
        db.refresh(session)

        return session

    # =====================================================
    # Get By Id
    # =====================================================

    @staticmethod
    def get_by_id(
        db: Session,
        session_id: int,
    ) -> LearningSession | None:

        return (
            db.query(LearningSession)
            .filter(
                LearningSession.id == session_id,
            )
            .first()
        )

    # =====================================================
    # Get User Sessions
    # =====================================================

    @staticmethod
    def get_user_sessions(
        db: Session,
        user_id: int,
    ):

        return (
            db.query(LearningSession)
            .filter(
                LearningSession.user_id == user_id,
            )
            .order_by(
                LearningSession.created_at.desc(),
            )
            .all()
        )

    # =====================================================
    # Update
    # =====================================================

    @staticmethod
    def update(
        db: Session,
        session: LearningSession,
    ) -> LearningSession:

        db.commit()
        db.refresh(session)

        return session

    # =====================================================
    # Delete
    # =====================================================

    @staticmethod
    def delete(
        db: Session,
        session: LearningSession,
    ):

        db.delete(session)
        db.commit()


# =====================================================
# Helpers
# =====================================================

def create_learning_session(
    db: Session,
    session: LearningSession,
):
    return LearningSessionRepository.create(
        db,
        session,
    )


def get_learning_session_by_id(
    db: Session,
    session_id: int,
):
    return LearningSessionRepository.get_by_id(
        db,
        session_id,
    )


def get_user_learning_sessions(
    db: Session,
    user_id: int,
):
    return LearningSessionRepository.get_user_sessions(
        db,
        user_id,
    )


def update_learning_session(
    db: Session,
    session: LearningSession,
):
    return LearningSessionRepository.update(
        db,
        session,
    )


def delete_learning_session(
    db: Session,
    session: LearningSession,
):
    return LearningSessionRepository.delete(
        db,
        session,
    )