CREATE INDEX "enrollments_by_student"
ON "enrollments" ("student_id");

CREATE INDEX "enrollments_by_course"
ON "enrollments" ("course_id");

CREATE INDEX "courses_by_department_semester_number"
ON "courses" ("department", "semester", "number");

CREATE INDEX "satisfies_by_course"
ON "satisfies" ("course_id");

CREATE INDEX "courses_by_title_semester"
ON "courses" ("title", "semester");
