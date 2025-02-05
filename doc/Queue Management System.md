# Queue Management System - Technical Specification Document

## Project Overview

A local queue management system built with Flutter, following a feature-first architecture. The system allows a single admin user to manage a queue of people through a simple interface.

## Technical Stack

- **Framework**: Flutter
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Local Storage**: SQLite
- **Architecture**: Feature-first approach (following CodeWithAndrea's guidelines)

## Features

### 1. Authentication

- Simple email/password authentication
- Single admin user (credentials stored locally)
- Protected routes using GoRouter
- Auto-login if previously authenticated

### 2. Queue Management

- View current queue
- Add person to queue
- Remove person from queue
- View person details
- Edit person details (if needed)

### 3. Person Details

Required fields for each person in queue:

- Full Name
- Phone Number
- Queue Number (auto-generated)
- Timestamp Added
- Optional Notes

## Project Structure

```
lib/
├── src/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   ├── application/ 
│   │   │   └── presentation/
│   │   └── queue/
│   │       ├── data/
│   │       ├── domain/
│   │       ├── application/
│   │       └── presentation/
│   ├── constants/
│   ├── router/
│   ├── utils/
│   └── common_widgets/
└── main.dart
```

## Database Schema

```sql
-- Admin Table
CREATE TABLE admin (
    id TEXT PRIMARY KEY,
    email TEXT NOT NULL,
    password TEXT NOT NULL
);

-- Queue Table
CREATE TABLE queue_entries (
    id TEXT PRIMARY KEY,
    full_name TEXT NOT NULL,
    phone_number TEXT NOT NULL,
    queue_number INTEGER NOT NULL,
    timestamp INTEGER NOT NULL,
    notes TEXT
);
```

## Implementation Tasks

### Setup Phase

- [x] Create new Flutter project
- [x] Add dependencies in pubspec.yaml
- [x] Setup feature-first folder structure
- [x] Configure GoRouter
- [x] Setup Riverpod providers
- [x] Initialize SQLite database

### Authentication Feature

- [x] Create admin data model
- [x] Implement local authentication repository
- [x] Create login screen
- [x] Add form validation
- [ ] Implement auth state provider
- [x] Add protected route navigation
- [ ] Setup authentication service class
- [ ] Integrate authentication service with UI

### Queue Feature

- [x] Create queue entry data model
- [x] Implement queue repository
- [x] Create queue list screen
- [x] Add new entry form
- [x] Implement queue state provider
- [ ] Add queue operations (add/remove)
- [x] Create entry details view
- [ ] Setup queue service class
- [ ] Integrate queue service with UI

### UI/UX

- [ ] Design and implement consistent theme
- [ ] Add loading indicators
- [ ] Implement error handling
- [ ] Add success/error messages
- [ ] Ensure responsive layout

## Required Dependencies

```yaml
  go_router: 
  hooks_riverpod:
  sqflite:
  flutter_hooks:
```

### Development Guidelines

1. **Code Organization**
   - Follow feature-first architecture
   - Keep features isolated and independent
   - Use shared widgets for common UI elements
   - Implement proper error handling

2. **State Management**
   - Use Riverpod for all state management
   - Implement proper state immutability
   - Handle loading and error states

3. **Database Operations**
   - Ensure database operations are handled in the data layer
   - Implement proper error handling
   - Add data validation

### Task Tracking Template

```markdown
## Daily Progress Tracker

Date: [1-2-2025]

### Today's Tasks
- [ ] Set up the SQLite database and configure local storage.
- [ ] Implement login screen and integrate AuthRepository for email/password validation.
- [ ] Set up initial queue screen and list entries.
- [ ] Configure GoRouter for routing, including protected routes.
- [ ] Test navigation to the Home page after a successful login.

### Completed Tasks
- [x] Completed task 1
- [x] Completed task 2
- [x] Completed task 3
- [x] Completed task 4
- [x] Completed task 5
### Blockers/Issues
- No blockers encountered so far.

### Notes
- Double-check the integration of GoRouter for protected routes to ensure only authenticated users can access the Home page.
- Test the flow from login to Home page and handle route transitions.
```

### MVP Deliverables Checklist

#### Phase 1: Foundation

- [ ] Project setup complete
- [ ] Database initialization working
- [ ] Basic navigation implemented
- [ ] Authentication flow working

#### Phase 2: Core Features

- [ ] Queue list view implemented
- [ ] Add to queue functionality working
- [ ] Remove from queue functionality working
- [ ] Person details view complete

#### Phase 3: Polish

- [ ] Error handling implemented
- [ ] Loading states added
- [ ] UI/UX improvements complete
- [ ] Basic testing completed

### Timeline

- Week 1: Setup and Authentication
- Week 2: Core Queue Features
- Week 3: UI Polish and Testing
- Week 4: Bug Fixes and Final Testing

### Success Criteria

1. Admin can successfully log in
2. Queue entries can be added and removed
3. All required person details are captured
4. UI is responsive and user-friendly
5. Data persists between app restarts
6. Basic error handling is implemented

### Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Riverpod Documentation](https://riverpod.dev)
- [CodeWithAndrea Flutter Architecture Guide](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/)
