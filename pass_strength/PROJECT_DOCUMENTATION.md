# PassGuard — Project Documentation

## 1. Project title

**PassGuard: Password Strength Analyzer and Secure Password Generator Using Python and Tkinter**

## 2. Abstract

PassGuard is a local desktop application that helps users explore basic password hygiene. The project applies transparent, rule-based checks to a sample password and displays an educational score from 0 to 100, a strength label, and improvement suggestions. It also generates random passwords using the Python `secrets` module. A Tkinter graphical interface provides password input, show/hide controls, a visual strength meter, and clipboard copying. An alternative command-line menu supports the same two core operations. The project demonstrates Python programming, regular expressions, GUI development, and fundamental cybersecurity concepts. Its scoring is heuristic and does not replace a professional password security assessment.

## 3. Problem statement

Many users select short, common, or easily predicted passwords. Beginners may not understand how password length, reuse, and predictable patterns affect account security. PassGuard provides immediate, understandable feedback through a simple learning application.

## 4. Objectives

1. Build a password analyzer with a numeric score and strength category.
2. Provide clear recommendations when basic rules are not met.
3. Identify a limited set of common passwords and predictable patterns.
4. Generate randomized passwords securely using the standard library.
5. Provide both command-line and Tkinter graphical interfaces.
6. Practice organizing Python into reusable modules.

## 5. Technologies used

| Technology | Role |
| --- | --- |
| Python 3 | Application logic |
| Tkinter and ttk | Desktop interface and progress bar |
| `re` | Regular-expression pattern detection |
| `secrets` | Security-oriented random selection |
| `string` | Letter and digit collections |
| VS Code | Code editing and testing |

## 6. System architecture

```text
                   +----------------------+
                   |        User          |
                   +----------+-----------+
                              |
                +-------------+-------------+
                |                           |
      +---------v----------+     +----------v---------+
      | Tkinter UI (gui.py)|     | CLI Menu (main.py)  |
      +---------+----------+     +----------+---------+
                |                           |
                +-------------+-------------+
                              |
           +------------------+-------------------+
           |                                      |
+----------v----------------+   +-----------------v----------------+
| password_checker.py       |   | password_generator.py           |
| - length and type checks  |   | - secrets-based random choice   |
| - common string detection |   | - required character categories |
| - 0-100 score + feedback  |   | - secure shuffle                |
+---------------------------+   +----------------------------------+
```

## 7. Modules

### 7.1 Password checker (`password_checker.py`)

The checker evaluates minimum length, lowercase letters, uppercase letters, digits, and symbols. It awards points by rule, checks a small collection of common passwords, caps scores when specific patterns appear, and returns a tuple:

```python
(score, strength, suggestions)
```

The score categories are **Weak (0–49)**, **Moderate (50–79)**, and **Strong (80–100)**.

### 7.2 Password generator (`password_generator.py`)

The generator uses `secrets.choice()` to choose characters and `secrets.SystemRandom().shuffle()` to randomize their positions. It ensures at least one uppercase letter, lowercase letter, digit, and symbol, with a minimum requested length of 12. The GUI requests a generated password of length 16.

### 7.3 Command-line interface (`main.py`)

The command-line interface repeats a menu: check password strength, generate a password, or exit. It handles nonnumeric generator-length input with `try/except`.

### 7.4 Graphical interface (`gui.py`)

The Tkinter GUI contains a masked password entry, Show/Hide button, Check Strength button, rating label, progress bar, feedback label, Generate Password button, and Copy Password button.

## 8. Password analysis algorithm

1. Accept an example password.
2. Initialize `score = 0` and an empty list of suggestions.
3. Add a length-tier score (15 at 8+, 30 at 12+, 40 at 16+).
4. Add 10 points for each character category present.
5. Add another 20 points if the length is at least 12.
6. Set the score to zero for an exact common-password match.
7. Cap the score at 30 for the specified predictable substrings.
8. Clamp the score to at most 100.
9. Map the score to Weak, Moderate, or Strong and return feedback.

**Note:** These rules are educational heuristics. They do not estimate realistic password cracking time.

## 9. Steps to run

1. Place `gui.py`, `main.py`, `password_checker.py`, and `password_generator.py` in the same folder.
2. Install Python 3 with Tkinter.
3. Open the project folder in Visual Studio Code.
4. Run `python -m tkinter` to check Tkinter availability.
5. Run `python gui.py` for the graphical application.
6. Alternatively run `python main.py` for the terminal application.

## 10. Test cases

| Test case | Input or action | Expected result |
| --- | --- | --- |
| T1 | Empty GUI input | Warning dialog |
| T2 | `password123` | Zero score and warnings |
| T3 | A short sample | Weak or low strength label |
| T4 | Mixed long sample | Higher score |
| T5 | Generate | 16-character result shown in GUI |
| T6 | Show/Hide | Password masking switches |
| T7 | Copy | Current field value copied |
| T8 | CLI option 3 | Program ends |

These are *expected behaviors derived from the implementation*. Fill in pass/fail observations after running the tests locally.

## 11. Advantages

- Easy to understand and run locally.
- Python standard-library only.
- Clear separation of logic from interfaces.
- Demonstrates password-related security concepts.
- GUI and CLI versions are both available.

## 12. Limitations and security considerations

- The checker does not detect every weak or previously leaked password.
- Rule-based scores can be misleading; apparent complexity is not the same as unpredictability.
- The clipboard can retain copied sensitive text.
- The current implementation does not include automated tests or breach database integration.
- Do not enter actual credentials into demonstrations or publish secrets on GitHub.

## 13. Future scope

Potential extensions include unit tests, password-estimation libraries, optional breach checking with privacy protections, accessibility refinements, improved scoring explanations, and Windows executable packaging.

## 14. Conclusion

PassGuard combines Python fundamentals, a desktop GUI, basic rule-based password analysis, and secure random password generation in an approachable cybersecurity project. It is suitable for learning and demonstrations while making clear that its score is not a definitive measurement of password safety.
