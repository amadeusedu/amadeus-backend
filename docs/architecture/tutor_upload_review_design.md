# Tutor Upload Portal Data Models

## uploads table
- **id** (PK)
- **userId** (FK to users)
- **fileName** (string)
- **status** (enum: `pending`, `complete`)
- **metadata** (JSON or text)
- **createdAt**, **updatedAt** (timestamps)

## reviews table
- **id** (PK)
- **uploadId** (FK to uploads)
- **status** (enum: `pending`, `approved`, `rejected`)
- **reviewerId** (FK to users)
- **comments** (text)
- **createdAt**, **reviewedAt** (timestamps)
