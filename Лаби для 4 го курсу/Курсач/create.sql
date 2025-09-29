USE master;
GO

-- ��������� ���� �����, ���� ���� ��� ����
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'CarDatabase')
  DROP DATABASE CarDatabase;

-- ��������� ���� ���� �����
CREATE DATABASE CarDatabase;
USE CarDatabase
GO


-- ������� ���������
CREATE TABLE Manufacturers (
��ManufacturerID INT PRIMARY KEY,
��Name VARCHAR(255) NOT NULL UNIQUE,
��Headquarters VARCHAR(255),
��FoundedYear INT,
��Website VARCHAR(255) NULL,
��Revenue DECIMAL(10, 2) NULL,
��MarketShare DECIMAL(10, 2) NULL
);

-- ������� ������� ���������
CREATE TABLE Engines (
��EngineID INT PRIMARY KEY NOT NULL,
��EngineType VARCHAR(255) NOT NULL,
��Horsepower INT NOT NULL,
��FuelType VARCHAR(50),
��Displacement INT NULL,
��Torque INT NULL,
��FuelEfficiency DECIMAL(10, 2) NULL
);

-- ������� ���������
CREATE TABLE Cars (
��CarID INT PRIMARY KEY NOT NULL,
��Model VARCHAR(255) NOT NULL,
��Year INT NOT NULL,
��ManufacturerID INT NOT NULL,
��CountryID INT NOT NULL,
��EngineID INT NOT NULL,
��Price DECIMAL(10, 2),
��BodyStyle VARCHAR(50) NULL,
��Drivetrain VARCHAR(50) NULL,
��Transmission VARCHAR(50) NULL,
��FuelTankCapacity INT NULL,
��SeatingCapacity INT NULL,
��UNIQUE (Model)
);

-- ������� �����
CREATE TABLE People (
��PersonID INT PRIMARY KEY NOT NULL,
��FirstName VARCHAR(255) NOT NULL,
��LastName VARCHAR(255) NOT NULL,
��DateOfBirth DATE NOT NULL,
��Gender VARCHAR(10),
��Address VARCHAR(255) NULL,
��Phone VARCHAR(255) NULL UNIQUE,
��Email VARCHAR(255) NULL UNIQUE
);

