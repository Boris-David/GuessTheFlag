# GuessTheFlag

GuessTheFlag is an engaging iOS educational game built with SwiftUI that tests your knowledge of world flags.

## How to Play

1.  **The Objective**: The game displays the name of a random country at the top of the screen.
2.  **The Choice**: Three different flags are shown below the name.
3.  **The Action**: Tap on the flag that belongs to the named country.
4.  **The Result**:
    *   **Correct**: You gain a point, and a success message appears.
    *   **Incorrect**: You are notified of the mistake, and the game continues.
5.  **Progression**: You can play endlessly. Your score and the total number of questions asked are tracked at the bottom.
6.  **Controls**:
    *   **Ask another question**: Skips the current round (tracked as a "skipped" question).
    *   **Reset counter**: Resets your score and question count to zero.

## Features

-   **Massive Flag Database**: Includes flags for over 190 countries, covering nearly the entire globe.
-   **Randomized Gameplay**: Every round offers a unique combination of countries and flags.
-   **Score Tracking**: Persistent tracking of user score vs. total questions attempted.
-   **Feedback System**: Instant visual alerts for correct or incorrect answers.
-   **Asset Generation**: Includes a custom Python script to fetch and format flag assets automatically.

## Technical Overview

-   **Language**: Swift 5+
-   **Framework**: SwiftUI
-   **Platform**: iOS 18.6+
-   **Architecture**: MVVM-style View structure.

### Automated Asset Generation

This project utilizes a Python script (`generate_flags.py`) to manage the extensive list of flag assets.

**How it works:**
1.  Downloads high-quality PNGs from `flagcdn.com`.
2.  Resizes images to `@2x` (400x200) and `@3x` (600x300) to strictly follow a 2:1 aspect ratio.
3.  Generates the Xcode-compatible `.imageset` directory structure and `Contents.json` files.
4.  Outputs the swift-compatible array of country names.

**To run the script:**
Ensure Python 3 is installed and run:
```bash
python3 generate_flags.py
```

## Installation

1.  Clone this repository.
2.  Open `GuessTheFlag.xcodeproj` in Xcode.
3.  Build and run on your Simulator or iPhone.