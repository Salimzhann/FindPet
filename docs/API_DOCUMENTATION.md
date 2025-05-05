# SDUPM API Documentation

## Base URL
```
https://lost-found-for-pets-production.up.railway.app
```

## Authentication

### Register
- **Endpoint**: `/api/v1/auth/register`
- **Method**: `POST`
- **Description**: Register a new user
- **Request Body**:
  ```json
  {
    "email": "user@example.com",
    "full_name": "John Doe",
    "phone": "+12345678901",
    "password": "securepassword"
  }
  ```
- **Response**:
  ```json
  {
    "message": "Registration successful"
  }
  ```

### Verify Email
- **Endpoint**: `/api/v1/auth/verify`
- **Method**: `POST`
- **Description**: Verify user email with code
- **Request Body**:
  ```json
  {
    "email": "user@example.com",
    "code": "123456"
  }
  ```
- **Response**:
  ```json
  {
    "message": "Email verified successfully"
  }
  ```

### Login
- **Endpoint**: `/api/v1/auth/login`
- **Method**: `POST`
- **Description**: Authenticate user and get token
- **Request Body**:
  ```json
  {
    "email": "user@example.com",
    "password": "securepassword"
  }
  ```
- **Response**:
  ```json
  {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "token_type": "bearer"
  }
  ```

## Pets

### Get Lost Pets
- **Endpoint**: `/api/v1/pets/lost`
- **Method**: `GET`
- **Description**: Get list of lost pets
- **Headers**: `Authorization: Bearer {token}`
- **Query Parameters**:
  - `page`: Page number (default: 1)
  - `limit`: Items per page (default: 10)
- **Response**: Array of Pet objects

### Get Found Pets
- **Endpoint**: `/api/v1/pets/found`
- **Method**: `GET`
- **Description**: Get list of found pets
- **Headers**: `Authorization: Bearer {token}`
- **Response**: Array of Pet objects

### Get Pet Details
- **Endpoint**: `/api/v1/pets/lost/{petId}`
- **Method**: `GET`
- **Description**: Get details of a lost pet
- **Headers**: `Authorization: Bearer {token}`
- **Response**: Pet object

### Search Pets
- **Endpoint**: `/api/v1/pets/search`
- **Method**: `POST`
- **Description**: Search for matching pets
- **Headers**: `Authorization: Bearer {token}`
- **Request**: `multipart/form-data`
  - `photo`: Image file
  - `species`: String (e.g., "dog", "cat")
  - `color`: String
  - `gender` (optional): String
  - `breed` (optional): String
  - `coordX` (optional): Double (longitude)
  - `coordY` (optional): Double (latitude)
  - `save` (optional): Boolean
- **Response**:
  ```json
  {
    "matches": [
      {
        "pet": {
          "id": 1,
          "name": "Max",
          "species": "dog",
          "breed": "Labrador",
          "age": 3,
          "color": "golden",
          "gender": "male",
          "distinctive_features": "White spot on chest",
          "last_seen_location": "Central Park",
          "photos": [
            {
              "id": 1,
              "pet_id": 1,
              "photo_url": "https://example.com/photos/1.jpg",
              "is_primary": true,
              "created_at": "2023-04-01T12:00:00.000000"
            }
          ],
          "status": "lost",
          "created_at": "2023-04-01T12:00:00.000000",
          "updated_at": "2023-04-01T12:00:00.000000",
          "lost_date": "2023-04-01T10:00:00.000000",
          "owner_id": 1
        },
        "similarity_score": 0.85
      }
    ]
  }
  ```

### Create Pet
- **Endpoint**: `/api/v1/pets`
- **Method**: `POST`
- **Description**: Create a new pet
- **Headers**: `Authorization: Bearer {token}`
- **Request**: `multipart/form-data`
  - `name`: String
  - `species`: String
  - `breed` (optional): String
  - `age` (optional): Integer
  - `color` (optional): String
  - `gender` (optional): String
  - `distinctive_features` (optional): String
  - `photos`: Array of image files
- **Response**: Pet object

### Update Pet
- **Endpoint**: `/api/v1/pets/{petId}`
- **Method**: `PATCH`
- **Description**: Update a pet
- **Headers**: `Authorization: Bearer {token}`
- **Request Body**:
  ```json
  {
    "name": "Updated Name",
    "status": "found"
  }
  ```
- **Response**: Updated Pet object

### Delete Pet
- **Endpoint**: `/api/v1/pets/{petId}`
- **Method**: `DELETE`
- **Description**: Delete a pet
- **Headers**: `Authorization: Bearer {token}`
- **Response**: No content

## Chats

### Get Chats
- **Endpoint**: `/api/v1/chats`
- **Method**: `GET`
- **Description**: Get list of user's chats
- **Headers**: `Authorization: Bearer {token}`
- **Response**: Array of Chat objects

### Get Chat
- **Endpoint**: `/api/v1/chats/{chatId}`
- **Method**: `GET`
- **Description**: Get a specific chat
- **Headers**: `Authorization: Bearer {token}`
- **Response**: Chat object

