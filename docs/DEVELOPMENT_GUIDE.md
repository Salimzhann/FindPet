# Development Guide

## Development Environment Setup

### Required Tools
- macOS Monterey (12.0) or newer
- Xcode 14.0 or newer
- CocoaPods 1.11.0 or newer
- Git 2.30.0 or newer

### Setting Up the Development Environment

1. **Clone the Repository**
   ```bash
   git clone https://github.com/Salimzhann/FindPetApp_13P.git
   cd FindPetApp_13P

Install Dependencies
bashpod install

Open the Workspace
bashopen SDUPM.xcworkspace


Coding Standards
Swift Style Guide
We follow the Swift API Design Guidelines with the following additional rules:
Naming Conventions

Use camelCase for variable and function names
Use PascalCase for type names (classes, structs, enums, protocols)
Use descriptive names that clarify intention

swift// Good
let petProfileImage = UIImage(named: "pet_profile")
func updatePetStatus(status: String) { ... }

// Bad
let img = UIImage(named: "pet_profile")
func update(s: String) { ... }
File Organization

One class/struct/enum per file
Group related files in directories
Follow the MVP architecture pattern

Code Formatting

Use 4 spaces for indentation
Maximum line length: 100 characters
Add empty line between methods
Group class contents in the following order:

Properties
Initialization
Lifecycle methods (viewDidLoad, etc.)
Public methods
Private methods
Extensions



Commit Message Guidelines
Follow the conventional commits format:
<type>(<scope>): <description>

[optional body]

[optional footer]
Types:

feat: New feature
fix: Bug fix
docs: Documentation changes
style: Code style changes (formatting, etc.)
refactor: Code refactoring without functionality changes
test: Adding or modifying tests
chore: Build process or tool changes

Example:
feat(chat): implement real-time message delivery

- Add WebSocket connection management
- Implement message serialization
- Add UI for real-time message updates

Fixes #123
Git Workflow
We use a modified Git Flow workflow:

Main Branches

main: Production-ready code
develop: Integration branch for ongoing development


Supporting Branches

feature/: New features (branch from develop)
bugfix/: Bug fixes (branch from develop)
release/: Release preparation (branch from develop)
hotfix/: Production fixes (branch from main)


Pull Request Process

Create a PR with a clear description of changes
Include relevant issue numbers
Ensure all tests pass
Request review from at least one team member
Squash commits when merging
