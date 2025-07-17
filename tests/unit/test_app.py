import pytest
from src.app import app

@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

def test_home_status_code(client):
    response = client.get("/")
    assert response.status_code == 200

def test_home_content(client):
    response = client.get("/")
    # Make sure some part of the ASCII art or planet text is present in response
    assert b"+++++++" in response.data or b"planet" in response.data.lower()
