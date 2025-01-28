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

- [ ] Create new Flutter project
- [ ] Add dependencies in pubspec.yaml
- [ ] Setup feature-first folder structure
- [ ] Configure GoRouter
- [ ] Setup Riverpod providers
- [ ] Initialize SQLite database

### Authentication Feature

- [ ] Create admin data model
- [ ] Implement local authentication repository
- [ ] Create login screen
- [ ] Add form validation
- [ ] Implement auth state provider
- [ ] Add protected route navigation

### Queue Feature

- [ ] Create queue entry data model
- [ ] Implement queue repository
- [ ] Create queue list screen
- [ ] Add new entry form
- [ ] Implement queue state provider
- [ ] Add queue operations (add/remove)
- [ ] Create entry details view

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

Date: [Current Date]

### Today's Tasks
- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

### Completed Tasks
- [x] Completed task 1
- [x] Completed task 2

### Blockers/Issues
- List any blockers or issues encountered

### Notes
- Additional notes or observations
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
