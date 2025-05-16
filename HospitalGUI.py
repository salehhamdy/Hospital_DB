from tkinter import *
from tkinter import font
from tkinter import messagebox
import mysql.connector as mysql

# Function Definitions
def update_fields(table_name):
    try:
        con = mysql.connect(host="localhost", port=3306, user="root", password="Qwertyuiop12345^", database="hospital_project")
        cursor = con.cursor()
        cursor.execute(f"DESCRIBE {table_name}")
        columns = cursor.fetchall()
        con.close()
        
        for widget in entry_frame.winfo_children():
            widget.destroy()
        
        global entries
        entries = {}
        y_position = 30
        
        for column in columns:
            label = Label(entry_frame, text=column[0], font=('bold', 10))
            label.place(x=20, y=y_position)
            entry = Entry(entry_frame)
            entry.place(x=150, y=y_position)
            entries[column[0]] = entry
            y_position += 30
    except mysql.Error as err:
        messagebox.showerror("Fetch Status", f"Error: {err}")

def insert_record():
    table_name = table_list.get()
    if not table_name:
        messagebox.showinfo("Insert Status", "Table selection is required")
        return

    data = {col: entry.get() for col, entry in entries.items()}

    if any(val == "" for val in data.values()):
        messagebox.showinfo("Insert Status", "All Fields are required")
    else:
        try:
            con = mysql.connect(host="localhost", port=3306, user="root", password="Qwertyuiop12345^", database="hospital_project")
            cursor = con.cursor()
            placeholders = ", ".join(["%s"] * len(data))
            columns = ", ".join(data.keys())
            sql = f"INSERT INTO {table_name} ({columns}) VALUES ({placeholders})"
            cursor.execute(sql, tuple(data.values()))
            con.commit()
            clear_entries()
            show_records()
            messagebox.showinfo("Insert Status", "Inserted Successfully")
        except mysql.Error as err:
            messagebox.showerror("Insert Status", f"Error: {err}")
        finally:
            if con.is_connected():
                con.close()

def delete_record():
    table_name = table_list.get()
    if not table_name:
        messagebox.showinfo("Delete Status", "Table selection is required")
        return
    
    id = entries[list(entries.keys())[0]].get()  # Assuming the first column is the ID column
    if id == "":
        messagebox.showinfo("Delete Status", "ID is required for delete")
    else:
        try:
            con = mysql.connect(host="localhost", port=3306, user="root", password="Qwertyuiop12345^", database="hospital_project")
            cursor = con.cursor()
            cursor.execute(f"DELETE FROM {table_name} WHERE {list(entries.keys())[0]}=%s", (id,))
            con.commit()
            clear_entries()
            show_records()
            messagebox.showinfo("Delete Status", "Deleted Successfully")
        except mysql.Error as err:
            messagebox.showerror("Delete Status", f"Error: {err}")
        finally:
            if con.is_connected():
                con.close()

def update_record():
    table_name = table_list.get()
    if not table_name:
        messagebox.showinfo("Update Status", "Table selection is required")
        return

    data = {col: entry.get() for col, entry in entries.items()}
    id = entries[list(data.keys())[0]].get()  # Assuming the first column is the ID column

    if any(val == "" for val in data.values()):
        messagebox.showinfo("Update Status", "All Fields are required")
    else:
        try:
            con = mysql.connect(host="localhost", port=3306, user="root", password="Qwertyuiop12345^", database="hospital_project")
            cursor = con.cursor()
            set_clause = ", ".join([f"{col}=%s" for col in data.keys()])
            sql = f"UPDATE {table_name} SET {set_clause} WHERE {list(data.keys())[0]}=%s"
            cursor.execute(sql, tuple(data.values()) + (id,))
            con.commit()
            clear_entries()
            show_records()
            messagebox.showinfo("Update Status", "Updated Successfully")
        except mysql.Error as err:
            messagebox.showerror("Update Status", f"Error: {err}")
        finally:
            if con.is_connected():
                con.close()

def get_record():
    table_name = table_list.get()
    if not table_name:
        messagebox.showinfo("Fetch Status", "Table selection is required")
        return

    id = entries[list(entries.keys())[0]].get()  # Assuming the first column is the ID column
    if id == "":
        messagebox.showinfo("Fetch Status", "ID is required for fetch")
    else:
        try:
            con = mysql.connect(host="localhost", port=3306, user="root", password="Qwertyuiop12345^", database="hospital_project")
            cursor = con.cursor()
            cursor.execute(f"SELECT * FROM {table_name} WHERE {list(entries.keys())[0]}=%s", (id,))
            row = cursor.fetchone()

            if row:
                for col, val in zip(entries.keys(), row):
                    entries[col].insert(0, val)
            else:
                messagebox.showinfo("Fetch Status", "Record not found")
        except mysql.Error as err:
            messagebox.showerror("Fetch Status", f"Error: {err}")
        finally:
            if con.is_connected():
                con.close()

def show_records():
    table_name = table_list.get()
    if not table_name:
        return

    try:
        con = mysql.connect(host="localhost", port=3306, user="root", password="Qwertyuiop12345^", database="hospital_project")
        cursor = con.cursor()
        cursor.execute(f"SELECT * FROM {table_name}")
        rows = cursor.fetchall()
        listbox.delete(0, END)
        for row in rows:
            listbox.insert(END, row)
    except mysql.Error as err:
        messagebox.showerror("Fetch Status", f"Error: {err}")
    finally:
        if con.is_connected():
            con.close()

def clear_entries():
    for entry in entries.values():
        entry.delete(0, END)

# Main Window
root = Tk()
root.geometry("800x600")
root.title("Hospital Management System")

# Table selection
table_label = Label(root, text='Select Table', font=('bold', 10))
table_label.place(x=20, y=10)
table_list = StringVar()
table_dropdown = OptionMenu(root, table_list, *["Patient", "Department", "Doctor", "Nurses", "Staff", "Appointment", "Admission", "ERPatient", "ORPatient"], command=update_fields)
table_dropdown.place(x=150, y=10)

# Frame for Entry Widgets
entry_frame = Frame(root)
entry_frame.place(x=20, y=50, width=300, height=300)

# Buttons
insert_button = Button(root, text="Insert", font=("italic", 10), bg="white", command=insert_record)
insert_button.place(x=20, y=400)

delete_button = Button(root, text="Delete", font=("italic", 10), bg="white", command=delete_record)
delete_button.place(x=80, y=400)

update_button = Button(root, text="Update", font=("italic", 10), bg="white", command=update_record)
update_button.place(x=140, y=400)

get_button = Button(root, text="Get", font=("italic", 10), bg="white", command=get_record)
get_button.place(x=200, y=400)

# Listbox to show records
listbox = Listbox(root)
listbox.place(x=350, y=50, width=400, height=300)

show_records()
root.mainloop()
