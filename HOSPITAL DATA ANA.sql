CREATE TABLE Patients (
	PatientID INT,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Gender VARCHAR(50),
	DOB DATE,
	Contact_Number VARCHAR(50),
	Address VARCHAR(100),
	InsuranceProvider VARCHAR(100),
	InsuranceNumber VARCHAR(100),
	RegistrationDate DATE

);

	CREATE TABLE Appointment (
	AppointmentID INT,
	PatientID INT,
	DoctorID INT,
	AppointmentDate DATE,
	AppointmentTime TIME,
	Reason VARCHAR(100)

	);

CREATE TABLE Doctors (
	DoctorID INT,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Specialization VARCHAR(100),
	JoiningDate DATE,
	ContactNumber VARCHAR(50)
);

CREATE TABLE Medical_records(
  RecordID INT,
	PatientID INT,
	Diagnosis VARCHAR(100),
	Treatment VARCHAR(100),
	RecordDate DATE
);

CREATE TABLE Billing (

	BillID INT,
	PatientID INT,
	Amount NUMERIC(10,2),
	Status VARCHAR(50),
	PaymentMode VARCHAR(50),
	BillingDate DATE

);

-- DATA CLEANING--

SELECT COUNT(*) AS total_null
FROM Patients p
WHERE p.insuranceprovider IS NULL;

 UPDATE Patients
 SET insuranceprovider = 'N/A'
 WHERE insuranceprovider IS NULL;

 DELETE FROM Patients
 WHERE insuranceprovider = 'N/A';

 SELECT COUNT(*) AS total_null
 FROM Patients p
 WHERE p.InsuranceNumber IS NULL;

 UPDATE Patients
 SET InsuranceNumber = 'N/A'
 WHERE InsuranceNumber IS NULL;

 DELETE FROM Patients
 WHERE InsuranceNumber = 'N/A';


SELECT COUNT(*) AS total_null
FROM Appointment a
WHERE a.reason IS NULL;

UPDATE Appointment
SET reason = 'N/A'
WHERE reason IS NULL;

DELETE FROM Appointment
WHERE reason = 'N/A';

SELECT COUNT(*) AS total_count
FROM Medical_records m
WHERE m.diagnosis IS NULL;

UPDATE Medical_records
SET diagnosis = 'N/A'
WHERE diagnosis IS NULL;

DELETE FROM Medical_records
WHERE diagnosis = 'N/A';

SELECT COUNT(*) AS total_null
FROM Medical_records m
WHERE m.treatment IS NULL;

UPDATE Medical_records
SET treatment = 'N/A'
WHERE treatment IS NULL;

DELETE FROM Medical_records
WHERE treatment = 'N/A';

SELECT COUNT(*) AS total_null
FROM Billing 
WHERE amount IS NULL;

DELETE FROM Billing
WHERE amount IS NULL;

SELECT COUNT(*)
FROM Billing
WHERE status IS NULL;

DELETE FROM Billing
WHERE status IS NULL;

SELECT COUNT(*) AS total_null
FROM Billing
WHERE paymentmode IS NULL; 

DELETE FROM Billing
WHERE paymentmode IS NULL;

--DATA ANALYSIS START--

--TOTAL PATIENTS MONTHLY VISIT--

SELECT TO_CHAR(RegistrationDate,'YYYY-MM')
AS months,COUNT(patientid) AS monthly_visit
FROM patients
GROUP BY TO_CHAR(RegistrationDate,'YYYY-MM')
ORDER BY monthly_visit DESC;

--ADDING NEW COLUMN TO MERGE F&L NAMES--

ALTER TABLE patients 
ADD COLUMN Full_Name TEXT;

UPDATE patients
SET Full_Name = firstname ||' '|| lastname;

ALTER TABLE patients
DROP COLUMN firstname,DROP COLUMN lastname;

--ADDING NEW COLUMN TO MERGE F&L NAMES--

ALTER TABLE doctors 
ADD COLUMN Full_Name TEXT;

UPDATE doctors
SET Full_Name = firstname ||' '|| lastname;

ALTER TABLE patients
DROP COLUMN firstname,DROP COLUMN lastname;

--COUNTING TOTAL PATIENTS--

	SELECT COUNT(*) 
	AS total_patients
	FROM patients;

--COUNTING TOTAL DOCTORS--
	
	SELECT COUNT(*) 
	AS total_doctors
	FROM Doctors;
	
--COUNTING TOTAL Female_Patients--
	SELECT COUNT(*) 
	AS total_Female_patients
	FROM patients
	WHERE gender ='F';

--COUNTING TOTAL Male_Patients--
	SELECT COUNT(*)
	AS total_male_patients
	FROM patients
	WHERE gender ='M';

--TOTAL Appointment--

	SELECT COUNT(*) 
	AS total_Appointment
	FROM Appointment;

--PATIENTS PER DOCTOR(WORKLOAD ANALYSIS)
	SELECT a.doctorid,d.full_name,
	COUNT(*) AS total_appointments
	FROM Appointment a
	JOIN doctors d ON a.doctorid = d.doctorid
	GROUP BY a.doctorid,d.full_name
	ORDER BY total_appointments DESC
	LIMIT 10;

--TOTAL REVENUE--
	SELECT SUM(amount) 
	AS total_revenue 
	FROM billing;
	
--AVG BILL PAR PATIENTS--
	SELECT ROUND(AVG(amount)) 
	AS avg_bill
	FROM billing;

--Retrieve Imp Data--
SELECT
       p.patientid,p.full_name AS Patient_Name,
       p.gender,p.contact_number,p.registrationdate,
	   a.reason,d.full_name AS Doctor_Name,d.specialization,
	   m.diagnosis,m.treatment,b.amount,b.status
FROM Patients p
INNER JOIN  Appointment a
ON p.patientid = a.patientid
INNER JOIN doctors d 
ON a.doctorid = d.doctorid
INNER JOIN medical_records m
ON p.patientid = m.patientid
INNER JOIN billing b
ON p.patientid = b.patientid
ORDER BY p.patientid ASC;
	
	SELECT * FROM Patients;
	SELECT * FROM Appointment;
	SELECT * FROM Doctors;
	SELECT * FROM  Medical_records;
	SELECT * FROM Billing;