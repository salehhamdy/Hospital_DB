# Hospital Management System

A simple **Hospital Management System** built with **Python (Tkinter)** for the desktop graphical user interface and **MySQL** for persistent storage.  The project demonstrates basic CRUD (Create, Read, Update, Delete) operations on a relational database through an easy‑to‑use GUI.

---

## Project Structure

| Path / File | Description |
|-------------|-------------|
| `Hospital Management System.sql` | SQL script that creates the database (`hospital_project`), tables (Patient, Doctor, Nurses, Department, Staff, Appointment, Admission, ERPatient, ORPatient) and seeds them with sample data. |
| `Final Mapping Hosbital.mwb` | MySQL Workbench model of the schema (handy for diagrams / further editing). |
| `HospitalGUI.py` | Main Tkinter application – lets you select a table and insert, update, delete or fetch records.  Columns are detected dynamically from the database. |
| `gui.py`, `guier.py` | Additional / experimental GUI scripts (optional).  Feel free to remove or merge as you refactor. |

> **Tip:** The GUI assumes the **first column** of every table is the primary‑key ID that uniquely identifies each record.

---

## Features

- **Dynamic form generation** – the GUI queries `DESCRIBE <table>` so the input fields always match the selected table.
- **Full CRUD** – Insert, Update, Delete, and Get operations for every table.
- **Sample data** – 30 patients, 12 doctors, 25 nurses, etc., already inserted so you can explore instantly.
- **Modular database design** – clear foreign‑key relationships with cascading updates/deletes.

---

## Prerequisites

| Requirement | Notes |
|-------------|-------|
| **Python 3.8+** | Tkinter ships with the standard library. |
| **MySQL Server 8.x** | Make sure it is running locally. |
| **mysql‑connector‑python** | Install with `pip install mysql-connector-python`. |
| (Optional) **MySQL Workbench** | To open the `.mwb` schema file. |

---

## Installation & Setup

1. **Clone or download** this repository.
2. Create a virtual environment (optional but recommended):
   ```bash
   python -m venv venv
   source venv/bin/activate  # Windows: venv\Scripts\activate
   ```
3. **Install dependencies**:
   ```bash
   pip install mysql-connector-python
   ```
4. **Create the database**:
   ```bash
   # From the MySQL console or any client
   SOURCE path/to/Hospital\ Management\ System.sql;
   ```
5. **Configure database credentials**:
   - In `HospitalGUI.py` (and any other GUI script) locate the lines like
     ```python
     con = mysql.connect(host="localhost", port=3306, user="root", password="Qwertyuiop12345^", database="hospital_project")
     ```
   - **Replace** `user` and `password` with your local MySQL user / password.
   - Alternatively, refactor to load credentials from environment variables for security.

---

## Running the Application

```bash
python HospitalGUI.py
```

1. Select a table from the **dropdown** (e.g. `Patient`).
2. Input data into the generated fields.
3. Click **Insert**, **Update**, **Delete**, or **Get** to perform the chosen action.
4. The **listbox** on the right always shows the latest records for the selected table.

> **Note:** To *update* or *delete*, enter the primary ID in the first field (e.g. `PatientID`) before clicking the button.

---

## Screenshots

_Add screenshots of the GUI here once the app is running._

---

## Troubleshooting

| Problem | Possible Fix |
|---------|--------------|
| "`mysql.connector.errors.InterfaceError: 2003: Can't connect to MySQL server`" | Check that MySQL is running and the host / port are correct. |
| "Foreign key constraint fails" on delete | The record you are deleting is referenced by another table – delete or update child records first. |
| Empty listbox after insert | Click **Insert** then **Get** (or toggle another table) to refresh, or enhance the code to refresh automatically. |

---

## Extending the Project

- Replace hard‑coded DB creds with environment variables.
- Add **user authentication & role‑based access control**.
- Switch to an **ORM** (e.g. SQLAlchemy) for cleaner data access.
- Package the app with **PyInstaller** to distribute as an executable.
- Write **unit tests** for database operations (use a test database).
- Migrate to a **web interface** (Flask / Django) for multi‑user access.

---

## License

This project is released under the MIT License – see **LICENSE** for details.

---
