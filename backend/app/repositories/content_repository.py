from sqlalchemy.orm import Session

from app.models.content import Content


class ContentRepository:

    # =====================================================
    # Create
    # =====================================================

    @staticmethod
    def create(
        db: Session,
        content: Content,
    ) -> Content:

        db.add(content)
        db.commit()
        db.refresh(content)

        return content

    # =====================================================
    # Get By Session
    # =====================================================

    @staticmethod
    def get_by_session(
        db: Session,
        session_id: int,
    ) -> Content | None:

        return (
            db.query(Content)
            .filter(
                Content.session_id == session_id,
            )
            .first()
        )

    # =====================================================
    # Update
    # =====================================================

    @staticmethod
    def update(
        db: Session,
        content: Content,
    ) -> Content:

        db.commit()
        db.refresh(content)

        return content

    # =====================================================
    # Delete
    # =====================================================

    @staticmethod
    def delete(
        db: Session,
        content: Content,
    ):

        db.delete(content)
        db.commit()


# =====================================================
# Helpers
# =====================================================

def create_content(
    db: Session,
    content: Content,
):
    return ContentRepository.create(
        db,
        content,
    )


def get_content_by_session(
    db: Session,
    session_id: int,
):
    return ContentRepository.get_by_session(
        db,
        session_id,
    )