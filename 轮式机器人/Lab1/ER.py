from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship, declarative_base

Base = declarative_base()

class Employee(Base):
    __tablename__ = 'employees'

    empid = Column(Integer, primary_key=True)
    salary = Column(Integer)
    phone = Column(String)

    manages = relationship("Department", back_populates="manager")
    children = relationship("Child", back_populates="parent")

class Department(Base):
    __tablename__ = 'departments'

    dno = Column(Integer, primary_key=True)
    dname = Column(String)
    budget = Column(Integer)
    manager_empid = Column(Integer, ForeignKey('employees.empid'))

    manager = relationship("Employee", back_populates="manages")

class Child(Base):
    __tablename__ = 'children'

    name = Column(String, primary_key=True)
    age = Column(Integer)
    parent_empid = Column(Integer, ForeignKey('employees.empid'))

    parent = relationship("Employee", back_populates="children")
