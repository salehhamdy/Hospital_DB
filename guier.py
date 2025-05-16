from tkinter import *
from tkinter import messagebox
from tkinter import font
from tkinter import ttk
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
        show_records()
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

    id = entries[list(entries.keys())[0]].get()  # Assuming the first column is the ID column
    if id == "":
        messagebox.showinfo("Update Status", "ID is required for update")
        return

    try:
        con = mysql.connect(host="localhost", port=3306, user="root", password="Qwertyuiop12345^", database="hospital_project")
        cursor = con.cursor()

        # Fetch current values for the row to be updated
        cursor.execute(f"SELECT * FROM {table_name} WHERE {list(entries.keys())[0]}=%s", (id,))
        current_row = cursor.fetchone()

        if not current_row:
            messagebox.showinfo("Update Status", "Record not found")
            return

        # Prepare the update statement with only non-empty fields
        update_data = {}
        for i, (col, entry) in enumerate(entries.items()):
            new_value = entry.get()
            if new_value != "":
                update_data[col] = new_value

        if not update_data:
            messagebox.showinfo("Update Status", "No new values provided for update")
            return

        set_clause = ", ".join([f"{col}=%s" for col in update_data.keys()])
        sql = f"UPDATE {table_name} SET {set_clause} WHERE {list(entries.keys())[0]}=%s"
        cursor.execute(sql, tuple(update_data.values()) + (id,))
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

    id_list = entries[list(entries.keys())[0]].get()  # Assuming the first column is the ID column
    if id_list == "":
        messagebox.showinfo("Fetch Status", "ID(s) are required for fetch")
        return

    try:
        con = mysql.connect(host="localhost", port=3306, user="root", password="Qwertyuiop12345^", database="hospital_project")
        cursor = con.cursor()

        id_list = id_list.split()  # Split input by any whitespace character
        records = []

        for id in id_list:
            cursor.execute(f"SELECT * FROM {table_name} WHERE {list(entries.keys())[0]}=%s", (id,))
            row = cursor.fetchone()
            if row:
                records.append(row)

        if records:
            formatted_records = '\n'.join([' | '.join(map(str, row)) for row in records])  # Join rows with a separator
            selected_data_label.config(text=f"Fetched Records:\n{formatted_records}", font=('Arial', 12))  # Update label with fetched records
        else:
            selected_data_label.config(text="No records found", font=('Arial', 12))  # Update label text if no records found

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

        # Fetch column names
        cursor.execute(f"DESCRIBE {table_name}")
        columns = cursor.fetchall()
        column_names = [col[0] for col in columns]

        cursor.execute(f"SELECT * FROM {table_name}")
        rows = cursor.fetchall()

        # Clear the Treeview
        for item in tree.get_children():
            tree.delete(item)

        # Set up columns
        tree["columns"] = column_names
        for col in column_names:
            tree.heading(col, text=col)
            tree.column(col, anchor="w", width=100)

        # Insert data into Treeview
        for row in rows:
            tree.insert("", "end", values=row)
    except mysql.Error as err:
        messagebox.showerror("Fetch Status", f"Error: {err}")
    finally:
        if con.is_connected():
            con.close()

def clear_entries():
    for entry in entries.values():
        entry.delete(0, END)
    selected_data_label.config(text="")  # Clear the label text when clearing entries

def generate_report():
    table_name = table_list.get()
    if not table_name:
        messagebox.showinfo("Report Status", "Table selection is required")
        return

    try:
        con = mysql.connect(host="localhost", port=3306, user="root", password="Qwertyuiop12345^", database="hospital_project")
        cursor = con.cursor()

        # Fetch all records from the selected table
        cursor.execute(f"SELECT * FROM {table_name}")
        rows = cursor.fetchall()

        if not rows:
            messagebox.showinfo("Report Status", "No data found")
            return

        # Create a report text
        report = f"Report for {table_name}:\n\n"
        for row in rows:
            report += ' | '.join(map(str, row)) + '\n'

        # Display the report in a new window
        report_window = Toplevel(root)
        report_window.title("Generated Report")
        report_window.geometry("600x400")
        
        report_text = Text(report_window, wrap=WORD)
        report_text.insert(END, report)
        report_text.pack(expand=True, fill=BOTH)
        
        report_scroll = Scrollbar(report_window, command=report_text.yview)
        report_scroll.pack(side=RIGHT, fill=Y)
        
        report_text.config(yscrollcommand=report_scroll.set)

    except mysql.Error as err:
        messagebox.showerror("Report Status", f"Error: {err}")
    finally:
        if con.is_connected():
            con.close()

root = Tk()
root.geometry("1000x600") # Increased width to accommodate more columns
root.title("Hospital Management System")
root.configure(bg="light blue")

table_label = Label(root, text='Select Table', font=('bold', 10),bg="lightblue")
table_label.place(x=20, y=10)
table_list = StringVar()
table_dropdown = OptionMenu(root, table_list, *["Patient", "Department", "Doctor", "Nurses", "Staff", "Appointment", "Admission", "ERPatient", "ORPatient"], command=update_fields)
table_dropdown.place(x=150, y=10)

entry_frame = Frame(root)
entry_frame.place(x=20, y=50, width=300, height=300)

insert_button = Button(root, text="Insert", font=("italic", 10), bg="white", command=insert_record)
insert_button.place(x=20, y=400)

delete_button = Button(root, text="Delete", font=("italic", 10), bg="red", command=delete_record)
delete_button.place(x=80, y=400)

update_button = Button(root, text="Update", font=("italic", 10), bg="lightgreen", command=update_record)
update_button.place(x=140, y=400)

get_button = Button(root, text="show", font=("italic", 10), bg="white", command=get_record)
get_button.place(x=200, y=400)

report_button = Button(root, text="Generate Report", font=("italic", 10), bg="lightblue", command=generate_report)
report_button.place(x=260, y=400)

clear_button = Button(root, text="Clear", font=("italic", 10), bg="white", command=clear_entries)
clear_button.place(x=380, y=400)

selected_data_label = Label(root, text="", font=('Arial', 12), relief='groove', wraplength=800, justify='left',bg="white")
selected_data_label.place(x=350, y=450, width=600, height=150)  # Position and size the label below the buttons

selected_data_text = Text(selected_data_label, font=('Arial', 12), wrap=WORD)
selected_data_text.pack(side=LEFT, fill=BOTH, expand=True)

selected_data_scrollbar = Scrollbar(selected_data_label, command=selected_data_text.yview)
selected_data_scrollbar.pack(side=RIGHT, fill=Y)

selected_data_text.config(yscrollcommand=selected_data_scrollbar.set)

tree_frame = Frame(root)
tree_frame.place(x=350, y=50, width=900, height=300)

tree_scroll = Scrollbar(tree_frame, orient=HORIZONTAL)
tree_scroll.pack(side=BOTTOM, fill=X)

tree_scroll_v = Scrollbar(tree_frame, orient=VERTICAL)
tree_scroll_v.pack(side=RIGHT, fill=Y)

tree = ttk.Treeview(tree_frame, show="headings", xscrollcommand=tree_scroll.set, yscrollcommand=tree_scroll_v.set)
tree.pack(expand=True, fill=BOTH)

tree_scroll.config(command=tree.xview)
tree_scroll_v.config(command=tree.yview)

show_records()
root.mainloop()