-- ������� �������� ��������� (��'������ �������)
CREATE TABLE CarOwners (
��CarID INT,
��OwnerID INT,
��PurchaseDate DATE,
��PRIMARY KEY (CarID, OwnerID),
��FOREIGN KEY (CarID) REFERENCES Cars(CarID),
��FOREIGN KEY (OwnerID) REFERENCES People(PersonID)
);

-- ������� ��'������� ������
CREATE TABLE Parts (
��PartID INT PRIMARY KEY NOT NULL,
��PartName VARCHAR(255) NOT NULL,
��Description TEXT,
��PartNumber VARCHAR(255) NULL,
��Manufacturer VARCHAR(255) NULL,
��Warranty VARCHAR(255) NULL,
��UNIQUE (PartName)
);

-- �������, ��� �����, �� ������� ���������� �� ������� ���������
CREATE TABLE CarParts (
��CarID INT,
��PartID INT,
��Quantity INT,
��PRIMARY KEY (CarID, PartID),
��FOREIGN KEY (CarID) REFERENCES Cars(CarID),
��FOREIGN KEY (PartID) REFERENCES Parts(PartID)
);

-- ������� ������ ��� ���������
CREATE TABLE Services (
��ServiceID INT PRIMARY KEY NOT NULL,
��ServiceName VARCHAR(255) NOT NULL,
��ServiceType VARCHAR(50),
��Description VARCHAR(MAX) NULL,
��Cost DECIMAL(10, 2) NULL,
��UNIQUE (ServiceName)
);

-- ������� ���� ����������
CREATE TABLE Countries (
��CountryID INT PRIMARY KEY NOT NULL,
��CountryName VARCHAR(255) NOT NULL UNIQUE,
��Continent VARCHAR(50) NOT NULL,
��Currency VARCHAR(50) NOT NULL,
��Language VARCHAR(50) NOT NULL
);

INSERT INTO Manufacturers (Name, Headquarters, FoundedYear, Website, Revenue, MarketShare)
VALUES
('Toyota', 'Toyota City, Japan', 1937, 'https://www.toyota.com/', 275.52, 15.00),
('Honda', 'Tokyo, Japan', 1948, 'https://www.honda.com/', 156.95, 9.00),
('General Motors', 'Detroit, Michigan, USA', 1908, 'https://www.gm.com/', 127.88, 7.50),
('Volkswagen', 'Wolfsburg, Germany', 1937, 'https://www.volkswagen.com/', 252.62, 13.50),
('Ford', 'Dearborn, Michigan, USA', 1903, 'https://www.ford.com/', 136.27, 8.00);

INSERT INTO Engines (EngineType, Horsepower, FuelType, Displacement, Torque, FuelEfficiency)
VALUES
('����������', 200, '������', 2.0, 250, 8.0),
('���������', 150, '������', 2.5, 350, 6.0),
('��������', 180, '������', 2.0, 220, 5.0),
('�����������', 250, '���������', 0, 400, 4.0),
('�������� plug-in', 220, '������', 2.0, 280, 5.0);

INSERT INTO Cars (Model, Year, ManufacturerID, CountryID, EngineID, Price, BodyStyle, Drivetrain, Transmission, FuelTankCapacity, SeatingCapacity)
VALUES
('Toyota Camry', 2023, 1, 1, 1, 40000, '�����', '������� �����', '�����������', 60, 5),
('Honda Accord', 2023, 2, 2, 2, 35000, '�����', '������� �����', '�����������', 50, 5),
('Chevrolet Malibu', 2023, 3, 3, 3, 30000, '�����', '������� �����', '�����������', 45, 5),
('Volkswagen Jetta', 2023, 4, 4, 4, 25000, '�����', '������� �����', '��������', 40, 5),
('Ford Fusion', 2023, 5, 5, 5, 20000, '�����', '������� �����', '��������', 35, 5);


INSERT INTO Countries (CountryName, Continent, Currency, Language)
VALUES
('������', '������', '������', '���������'),
('���', 'ϳ����� �������', '����� ���', '���������'),
('�����', '���', '����', '���������'),
('�����', '���', '���', '��������');

INSERT INTO CarOwners (CarID, OwnerID, PurchaseDate)
VALUES
(1, 1, '2023-07-20'),
(2, 2, '2023-08-01'),
(3, 3, '2023-08-15'),
(4, 4, '2023-09-01'),
(5, 5, '2023-09-15');

INSERT INTO Parts (PartName, Description, PartNumber, Manufacturer, Warranty)
VALUES
('������� ����', '�������� ���� �������� 17 �����', '1234567890', 'Toyota', '5 ����'),
('�������� �������', '�������� ������� ���������� ������', '9876543210', 'Brembo', '3 ����'),
('����������', '������������ ���������� ������ 75 ���', 'AB123456789', 'Bosch', '2 ����'),
('����� �������', '������� ����� SAE 5W-30', '1234567890', 'Mobil', '1 ��'),
('������ ������', 'Գ���� ������ ��� �������', '9876543210', 'Mann-Filter', '1 ��');

INSERT INTO Services (ServiceName, ServiceType, Description, Cost)
VALUES
('����� �����', '������� ��������������', '����� ����� �� �������', 1000),
('����� ��������� �������', '������� ��������������', '����� ������� ��� ����� ��������� �������', 2000),
('����� �����������', '������� ��������������', '����� ������������� �����������', 3000),
('�������� ������', '������', '³��������� ������ ���� ���', 10000),
('�������� ������', '������', '������ �������', 20000);

INSERT INTO Parts (PartName, Description, PartNumber, Manufacturer, Warranty)
VALUES
('�����������', '������������ �����������', '1234567890', 'Denso', '3 ����'),
('�������', '������������ �������', '9876543210', 'Valeo', '5 ����'),
('���������', '������������ ���������', 'AB123456789', 'Bosch', '2 ����'),
('������', '������ ��� �������', '1234567890', 'Mitsubishi', '1 ��'),
('�������� �������', '�������� ������� ��� ���������', '9876543210', 'Brembo', '5 ����');

INSERT INTO Cars (Model, Year, ManufacturerID, CountryID, EngineID, Price, BodyStyle, Drivetrain, Transmission, FuelTankCapacity, SeatingCapacity)
VALUES
('Tesla Model 3', 2023, 3, 2, 1, 50000, '�����', '������ �����', '�����������', 60, 5),
('BMW i4', 2023, 2, 4, 2, 45000, '�����', '������ �����', '�����������', 80, 5),
('Ford F-150 Lightning', 2023, 4, 5, 3, 50000, '����', '������ �����', '�����������', 100, 6),
('Toyota Camry Hybrid', 2023, 1, 1, 4, 35000, '�����', '������� �����', '�����������', 60, 5),
('Honda Accord Hybrid', 2023, 5, 4, 3, 30000, '�����', '������� �����', '�����������', 50, 5);

INSERT INTO People (FirstName, LastName, DateOfBirth, Gender, Address, Phone, Email)
VALUES
('Jane', 'Smith', '1985-02-02', 'Female', '456 Elm Street, Anytown, CA 91234', '(456) 789-0123', 'jane.smith@example.com'),
('Peter', 'Jones', '1990-03-03', 'Male', '789 Oak Street, Anytown, CA 91234', '(789) 012-3456', 'peter.jones@example.com'),
('Mary', 'Williams', '1995-04-04', 'Female', '1011 Main Street, Anytown, CA 91234', '(1011) 123-4567', 'mary.williams@example.com'),
('David', 'Brown', '2000-05-05', 'Male', '1234 Elm Street, Anytown, CA 91234', '(1234) 567-8901', 'david.brown@example.com'),
('Susan', 'Green', '2005-06-06', 'Female', '4567 Oak Street, Anytown, CA 91234', '(4567) 901-2345', 'susan.green@example.com');

-- ������ ������ ��� ������
INSERT INTO CarParts (CarID, PartID, Quantity)
VALUES
(1, 1, 4),
(1, 2, 4),
(2, 1, 4),
(2, 2, 4),
(3, 1, 4),
(3, 2, 4),
(4, 1, 4),
(4, 2, 4),
(5, 1, 4),
(5, 2, 4);

-- ������ ������ ��� ������� �������
INSERT INTO CarParts (CarID, PartID, Quantity)
VALUES
(1, 3, 4),
(2, 3, 4),
(3, 3, 4),
(4, 3, 4),
(5, 3, 4);

-- ������� ������ ��� ���������

-- ������ ������ ��� ��������� ��������������
INSERT INTO Services (ServiceName, ServiceType, Description, Cost)
VALUES
('���� ����� �� �������', '������� ��������������', '����� ��������� ����� �� �������', 1000),
('����� ��������� �������', '������� ��������������', '����� ������� ��� ����� ��������� �������', 2000),
('����� �����������', '������� ��������������', '����� ������������� �����������', 3000);

-- ������ ������ ��� ������
INSERT INTO Services (ServiceName, ServiceType, Description, Cost)
VALUES
('�������� ������', '������', '³��������� ������ ���� ���', 10000),
('�������� ������', '������', '������ �������', 20000)