### Create Chat
- **Endpoint**: `/api/v1/chats`
- **Method**: `POST`
- **Description**: Create a new chat
- **Headers**: `Authorization: Bearer {token}`
- **Request Body**:
  ```json
  {
    "pet_id": 1,
    "user2_id": 2
  }
  ```
- **Response**: Chat object

### Get Chat Messages
- **Endpoint**: `/api/v1/chats/{chatId}/messages`
- **Method**: `GET`
- **Description**: Get messages in a chat
- **Headers**: `Authorization: Bearer {token}`
- **Response**: Array of ChatMessage objects

### Send Message
- **Endpoint**: `/api/v1/chats/{chatId}/messages`
- **Method**: `POST`
- **Description**: Send a message in a chat
- **Headers**: `Authorization: Bearer {token}`
- **Request Body**:
  ```json
  {
    "content": "Hello, I found your pet!"
  }
  ```
- **Response**: ChatMessage object

### Create Chat with First Message
- **Endpoint**: `/api/v1/chats/pet/{petId}/message`
- **Method**: `POST`
- **Description**: Create a chat and send first message
- **Headers**: `Authorization: Bearer {token}`
- **Request Body**:
  ```json
  {
    "message": "Hello, I think I found your pet."
  }
  ```
- **Response**:
  ```json
  {
    "chat_id": 1
  }
  ```

### Delete Chat
- **Endpoint**: `/api/v1/chats/{chatId}`
- **Method**: `DELETE`
- **Description**: Delete a chat
- **Headers**: `Authorization: Bearer {token}`
- **Response**: No content

## User Profile

### Get User Profile
- **Endpoint**: `/api/v1/users/me`
- **Method**: `GET`
- **Description**: Get current user profile
- **Headers**: `Authorization: Bearer {token}`
- **Response**: UserProfile object

### Update User Profile
- **Endpoint**: `/api/v1/users/me`
- **Method**: `PUT`
- **Description**: Update user profile
- **Headers**: `Authorization: Bearer {token}`
- **Request Body**:
  ```json
  {
    "full_name": "Updated Name",
    "phone": "+12345678901",
    "password": "newpassword"  // Optional
  }
  ```
- **Response**: Updated UserProfile object

### Delete Account
- **Endpoint**: `/api/v1/users/me`
- **Method**: `DELETE`
- **Description**: Delete user account
- **Headers**: `Authorization: Bearer {token}`
- **Response**: No content

## WebSocket API

### Connect to Chat WebSocket
- **Endpoint**: `/api/v1/ws/{chatId}?token={token}`
- **Protocol**: `WebSocket`
- **Description**: Real-time chat messaging

### WebSocket Message Types
- `text`: Regular chat message
- `typing_started`: User started typing
- `typing_ended`: User stopped typing
- `message_read`: Message has been read
- `user_online`: User came online
- `user_offline`: User went offline
- `system`: System message

### WebSocket Message Format
```json
{
  "message_type": "text",
  "content": "Hello!",
  "message_id": null,
  "user_id": null
}
```

## Data Models

### Pet
```json
{
  "id": 1,
  "name": "Max",
  "species": "dog",
  "breed": "Labrador",
  "age": 3,
  "color": "golden",
  "gender": "male",
  "distinctive_features": "White spot on chest",
  "last_seen_location": "Central Park",
  "photos": [
    {
      "id": 1,
      "pet_id": 1,
      "photo_url": "https://example.com/photos/1.jpg",
      "is_primary": true,
      "created_at": "2023-04-01T12:00:00.000000"
    }
  ],
  "status": "lost",
  "created_at": "2023-04-01T12:00:00.000000",
  "updated_at": "2023-04-01T12:00:00.000000",
  "lost_date": "2023-04-01T10:00:00.000000",
  "owner_id": 1,
  "owner_phone": "+12345678901"
}
```

### Chat
```json
{
  "id": 1,
  "pet_id": 1,
  "user1_id": 1,
  "user2_id": 2,
  "created_at": "2023-04-01T12:00:00.000000",
  "updated_at": "2023-04-01T12:00:00.000000",
  "last_message": {
    "id": 5,
    "content": "Hello, I found your pet!",
    "chat_id": 1,
    "sender_id": 2,
    "whoid": 2,
    "is_read": false,
    "created_at": "2023-04-01T12:05:00.000000"
  },
  "unread_count": 1,
  "pet_photo_url": "https://example.com/photos/1.jpg",
  "pet_name": "Max",
  "pet_status": "lost",
  "other_user_name": "John Doe"
}
```

### ChatMessage
```json
{
  "id": 1,
  "content": "Hello, I found your pet!",
  "chat_id": 1,
  "sender_id": 2,
  "whoid": 2,
  "is_read": false,
  "created_at": "2023-04-01T12:00:00.000000"
}
```

### UserProfile
```json
{
  "email": "user@example.com",
  "full_name": "John Doe",
  "phone": "+12345678901",
  "id": 1,
  "is_active": true,
  "is_verified": true,
  "created_at": "2023-04-01T12:00:00.000000"
}
```
