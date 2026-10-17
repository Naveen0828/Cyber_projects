# PassGuard 🔐

**A Python desktop password strength checker and secure password generator built with Tkinter.**

PassGuard is a beginner-friendly cybersecurity project that evaluates sample passwords using a transparent, rule-based score, offers suggestions for improving them, and generates random passwords using Python's cryptographically secure `secrets` module.

> **Security notice:** The strength score is an educational heuristic, not a guarantee that a password is secure. Avoid entering real passwords when testing or taking screenshots. Passwords are not checked against known breach databases.

## Features

- **Password strength analysis:** Displays a 0–100 score and a Weak, Moderate, or Strong label.
- **Security recommendations:** Highlights missing character types, insufficient length, and some predictable patterns.
- **Common password checks:** Rejects a small built-in set of frequently used passwords.
- **Secure password generator:** Generates a random password (16 characters in the GUI) with uppercase, lowercase, digits, and symbols.
- **Desktop GUI:** Tkinter interface with a strength bar, show/hide option, and copy-to-clipboard button.
- **Command-line interface:** A simple three-option terminal menu.

## Tech stack

| Component | Technology |
| --- | --- |
| Language | Python 3 |
| Desktop interface | Tkinter / ttk |
| Password checking | Python `re` module |
| Password generation | Python `secrets` and `string` modules |
| Development environment | Visual Studio Code |

All application dependencies are part of the Python standard library. Tkinter must be available in your Python installation.

## Project structure

```text
PassGuard/
├── gui.py                  # Tkinter desktop interface
├── main.py                 # Command-line menu
├── password_checker.py     # Scoring and suggestions
├── password_generator.py   # Secure random password generation
├── requirements.txt        # No third-party packages required
├── README.md
├── docs/
│   └── PROJECT_DOCUMENTATION.md
└── screenshots/            # Add your own GUI screenshots
```

## Getting started

### Prerequisites

- Python 3.10 or newer recommended
- A Python installation with Tkinter support

Check the installations:

```powershell
python --version
python -m tkinter
```

The second command should open a small Tkinter test window.

### Run the GUI

Download or clone the project and open a terminal in its directory:

```powershell
python gui.py
```

### Run the terminal version

```powershell
python main.py
```

If `python` is not recognized on Windows, try `py` in its place. No `pip install` step is required for the standard-library version of this project.

## How to use

**Check a sample password**
1. Open the GUI with `python gui.py`.
2. Enter a **dummy/sample password**.
3. Click **CHECK STRENGTH** to see the score, rating, and suggestions.
4. Use **Show/Hide** to change password visibility.

**Generate a password**
1. Click **GENERATE PASSWORD** to create a 16-character password.
2. The generated value appears in the input field and is analyzed automatically.
3. Click **COPY PASSWORD** if you want to copy it to your clipboard. Clear the clipboard afterward if it contains a sensitive password.

## How scoring works

`password_checker.py` uses a rule-based scoring system:

| Rule | Points |
| --- | ---: |
| Length at least 8 / 12 / 16 characters | 15 / 30 / 40 (one length tier) |
| Contains lowercase letters | +10 |
| Contains uppercase letters | +10 |
| Contains digits | +10 |
| Contains special characters | +10 |
| Length at least 12 characters | +20 additional |

The final score is capped at 100. Exact matches in a small set of common passwords get a score of zero. Some recognizable patterns (`1234`, `abcd`, `qwerty`, `password`) cap the score at 30.

- **Weak:** 0–49
- **Moderate:** 50–79
- **Strong:** 80–100

These labels measure the project's chosen rules, **not** actual entropy, guessing resistance, or breach status.

## Testing

Try the application with **dummy strings only**:

| Test | Expected behavior |
| --- | --- |
| Empty input | GUI asks for a sample password |
| `password123` | Flagged as a common/predictable password |
| Short password | Low score and length recommendation |
| A lengthy, varied sample | Higher score and a longer strength bar |
| Generate button | Inserts a randomly generated 16-character password |
| Show/Hide | Toggles whether the input is masked |
| Copy | Copies the currently shown input to the clipboard |
| CLI option 3 | Exits the terminal application |

> A score of 100/100 is **not** proof of real-world password safety. Real passwords should be unique, difficult to guess, and protected with multi-factor authentication where available.

## Screenshots

Add your own images in `screenshots/`, then uncomment and update this line:

<!-- ![PassGuard GUI](screenshots/passguard-gui.png) -->

## Known limitations

- Rule-based scoring may reward predictable passwords that happen to contain varied character types.
- The built-in common-password list and pattern checks cover only a small number of examples.
- No compromised-password lookup is implemented.
- The GUI copies the displayed password to the operating-system clipboard, which may remain accessible to other applications.
- The GUI has a fixed window size and is intended as a local learning tool.

## Ideas for future improvements

- Use a dedicated password-estimation library for better guessability feedback.
- Add an optional privacy-preserving breached-password lookup.
- Expand the test suite with unit tests and boundary cases.
- Improve accessibility and responsive window layout.
- Package the app as a Windows executable.

## Responsible use

PassGuard is intended for **educational and personal learning**. Never commit passwords, secret keys, or sensitive screenshots to a public repository.

## License

No license has been specified yet. Add a `LICENSE` file if you want to define how others may reuse your code.
