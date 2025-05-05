SDUPM is a comprehensive iOS application designed to help reunite lost pets with their owners. The app provides a platform for pet owners to register their lost pets, while also allowing people who find lost pets to post information about them. Through advanced image recognition and matching algorithms, the app helps identify potential matches between lost and found pets.
Key Features

Lost & Found Pet Registry: Register lost pets or report found pets with detailed information
AI-Powered Pet Matching: Advanced image recognition to match lost and found pets
Real-time Chat: Direct communication between pet owners and finders
User Profiles: Manage your pet information and account details
Location Services: See pets lost or found in your vicinity
Search Functionality: Find pets by species, breed, color, and more

📋 Project Structure
The project follows a modular structure for better organization and maintainability:
SDUPM/
├── Modules/
│   ├── Chat/               - Chat functionality between users
│   ├── FindPet/            - Search and match pet functionality
│   ├── Main/               - Main application screens
│   ├── MyPets/             - User's pet management
│   ├── Profile/            - User profile management
│   ├── RegistrationViews/  - Authentication & registration
│   └── TapBarNavigation/   - Navigation structure
├── NetworkService/         - API communication layer
└── Resources/              - Assets and resources
🚀 Getting Started
Prerequisites

iOS 14.0+
Xcode 13.0+
Swift 5.5+
CocoaPods (for dependency management)

Installation

Clone the repository
bashgit clone https://github.com/Salimzhann/SDUPM.git

Install dependencies
bashcd SDUPM
pod install

Open the workspace file
bashopen SDUPM.xcworkspace

Build and run the project in Xcode

🧠 Technical Implementation
Architecture
The app follows the MVP (Model-View-Presenter) architectural pattern, providing a clean separation of concerns:

Model: Data structures and business logic
View: UI components and layouts
Presenter: Mediates between Model and View, handling user interactions

Key Components

NetworkServiceProvider: Handles all API communication
ChatPresenter/ChatViewController: Manages real-time chat functionality
FindPetPresenter/FindPetViewController: Handles pet search and matching
ProfilePresenter/ProfileView: Manages user profile information
Authentication: Secure login, registration, and email verification

Technologies Used

UIKit: For native iOS UI components
SnapKit: For programmatic Auto Layout constraints
WebSockets: For real-time chat communication
URLSession: For API communication
CoreLocation: For location-based services
AVFoundation: For camera integration

📊 Data Models
The app uses several key data models:

Pet: Contains pet details including species, breed, photos, and status
Chat: Manages conversation data between users
User: User profile and authentication information
PetMatch: Links between potentially matching pets with similarity scores

🔄 API Integration
The app communicates with a RESTful backend API for data persistence and retrieval:

Authentication API: User registration, login, and verification
Pets API: Create, read, update, and delete pet information
Chat API: Message management and WebSocket connections
Search API: Pet matching and search functionality

📃 Documentation
Detailed documentation is available in the /docs directory, including:

API documentation
Architecture overview
User flows
Development guidelines

✅ Testing
The project includes unit tests for key functionality. Run the tests in Xcode using Cmd+U.
🤝 Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

Fork the repository
Create your feature branch (git checkout -b feature/amazing-feature)
Commit your changes (git commit -m 'Add some amazing feature')
Push to the branch (git push origin feature/amazing-feature)
Open a Pull Request

# SDUPM Source Code

## Overview

This directory contains the source code for the SDUPM iOS application. The code is organized into modules to maintain clean separation of concerns and improve maintainability.

## Structure

```
src/
├── SDUPM/
│   ├── Modules/
│   │   ├── Chat/                  - Real-time messaging functionality
│   │   ├── FindPet/               - Pet search and matching
│   │   ├── Main/                  - Main app screens and navigation
│   │   ├── MyPets/                - User's pet management
│   │   ├── Profile/               - User profile and settings
│   │   ├── RegistrationViews/     - Authentication flows
│   │   └── TapBarNavigation/      - Tab-based navigation
│   │
│   ├── NetworkService/            - API communication layer
│   │   ├── Models/                - Data models for network responses
│   │   └── Services/              - Network service implementations
│   │
│   ├── Common/                    - Shared utilities and extensions
│   │   ├── Extensions/            - Swift extensions
│   │   ├── Protocols/             - Common protocols
│   │   └── Utilities/             - Helper classes
│   │
│   ├── Resources/                 - App resources
│   │   ├── Assets.xcassets/       - Image assets
│   │   ├── Fonts/                 - Custom fonts
│   │   └── Localization/          - Localized strings
│   │
│   └── Application/               - App setup code
│       ├── AppDelegate.swift
│       ├── SceneDelegate.swift
│       └── AppConfiguration.swift
│
└── SDUPMTests/                     - Test cases
    ├── ModuleTests/                - Tests for each module
    ├── NetworkTests/               - API and network tests
    └── IntegrationTests/           - End-to-end tests
```

## Module Architecture

Each module follows the MVP (Model-View-Presenter) pattern:

- **Models**: Data structures and business logic
- **Views**: UI components and controllers
- **Presenters**: Coordinate between models and views

### Example: Chat Module

```
Chat/
├── ChatListPresenter.swift         - Presenter for list of chats
├── ChatListViewController.swift    - View controller for chat list
├── ChatPresenter.swift             - Presenter for individual chat
├── ChatViewController.swift        - View controller for chat screen
├── ChatModels.swift                - Data models for chat
├── MessageCells.swift              - Custom cells for messages
└── CreateChatViewController.swift  - View for creating new chats
```

## Dependencies

The project uses several key dependencies:

- **SnapKit**: For programmatic Auto Layout constraints
- **URLSession**: For networking operations
- **WebSocket**: For real-time chat functionality
- **CoreLocation**: For location services

## Getting Started

1. Clone the repository
2. Install CocoaPods dependencies with `pod install`
3. Open `SDUPM.xcworkspace` in Xcode
4. Build and run the project

## Coding Guidelines

- Use Swift's native capabilities where possible
- Follow the MVP architectural pattern
- Maintain separation of concerns
- Write self-documenting code with clear naming
- Add comments for complex logic
- Follow Swift style guidelines

## Adding New Features

When adding new features:

1. Create a new module if needed
2. Implement the Model, View, and Presenter components
3. Connect with the NetworkService layer if required
4. Add unit tests for the new functionality
5. Update documentation

## Contribution

Please see the root-level README.md for contribution guidelines.

📝 License
This project is licensed under the MIT License - see the LICENSE file for details.
📞 Contact
Project Maintainer - manassalimzhan04@gmail.com

Made with ❤️ by the Manas Salimzhan
