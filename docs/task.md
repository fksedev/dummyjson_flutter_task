Small test task (about 1-2 hours):
Build a small Flutter app against the public API https://dummyjson.com:
- Login screen (POST /auth/login, test user: emilys / emilyspass), store the token securely
- After login: product list (GET /products) with loading, error and empty states, pull-to-refresh and pagination
- Tapping a product opens a detail page
- Clean structure (your choice of architecture and state management) plus a short README explaining your decisions