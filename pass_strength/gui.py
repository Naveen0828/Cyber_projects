
import tkinter as tk
from tkinter import ttk, messagebox
from password_checker import check_password
from password_generator import generate_password

root = tk.Tk()
root.title("PassGuard - Password Security Tool")
root.geometry("520x530")
root.configure(bg="#101827")
root.resizable(False, False)

def check_strength():
    password = password_entry.get()

    if not password:
        messagebox.showwarning("Warning", "Enter a sample password!")
        return

    score, strength, suggestions = check_password(password)

    score_label.config(text=f"Strength: {strength} ({score}/100)")
    progress["value"] = score

    if score >= 80:
        progress.configure(style="Green.Horizontal.TProgressbar")
    elif score >= 50:
        progress.configure(style="Orange.Horizontal.TProgressbar")
    else:
        progress.configure(style="Red.Horizontal.TProgressbar")

    if suggestions:
        feedback.config(text="\n".join("• " + s for s in suggestions))
    else:
        feedback.config(text="No basic issues detected.")

def generate():
    password = generate_password(16)
    password_entry.delete(0, tk.END)
    password_entry.insert(0, password)
    check_strength()

def toggle_password():
    if password_entry.cget("show") == "*":
        password_entry.config(show="")
        show_button.config(text="Hide")
    else:
        password_entry.config(show="*")
        show_button.config(text="Show")

def copy_password():
    password = password_entry.get()
    if not password:
        messagebox.showwarning("Warning", "No password to copy!")
        return

    root.clipboard_clear()
    root.clipboard_append(password)
    messagebox.showinfo("Copied", "Password copied to clipboard!")

tk.Label(
    root, text="PASSGUARD",
    font=("Arial", 25, "bold"),
    fg="#38bdf8", bg="#101827"
).pack(pady=25)

tk.Label(
    root, text="Password Strength Analyzer",
    font=("Arial", 12),
    fg="white", bg="#101827"
).pack()

password_entry = tk.Entry(
    root, width=31, font=("Arial", 14),
    show="*", justify="center"
)
password_entry.pack(pady=20)

show_button = tk.Button(root, text="Show", command=toggle_password)
show_button.pack()

tk.Button(
    root, text="CHECK STRENGTH",
    command=check_strength,
    bg="#2563eb", fg="white",
    font=("Arial", 11, "bold"),
    width=24
).pack(pady=15)

score_label = tk.Label(
    root, text="Strength: Not Checked",
    fg="white", bg="#101827",
    font=("Arial", 12)
)
score_label.pack(pady=5)

style = ttk.Style()
style.theme_use("default")
style.configure("Green.Horizontal.TProgressbar",
                background="#22c55e")
style.configure("Orange.Horizontal.TProgressbar",
                background="#f59e0b")
style.configure("Red.Horizontal.TProgressbar",
                background="#ef4444")

progress = ttk.Progressbar(
    root, length=350,
    maximum=100,
    style="Green.Horizontal.TProgressbar"
)
progress.pack(pady=10)

feedback = tk.Label(
    root, text="Security suggestions will appear here.",
    fg="#facc15", bg="#101827",
    font=("Arial", 10),
    wraplength=440, justify="center"
)
feedback.pack(pady=12)

tk.Button(
    root, text="GENERATE PASSWORD",
    command=generate,
    bg="#16a34a", fg="white",
    font=("Arial", 11, "bold"),
    width=24
).pack(pady=8)

tk.Button(
    root, text="COPY PASSWORD",
    command=copy_password,
    bg="#475569", fg="white",
    font=("Arial", 11, "bold"),
    width=24
).pack(pady=5)

root.mainloop()
