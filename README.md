# Project Conversation History

## Description
This Rails application allows users to create projects, leave comments, and change project statuses. It provides a conversation history that lists both comments and status changes chronologically.

## Setup

### Prerequisites
- Ruby 3.3.5
- PostgreSQL

### Installation
1. Clone the repository:
   ```
   git clone git@github.com:mkustov/project_conversation_history.git
   cd project_conversation_history
   ```

2. Install dependencies:
   ```
   bundle install
   ```

3. Set up the database:
   ```
   rails db:create db:migrate
   ```

4. Start the server:
   ```
   rails server
   ```

The application should now be running at `http://localhost:3000`.

## Testing
This project uses RSpec for testing. To run the test suite:
```
rspec
```

## Features
- Create projects with title, description, and status
- Change project status (Ready, In Progress, Completed)
- Add comments to projects
- View conversation history (comments and status changes) in chronological order

## Qestions and considerations

Q: What attributes should a project have besides status?
A: It should have a title and description.

Q: What are the possible status options for a project?
A: 'Ready', 'In Progress', 'Completed'.

Q: Should comments be associated with status changes, or can they be independent?
A: Comments can be independent.

Q: Do we need different roles for users?
A: No need for different roles for now.

Q: Do we need user authentication for this feature?
A: Projects can be created without authentication, but status changes and commenting require authentication.

Q: Do we need to implement any kind of notifications for new comments or status changes?
A: Notifications are out of scope due to time constraints.

Q: Are there any performance considerations, like pagination for comments?
A: Start without pagination; consider adding it later.

Q: Should we implement any kind of moderation for comments?
A: No moderation for now.

Q: How should the conversation history be displayed?
A: We should display comments and status changes together in chronological order.

Q: Is it possible to edit comments?
A: No, comments are immutable to preserve the integrity of the conversation.
