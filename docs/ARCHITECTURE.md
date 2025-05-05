# SDUPM Architecture Documentation

## Overview

SDUPM follows the MVP (Model-View-Presenter) architectural pattern, which separates the application into three main components:

- **Model**: Data structures and business logic
- **View**: UI components and user interaction
- **Presenter**: Mediates between Model and View, handling the application logic

## System Architecture

### High-Level Architecture

```
┌────────────────┐     ┌────────────────┐     ┌────────────────┐
│                │     │                │     │                │
│      View      │◄────┤   Presenter    │◄────┤     Model      │
│                │     │                │     │                │
└────────────────┘     └────────────────┘     └────────────────┘
        ▲                                            ▲
        │                                            │
        └────────────────┐               ┌───────────┘
                         ▼               ▼
                    ┌────────────────────────────┐
                    │                            │
                    │     Network Services       │
                    │                            │
                    └────────────────────────────┘
                                 ▲
                                 │
                                 ▼
                    ┌────────────────────────────┐
                    │                            │
                    │          Backend           │
                    │                            │
                    └────────────────────────────┘
```

### Module Structure

Each feature in the application is organized into modules:

- **Chat Module**: Handles real-time messaging between users
- **Find Pet Module**: Manages pet search and matching functionality
- **My Pets Module**: User's pet management
- **Profile Module**: User profile and settings
- **Authentication Module**: Login, registration, and verification

### Data Flow

1. User interacts with the View
2. View notifies the Presenter about the interaction
3. Presenter processes the data and updates the Model if necessary
4. Model notifies the Presenter of changes
5. Presenter updates the View with the new state

## Network Communication

The application uses a combination of REST API calls and WebSockets:

- **REST API**: For most CRUD operations
- **WebSockets**: For real-time messaging in the chat feature

### API Endpoints

The application communicates with several key endpoints:

- `/api/v1/auth/` - Authentication endpoints
- `/api/v1/pets/` - Pet management endpoints
- `/api/v1/chats/` - Chat and messaging endpoints
- `/api/v1/users/` - User profile endpoints

## Component Details

### NetworkServiceProvider

Central component that handles all API communication:

- REST API requests
- Error handling
- Authentication token management
- Data serialization/deserialization

### Presenters

Each module has a dedicated presenter that handles the business logic:

- **ChatPresenter**: Manages real-time messaging
- **FindPetPresenter**: Handles pet search and matching
- **MyPetPresenter**: Manages user's pets
- **ProfilePresenter**: Handles user profile and settings

### ViewControllers

UI components that display data and capture user interactions:

- Collection views for lists of pets
- Table views for chat messages
- Forms for data entry
- Navigation structure

## Security

- JWT token-based authentication
- Secure storage of user credentials
- HTTPS for all API communications
- WebSocket security protocols

## Future Architectural Considerations

- Migration to SwiftUI for certain components
- Implementation of the Coordinator pattern for improved navigation
- Enhanced offline capability
- Modularization for better code organization
