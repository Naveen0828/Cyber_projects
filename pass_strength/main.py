
from password_checker import check_password
from password_generator import generate_password

def main():
    while True:
        print("\n===== PASSGUARD =====")
        print("1. Check Password Strength")
        print("2. Generate Secure Password")
        print("3. Exit")

        choice = input("\nEnter your choice: ")

        if choice == "1":
            print("\nUse sample passwords only.")
            password = input("Enter sample password: ")

            score, strength, suggestions = check_password(password)

            print("\n----- PASSWORD ANALYSIS -----")
            print(f"Strength Score: {score}/100")
            print(f"Strength Level: {strength}")

            if suggestions:
                print("\nSecurity Recommendations:")
                for suggestion in suggestions:
                    print("-", suggestion)
            else:
                print("No basic issues detected.")

        elif choice == "2":
            try:
                length = int(input("Enter password length: "))
                password = generate_password(length)
                print("Generated Password:", password)
            except ValueError:
                print("Please enter a valid number.")

        elif choice == "3":
            print("Thank you for using PassGuard!")
            break

        else:
            print("Invalid choice. Try again.")


if __name__ == "__main__":
    main()
