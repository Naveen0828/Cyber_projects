
import secrets
import string

def generate_password(length=16):
    if length < 12:
        return "Password length must be at least 12."

    uppercase = string.ascii_uppercase
    lowercase = string.ascii_lowercase
    digits = string.digits
    symbols = "!@#$%^&*"

    all_chars = uppercase + lowercase + digits + symbols

    password = [
        secrets.choice(uppercase),
        secrets.choice(lowercase),
        secrets.choice(digits),
        secrets.choice(symbols)
    ]

    for i in range(length - 4):
        password.append(secrets.choice(all_chars))

    secrets.SystemRandom().shuffle(password)

    return "".join(password)


if __name__ == "__main__":
    length = int(input("Enter password length: "))
    print("Generated Password:", generate_password(length))
