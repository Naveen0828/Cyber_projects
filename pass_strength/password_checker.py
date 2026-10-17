
import re

COMMON_PASSWORDS = {
    "password", "password123", "123456",
    "12345678", "123456789", "qwerty",
    "admin", "admin123", "letmein",
    "welcome", "iloveyou", "abc123"
}

def check_password(password):
    score = 0
    suggestions = []

    if len(password) >= 16:
        score += 40
    elif len(password) >= 12:
        score += 30
    elif len(password) >= 8:
        score += 15
    else:
        suggestions.append("Use at least 12 characters.")

    if re.search(r"[a-z]", password):
        score += 10
    else:
        suggestions.append("Add lowercase letters.")

    if re.search(r"[A-Z]", password):
        score += 10
    else:
        suggestions.append("Add uppercase letters.")

    if re.search(r"\d", password):
        score += 10
    else:
        suggestions.append("Add numbers.")

    if re.search(r"[^a-zA-Z0-9]", password):
        score += 10
    else:
        suggestions.append("Add special characters.")

    if len(password) >= 12:
        score += 20

    if password.lower() in COMMON_PASSWORDS:
        score = 0
        suggestions.append("Avoid common passwords!")

    if re.search(r"1234|abcd|qwerty|password", password.lower()):
        score = min(score, 30)
        suggestions.append("Avoid predictable patterns.")

    score = min(score, 100)

    if score >= 80:
        strength = "Strong"
    elif score >= 50:
        strength = "Moderate"
    else:
        strength = "Weak"

    return score, strength, suggestions
