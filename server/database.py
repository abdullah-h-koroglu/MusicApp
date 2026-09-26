from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql://postgres:test1234@127.0.0.1:5432/musicapp"

engine = create_engine(DATABASE_URL, connect_args={"connect_timeout": 5})

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

def get_db():
   db = SessionLocal()
   try: 
      yield db
   finally: 
      db.close()