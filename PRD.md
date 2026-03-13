# Product Requirement Document (PRD)

## Smart Class Check-in & Learning Reflection App

---

## 1. Problem Statement

Universities need a reliable way to confirm that students are physically present in class and actively participating in learning activities. Traditional attendance methods such as manual sign-in sheets can be inaccurate and inefficient.

The **Smart Class Check-in & Learning Reflection App** aims to improve attendance verification and encourage student engagement by combining **QR code scanning**, **GPS location verification**, and **short learning reflections**. This system allows students to check in to class sessions and reflect on their learning experience before and after the class.

---

## 2. Target Users

### Primary Users

* University students attending a course session.

### Secondary Stakeholders

* Lecturers who want to verify attendance and gather feedback about the class.

---

## 3. Feature List

### 3.1 Class Check-in (Before Class)

Students can check in at the beginning of a class session.

The system will:

* Record **GPS location**
* Record **timestamp**
* Scan **class QR code**

Students must also provide:

* Previous class topic
* Expected topic for today
* Mood before class (1–5 scale)

#### Mood Scale

| Score | Mood             |
| ----- | ---------------- |
| 1     | 😡 Very negative |
| 2     | 🙁 Negative      |
| 3     | 😐 Neutral       |
| 4     | 🙂 Positive      |
| 5     | 😄 Very positive |

---

### 3.2 Class Completion (After Class)

Students complete a reflection at the end of the class.

The system will:

* Scan the **QR code again**
* Record **GPS location**
* Record **timestamp**

Students also provide:

* What they learned today (short text)
* Feedback about the class or instructor

---

## 4. User Flow

1. Student opens the application.
2. The **Home Screen** displays two options:

   * Check-in
   * Finish Class
3. For **Check-in**:

   * Student presses **Check-in**
   * App scans QR code displayed by lecturer
   * App retrieves GPS location
   * Student fills the reflection form
   * Data is saved to the backend
4. For **Finish Class**:

   * Student presses **Finish Class**
   * App s
