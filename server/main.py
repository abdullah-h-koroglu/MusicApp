import uvicorn
from fastapi import FastAPI
from routes import auth,song
from models.base import Base
from models import Favorite, Song, User
from database import engine

app = FastAPI()
app.include_router(auth.router,prefix='/auth')
app.include_router(song.router,prefix='/song')

Base.metadata.create_all(engine)

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)