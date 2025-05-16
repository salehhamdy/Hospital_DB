CREATE DATABASE IF NOT EXISTS hospital_project;

USE hospital_project;

-- Patient table
CREATE TABLE IF NOT EXISTS Patient (
    PatientID INT PRIMARY KEY,
    PatientName VARCHAR(100),
    DateOfBirth DATE,
    Gender VARCHAR(10),
    ContactInfo VARCHAR(100),
    Address VARCHAR(255),
    InsuranceInfo VARCHAR(255)
);

-- Department table
CREATE TABLE IF NOT EXISTS Department (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100),
    HeadDoctorID INT,
    HeadNurseID INT,
    ContactInfo VARCHAR(100)
);

-- Doctor table
CREATE TABLE IF NOT EXISTS Doctor (
    DoctorID INT PRIMARY KEY,
    DoctorName VARCHAR(100),
    Specialization VARCHAR(100),
    ContactInfo VARCHAR(100),
    DepartmentName VARCHAR(50),
    DepartmentID INT,
    CONSTRAINT fk_doctor_departmentid FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Nurses table
CREATE TABLE IF NOT EXISTS Nurses (
    NurseID INT PRIMARY KEY,
    NurseName VARCHAR(100),
    ContactInfo VARCHAR(100),
    DepartmentName VARCHAR(50),
    DepartmentID INT,
    CONSTRAINT fk_nurses_departmentid FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Staff table
CREATE TABLE IF NOT EXISTS Staff (
    StaffID INT PRIMARY KEY,
    DoctorID INT,
    NurseID INT,
    NurseName VARCHAR(100),
    DoctorName VARCHAR(100),
    Position VARCHAR(100),
    ContactInfo VARCHAR(100),
    DepartmentName VARCHAR(50),
    DepartmentID INT,
    CONSTRAINT fk_staff_departmentid_department FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_staff_doctorid_doctor FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_staff_nurseid_nurse FOREIGN KEY (NurseID) REFERENCES Nurses(NurseID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Appointment table
CREATE TABLE IF NOT EXISTS Appointment (
    AppointmentID INT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    NurseID INT,
    AppointmentDateTime DATETIME,
    Reason VARCHAR(255),
    Status ENUM('Scheduled', 'Completed', 'Canceled'),
    CONSTRAINT fk_appointment_patientid FOREIGN KEY (PatientID) REFERENCES Patient(PatientID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_appointment_doctorid FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_appointment_nurseid FOREIGN KEY (NurseID) REFERENCES Nurses(NurseID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Admission table

CREATE TABLE IF NOT EXISTS Admission (
    AdmissionID INT PRIMARY KEY,
    PatientID INT,
    NurseID INT,
    AdmissionDateTime DATETIME,
    DischargeDateTime DATETIME,
    WardRoomNumber VARCHAR(50),
    AdmittingDoctorID INT,
    Diagnosis VARCHAR(255),
    CONSTRAINT fk_admission_patient_patient FOREIGN KEY (PatientID) REFERENCES Patient(PatientID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_admission_doctor_doctor FOREIGN KEY (AdmittingDoctorID) REFERENCES Doctor(DoctorID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_admission_nurse_nurse FOREIGN KEY (NurseID) REFERENCES Nurses(NurseID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ERPatient table
CREATE TABLE IF NOT EXISTS ERPatient (
    ERPatientID INT PRIMARY KEY,
    DoctorID INT,
    ArrivalDateTime DATETIME,
    ChiefComplaint VARCHAR(255),
    TriageLevel INT,
    InitialAssessment VARCHAR(255),
    TreatmentPlan VARCHAR(255),
    Disposition VARCHAR(50),
    Outcome VARCHAR(50),
    CONSTRAINT fk_erpatient_patient FOREIGN KEY (ERPatientID) REFERENCES Patient(PatientID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_erpatient_doctor FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ORPatient table
CREATE TABLE IF NOT EXISTS ORPatient (
    ORPatientID INT PRIMARY KEY,
    NurseID INT,
    ArrivalDateTime DATETIME,
    DepartureDateTime DATETIME,
    ProceduresPerformed VARCHAR(255),
    SurgeonID INT,
    AnesthesiologistID INT,
    CONSTRAINT fk_orpatient_patient FOREIGN KEY (ORPatientID) REFERENCES Patient(PatientID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_orpatient_surgeon FOREIGN KEY (SurgeonID) REFERENCES Doctor(DoctorID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_orpatient_anesthesiologist FOREIGN KEY (AnesthesiologistID) REFERENCES Doctor(DoctorID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_orpatient_nurse FOREIGN KEY (NurseID) REFERENCES Nurses(NurseID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- indexing the constraints
CREATE INDEX idx_nurse_nursename ON Nurses(NurseName);
CREATE INDEX idx_doctor_doctorname ON Doctor(DoctorName);
CREATE INDEX idx_department_departmentname ON Department(DepartmentName);


-- ---------------------------------------------------------
-- inserting in patient table

INSERT INTO `Patient` (`PatientID`, `PatientName`, `DateOfBirth`, `Gender`, `ContactInfo`, `Address`, `InsuranceInfo`) VALUES
(1, 'Ali Ahmed', '1990-05-15', 'Male', '123-456-7890', '123 Main Street', 'Insurance ABC'),
(2, 'Fatima Mohamed', '1985-08-20', 'Female', '456-789-0123', '456 Oak Street', 'Insurance XYZ'),
(3, 'Ahmed Youssef', '1976-03-10', 'Male', '789-012-3456', '789 Cedar Street', 'Insurance 123'),
(4, 'Layla Ahmed', '1992-11-25', 'Female', '321-654-9870', '321 Pine Street', 'Insurance 456'),
(5, 'Mohamed Ali', '1980-07-05', 'Male', '654-987-0123', '654 Cedar Street', 'Insurance 789'),
(6, 'Aisha Abdullah', '1993-09-18', 'Female', '987-654-3210', '987 Elm Street', 'Insurance XYZ'),
(7, 'Omar Hassan', '1988-02-22', 'Male', '741-852-9630', '741 Maple Street', 'Insurance ABC'),
(8, 'Yasmine Ibrahim', '1982-06-30', 'Female', '852-963-7410', '852 Oak Street', 'Insurance 123'),
(9, 'Khaled Khalil', '1979-04-12', 'Male', '369-258-1470', '369 Pine Street', 'Insurance 456'),
(10, 'Sara Ahmed', '1995-12-08', 'Female', '258-147-3690', '258 Cedar Street', 'Insurance 789'),
(11, 'Hassan Ali', '1987-10-03', 'Male', '147-369-2580', '147 Cedar Street', 'Insurance XYZ'),
(12, 'Noura Mahmoud', '1990-03-25', 'Female', '147-369-8520', '147 Maple Street', 'Insurance ABC'),
(13, 'Omar Salah', '1983-07-17', 'Male', '369-852-1470', '369 Elm Street', 'Insurance 123'),
(14, 'Lina Khalid', '1998-01-12', 'Female', '852-147-3690', '852 Pine Street', 'Insurance 456'),
(15, 'Youssef Samir', '1985-11-06', 'Male', '741-963-8520', '741 Cedar Street', 'Insurance 789'),
(16, 'Amira Adel', '1991-04-29', 'Female', '963-852-7410', '963 Maple Street', 'Insurance XYZ'),
(17, 'Tarek Amir', '1977-08-14', 'Male', '654-321-9870', '654 Oak Street', 'Insurance ABC'),
(18, 'Rania Kamal', '1984-12-19', 'Female', '321-987-6540', '321 Pine Street', 'Insurance 123'),
(19, 'Mahmoud Hani', '1989-06-02', 'Male', '987-654-3210', '987 Elm Street', 'Insurance 456'),
(20, 'Nada Ahmed', '1994-10-07', 'Female', '654-321-9870', '654 Maple Street', 'Insurance 789'),
(21, 'Samiya Jamal', '1981-02-15', 'Female', '321-987-6540', '321 Oak Street', 'Insurance XYZ'),
(22, 'Mohammed Adnan', '1978-05-20', 'Male', '987-654-3210', '987 Pine Street', 'Insurance ABC'),
(23, 'Laila Tamer', '1996-08-23', 'Female', '654-321-9870', '654 Elm Street', 'Insurance 123'),
(24, 'Khalid Nour', '1980-11-28', 'Male', '321-987-6540', '321 Cedar Street', 'Insurance 456'),
(25, 'Amina Osama', '1997-03-17', 'Female', '987-654-3210', '987 Maple Street', 'Insurance 789'),
(26, 'Omar Farid', '1986-09-10', 'Male', '654-321-9870', '654 Oak Street', 'Insurance XYZ'),
(27, 'Sara Waleed', '1992-01-05', 'Female', '321-987-6540', '321 Pine Street', 'Insurance ABC'),
(28, 'Ahmed Hala', '1979-05-30', 'Male', '987-654-3210', '987 Cedar Street', 'Insurance 123'),
(29, 'Yasmin Raed', '1983-10-14', 'Female', '654-321-9870', '654 Elm Street', 'Insurance 456'),
(30, 'Hassan Marwa', '1990-04-19', 'Male', '321-987-6540', '321 Maple Street', 'Insurance 789');

-- ----------------------------------------
-- inserting department table
INSERT INTO `Department` (`DepartmentID`, `DepartmentName`, `HeadDoctorID`, `HeadNurseID`, `ContactInfo`) VALUES
(1, 'Cardiology', 101, 201, '123-456-7890'),
(2, 'Orthopedics', 102, 202, '456-789-0123'),
(3, 'Neurology', 103, 203, '789-012-3456'),
(4, 'Oncology', 104, 204, '321-654-9870'),
(5, 'Pediatrics', 105, 205, '654-987-0123'),
(6, 'IT', NULL, NULL, '555-555-5555'),
(7, 'Nursing', NULL, 301, '777-777-7777'), -- Assuming Nursing has a head nurse
(8, 'Surgeons', 401, NULL, '888-888-8888'), -- Assuming Surgeons have a head surgeon
(9, 'Admission', NULL, NULL, '999-999-9999');

-- -------------------------------------------------------------
-- Insert 12 rows into Doctor table
INSERT INTO `Doctor` (`DoctorID`, `DoctorName`, `Specialization`, `ContactInfo`, `DepartmentName`, `DepartmentID`) VALUES
(101, 'Dr. Ali Hassan', 'Cardiologist', '123-456-7890', 'Cardiology', 1),
(102, 'Dr. Fatima Ahmed', 'Orthopedic Surgeon', '456-789-0123', 'Orthopedics', 2),
(103, 'Dr. Ahmed Mahmoud', 'Neurologist', '789-012-3456', 'Neurology', 3),
(104, 'Dr. Layla Mohamed', 'Oncologist', '321-654-9870', 'Oncology', 4),
(105, 'Dr. Mohamed Youssef', 'Pediatrician', '654-987-0123', 'Pediatrics', 5),
(106, 'Dr. Omar Khaled', 'IT Specialist', '555-555-5555', 'IT', 6),
(107, 'Dr. Yasmine Hassan', 'Surgeon', '111-222-3333', 'Surgeons', 8),
(108, 'Dr. Samir Adel', 'Cardiologist', '444-555-6666', 'Cardiology', 1),
(109, 'Dr. Nada Ibrahim', 'Neurologist', '777-888-9999', 'Neurology', 3),
(110, 'Dr. Sara Tarek', 'Orthopedic Surgeon', '000-111-2222', 'Orthopedics', 2),
(111, 'Dr. Amira Mahmoud', 'Pediatrician', '999-888-7777', 'Pediatrics', 5),
(112, 'Dr. Adnan Khalid', 'Oncologist', '333-222-1111', 'Oncology', 4);

-- Insert 25 rows into Nurses table
INSERT INTO `Nurses` (`NurseID`, `NurseName`, `ContactInfo`, `DepartmentName`, `DepartmentID`) VALUES
(201, 'Nurse Sara', '111-222-3333', 'Cardiology', 1),
(202, 'Nurse Ahmed', '222-333-4444', 'Orthopedics', 2),
(203, 'Nurse Layla', '333-444-5555', 'Neurology', 3),
(204, 'Nurse Fatima', '444-555-6666', 'Oncology', 4),
(205, 'Nurse Omar', '555-666-7777', 'Pediatrics', 5),
(206, 'Nurse Hana', '666-777-8888', 'Nursing', 7),
(207, 'Nurse Ali', '777-888-9999', 'Nursing', 7),
(208, 'Nurse Yasmin', '888-999-0000', 'Nursing', 7),
(209, 'Nurse Tarek', '999-000-1111', 'Nursing', 7),
(210, 'Nurse Laila', '000-111-2222', 'Nursing', 7),
(211, 'Nurse Mahmoud', '111-222-3333', 'Nursing', 7),
(212, 'Nurse Nour', '222-333-4444', 'Nursing', 7),
(213, 'Nurse Amina', '333-444-5555', 'Nursing', 7),
(214, 'Nurse Omar', '444-555-6666', 'Nursing', 7),
(215, 'Nurse Sara', '555-666-7777', 'Nursing', 7),
(216, 'Nurse Youssef', '666-777-8888', 'Nursing', 7),
(217, 'Nurse Ahmed', '777-888-9999', 'Nursing', 7),
(218, 'Nurse Rania', '888-999-0000', 'Nursing', 7),
(219, 'Nurse Mahmoud', '999-000-1111', 'Nursing', 7),
(220, 'Nurse Nada', '000-111-2222', 'Nursing', 7),
(221, 'Nurse Samir', '111-222-3333', 'Nursing', 7),
(222, 'Nurse Samiya', '222-333-4444', 'Nursing', 7),
(223, 'Nurse Mohammed', '333-444-5555', 'Nursing', 7),
(224, 'Nurse Lina', '444-555-6666', 'Nursing', 7),
(225, 'Nurse Yasmine', '555-666-7777', 'Nursing', 7);

-- Insert 30 rows into Staff table
INSERT INTO `Staff` (`StaffID`, `DoctorID`, `NurseID`, `NurseName`, `DoctorName`, `Position`, `ContactInfo`, `DepartmentName`, `DepartmentID`) VALUES
(1, 101, 206, 'Nurse Hana', 'Dr. Ali Hassan', 'Nurse', '123-456-7890', 'Cardiology', 1),
(2, 102, 207, 'Nurse Ali', 'Dr. Fatima Ahmed', 'Nurse', '456-789-0123', 'Orthopedics', 2),
(3, 103, 208, 'Nurse Yasmin', 'Dr. Ahmed Mahmoud', 'Nurse', '789-012-3456', 'Neurology', 3),
(4, 104, 209, 'Nurse Tarek', 'Dr. Layla Mohamed', 'Nurse', '321-654-9870', 'Oncology', 4),
(5, 105, 210, 'Nurse Laila', 'Dr. Mohamed Youssef', 'Nurse', '654-987-0123', 'Pediatrics', 5),
(6, 106, 211, 'Nurse Mahmoud', 'Dr. Omar Khaled', 'Nurse', '555-555-5555', 'IT', 6),
(7, 107, 212, 'Nurse Nour', 'Dr. Yasmine Hassan', 'Nurse', '111-222-3333', 'Surgeons', 8),
(8, 108, 213, 'Nurse Amina', 'Dr. Samir Adel', 'Nurse', '444-555-6666', 'Cardiology', 1),
(9, 109, 214, 'Nurse Omar', 'Dr. Nada Ibrahim', 'Nurse', '777-888-9999', 'Neurology', 3),
(10, 110, 215, 'Nurse Sara', 'Dr. Sara Tarek', 'Nurse', '000-111-2222', 'Orthopedics', 2),
(11, 111, 216, 'Nurse Youssef', 'Dr. Amira Mahmoud', 'Nurse', '999-888-7777', 'Pediatrics', 5),
(12, 112, 217, 'Nurse Ahmed', 'Dr. Adnan Khalid', 'Nurse', '333-222-1111', 'Oncology', 4),
(13, 101, 218, 'Nurse Rania', 'Dr. Ali Hassan', 'Nurse', '123-456-7890', 'Cardiology', 1),
(14, 102, 219, 'Nurse Mahmoud', 'Dr. Fatima Ahmed', 'Nurse', '456-789-0123', 'Orthopedics', 2),
(15, 103, 220, 'Nurse Nada', 'Dr. Ahmed Mahmoud', 'Nurse', '789-012-3456', 'Neurology', 3),
(16, 104, 221, 'Nurse Samir', 'Dr. Layla Mohamed', 'Nurse', '321-654-9870', 'Oncology', 4),
(17, 105, 222, 'Nurse Samiya', 'Dr. Mohamed Youssef', 'Nurse', '654-987-0123', 'Pediatrics', 5),
(18, 106, 223, 'Nurse Mohammed', 'Dr. Omar Khaled', 'Nurse', '555-555-5555', 'IT', 6),
(19, 107, 224, 'Nurse Lina', 'Dr. Yasmine Hassan', 'Nurse', '111-222-3333', 'Surgeons', 8),
(20, 108, 225, 'Nurse Yasmine', 'Dr. Samir Adel', 'Nurse', '444-555-6666', 'Cardiology', 1),
(21, 109, 201, 'Nurse Sara', 'Dr. Nada Ibrahim', 'Nurse', '777-888-9999', 'Neurology', 3),
(22, 110, 202, 'Nurse Ahmed', 'Dr. Sara Tarek', 'Nurse', '000-111-2222', 'Orthopedics', 2),
(23, 111, 203, 'Nurse Layla', 'Dr. Amira Mahmoud', 'Nurse', '999-888-7777', 'Pediatrics', 5),
(24, 112, 204, 'Nurse Fatima', 'Dr. Adnan Khalid', 'Nurse', '333-222-1111', 'Oncology', 4),
(25, 101, 205, 'Nurse Omar', 'Dr. Ali Hassan', 'Nurse', '123-456-7890', 'Cardiology', 1),
(26, 102, 206, 'Nurse Hana', 'Dr. Fatima Ahmed', 'Nurse', '456-789-0123', 'Orthopedics', 2),
(27, 103, 207, 'Nurse Ali', 'Dr. Ahmed Mahmoud', 'Nurse', '789-012-3456', 'Neurology', 3),
(28, 104, 208, 'Nurse Yasmin', 'Dr. Layla Mohamed', 'Nurse', '321-654-9870', 'Oncology', 4),
(29, 105, 209, 'Nurse Tarek', 'Dr. Mohamed Youssef', 'Nurse', '654-987-0123', 'Pediatrics', 5),
(30, 106, 210, 'Nurse Laila', 'Dr. Omar Khaled', 'Nurse', '555-555-5555', 'IT', 6);

-- ----------------------------------------------------
-- Inserting into Doctor table

INSERT INTO Doctor (DoctorID, DoctorName, Specialization, ContactInfo, DepartmentName, DepartmentID) VALUES
(1, 'Dr. Ali', 'General Practitioner', '123-456-7890', 'General Medicine', 1),
(2, 'Dr. Fatima', 'Pediatrician', '456-789-0123', 'Pediatrics', 2),
(3, 'Dr. Ahmed', 'Orthopedic Surgeon', '789-012-3456', 'Surgeons', 3),
(4, 'Dr. Layla', 'Dermatologist', '321-654-9870', 'Admission', 4),
(5, 'Dr. Mohamed', 'Neurologist', '654-987-0123', 'ER', 5),
(6, 'Dr. Aisha', 'Ophthalmologist', '987-654-3210', 'OR', 6),
(7, 'Dr. Omar', 'ENT Specialist', '741-852-9630', 'ENT', 7),
(8, 'Dr. Yasmine', 'Endocrinologist', '852-963-7410', 'Endocrinology', 8),
(9, 'Dr. Khaled', 'Psychiatrist', '369-258-1470', 'Surgeons', 3),
(10, 'Dr. Sara', 'Urologist', '258-147-3690', 'Endocrinology', 4),
(11, 'Dr. Hassan', 'Gastroenterologist', '147-369-2580', 'ER', 5),
(12, 'Dr. Noura', 'Rheumatologist', '147-369-8520', 'OR', 6),
(13, 'Dr. Anesthesia', 'Anesthesiologist', '111-222-3333', 'Anesthesiology', 8),
(14, 'Dr. John Doe', 'Anesthesiologist', '222-333-4444', 'Anesthesiology', 8),
(15, 'Dr. Jane Smith', 'Anesthesiologist', '333-444-5555', 'Anesthesiology', 8);

-- Insert new rows into the Appointment table

INSERT INTO Appointment (AppointmentID, PatientID, DoctorID, NurseID, AppointmentDateTime, Reason, Status) VALUES 
(1, 1, 1, 201, '2024-05-25 10:00:00', 'Regular Checkup', 'Completed'), 
(2, 2, 2, 202, '2024-05-26 11:00:00', 'Vaccination', 'Completed'), 
(3, 3, 3, 203, '2024-05-27 12:00:00', 'Fracture Follow-up', 'Completed'), 
(4, 4, 4, 204, '2024-05-28 13:00:00', 'Skin Rash Consultation', 'Scheduled'), 
(5, 5, 5, 205, '2024-05-29 14:00:00', 'Headache Evaluation', 'Scheduled'), 
(6, 6, 6, 206, '2024-05-30 15:00:00', 'Eye Examination', 'Scheduled'), 
(7, 7, 7, 207, '2024-05-31 16:00:00', 'Ear Pain Consultation', 'Scheduled'), 
(8, 8, 8, 208, '2024-06-01 17:00:00', 'Diabetes Checkup', 'Scheduled'), 
(9, 9, 9, 209, '2024-06-02 18:00:00', 'Mental Health Assessment', 'Scheduled'), 
(10, 10, 10, 210, '2024-06-03 09:00:00', 'Urinary Tract Infection', 'Scheduled');

-- inserting admission table
INSERT INTO Admission (AdmissionID, PatientID, NurseID, AdmissionDateTime, DischargeDateTime, WardRoomNumber, AdmittingDoctorID, Diagnosis) VALUES
(1, 1, 201, '2024-05-25 10:00:00', '2024-05-28 12:00:00', 'Ward A101', 1, 'Myocardial Infarction'),
(2, 2, 202, '2024-05-26 11:00:00', '2024-05-29 12:00:00', 'Ward B202', 2, 'Bronchitis'),
(3, 3, 203, '2024-05-27 12:00:00', '2024-05-30 12:00:00', 'Ward C303', 3, 'Femur Fracture'),
(4, 4, 204, '2024-05-28 13:00:00', '2024-05-31 12:00:00', 'Ward D404', 4, 'Eczema'),
(5, 5, 205, '2024-05-29 14:00:00', '2024-06-01 12:00:00', 'Ward E505', 5, 'Migraine'),
(6, 6, 206, '2024-05-30 15:00:00', '2024-06-02 12:00:00', 'Ward F606', 6, 'Cataract'),
(7, 7, 207, '2024-05-31 16:00:00', '2024-06-03 12:00:00', 'Ward G707', 7, 'Otitis Media'),
(8, 8, 208, '2024-06-01 17:00:00', '2024-06-04 12:00:00', 'Ward H808', 8, 'Diabetes Mellitus'),
(9, 9, 209, '2024-06-02 18:00:00', '2024-06-05 12:00:00', 'Ward I909', 9, 'Depression'),
(10, 10, 210, '2024-06-03 09:00:00', '2024-06-06 12:00:00', 'Ward J1010', 10, 'Urinary Tract Infection'),
(11, 11, 211, '2024-06-04 10:00:00', '2024-06-07 12:00:00', 'Ward K1111', 11, 'Gastritis'),
(12, 12, 212, '2024-06-05 11:00:00', '2024-06-08 12:00:00', 'Ward L1212', 12, 'Arthritis');

-- --------------------------------------------------------------
-- Insert 10 ER patient rows
INSERT INTO ERPatient (ERPatientID, DoctorID, ArrivalDateTime, ChiefComplaint, TriageLevel, InitialAssessment, TreatmentPlan, Disposition, Outcome) VALUES 
(1, 1, '2024-05-25 10:00:00', 'Heart Attack', 2, 'Stabilized with medication', 'Administer medication and monitor', 'Admitted to ICU', 'Stable'),
(2, 2, '2024-05-26 11:00:00', 'Fractured Arm', 3, 'Splint applied', 'Order X-ray', 'Discharged', 'Recovered'),
(3, 3, '2024-05-27 12:00:00', 'Head Injury', 1, 'Conducted neurological examination', 'CT scan ordered', 'Admitted for observation', 'Stable'),
(4, 4, '2024-05-28 13:00:00', 'Severe Allergic Reaction', 2, 'Administered epinephrine', 'Monitored vital signs', 'Discharged', 'Recovered'),
(5, 5, '2024-05-29 14:00:00', 'Asthma Attack', 1, 'Administered bronchodilators', 'Oxygen therapy', 'Admitted to Respiratory Unit', 'Stable'),
(6, 6, '2024-05-30 15:00:00', 'Stroke', 2, 'Conducted neurological assessment', 'Ordered MRI', 'Admitted to Stroke Unit', 'Stable'),
(7, 7, '2024-05-31 16:00:00', 'Fractured Leg', 3, 'Applied splint', 'Ordered X-ray', 'Admitted for surgery', 'Stable'),
(8, 8, '2024-06-01 17:00:00', 'Concussion', 2, 'Conducted neurological assessment', 'CT scan ordered', 'Admitted for observation', 'Stable'),
(9, 9, '2024-06-02 18:00:00', 'Burns', 1, 'Assessed burns', 'Administered pain medication', 'Admitted to Burn Unit', 'Stable'),
(10, 10, '2024-06-03 09:00:00', 'Diabetic Crisis', 3, 'Administered insulin', 'Monitored blood glucose levels', 'Admitted to ICU', 'Stable');

-- Insert 3 OR patient rows
INSERT INTO ORPatient (ORPatientID, ArrivalDateTime, DepartureDateTime, ProceduresPerformed, SurgeonID, AnesthesiologistID) VALUES 
(1, '2024-05-25 10:00:00', '2024-05-25 12:00:00', 'Appendectomy', 1, 13), 
(2, '2024-05-26 11:00:00', '2024-05-26 13:00:00', 'Knee Replacement', 2, 14), 
(3, '2024-05-27 12:00:00', '2024-05-27 14:00:00', 'Cataract Surgery', 3, 15);
