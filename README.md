# 📰 AirFiAssessment - iOS News Panel App

A lightweight iOS application built using **Swift, MVVM architecture**, and **CoreData** for offline persistence. This app simulates a basic news panel experience with **role-based access (Author/Reviewer)** and **sync-first data fetching**.

---

**Features**

###  Role-based Login
- **Author:** Login with username `"Robert"`  
- **Reviewer:** Login with any username except `"Robert"`

  <img width="100" height="200" alt="image" src="https://github.com/user-attachments/assets/35a6b692-713b-4b94-a856-da22dc787bff" />


### Offline Support
- All articles are stored in CoreData for full offline functionality.
- App prompts to sync if no data exists.

### Sync Button (Login Screen)
- Fetches all article IDs and details (mock API).
- Compares and merges local vs server data based on version.
- Saves updated data locally and pushes back to server.
- <img width="100" height="200" alt="image" src="https://github.com/user-attachments/assets/dba3c1cc-2807-448e-9cb3-5d392ffa6cf6" />


### ✅ News List Screen

#### 🔹 For Reviewer
- Grouped by Author name.
- Supports pagination (5 articles at a time).
- Checkbox to select articles.
- "Mark Approve" button to append current user to the `approvedBy` list.

<img width="100" height="200" alt="image" src="https://github.com/user-attachments/assets/557fd109-30df-44ee-84d2-3879b13187fc" />

On Scroll 
<img width="100" height="200" alt="image" src="https://github.com/user-attachments/assets/e29f0c24-63ee-4d97-bc8b-2a7dc84468cf" />



####  For Author
- Displays author’s own articles.
- Shows short description and approval count.

<img width="100" height="200" alt="image" src="https://github.com/user-attachments/assets/f4546a14-2603-4a09-9a11-99f713eec062" />





###  Detail Screen
- Tapping an article navigates to a detailed view.

- <img width="100" height="200" alt="image" src="https://github.com/user-attachments/assets/65b15df6-6dc8-4d93-b46d-7e42b30005e3" />


### ✅ Auto Sync (Bonus)
- Auto-syncs data on network reconnect.
- Displays toast messages on network changes.

---

## 🧱 Tech Stack

- **Language:** Swift 5
- **UI:** UIKit + Storyboards + XIBs
- **Architecture:** MVVM
- **Database:** CoreData
- **Networking:** Mock API simulation using closure + delay
- **Connectivity Monitoring:** `NWPathMonitor`
- **Toast Alerts:** Simple in-view `UILabel` fade animation

---

## 🔁 Mock API Behavior

Simulated via:
- `fetchArticleIDs()` – returns a list of IDs
- `fetchArticle(by:)` – returns full article data
- `updateArticles(_:)` – prints the updated data to console

---

## Usage

1. **Launch app**
2. **Auto Sync when launching the app**
3. **Click "Sync"** to simulate data fetch
4. **Login** as either Author (`Robert`) or Reviewer
5. **Explore articles** and approve them as needed
6. **Use network toggling** to observe auto-sync and toast alerts



