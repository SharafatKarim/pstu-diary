-- =========================
-- ACADEMY TABLES
-- =========================

-- 1. DEAN FACULTY
CREATE TABLE academy_deanfaculty (
    faculty VARCHAR(200) NOT NULL,
    department VARCHAR(200) NOT NULL,
    PRIMARY KEY (faculty, department)
);

-- 2. DEAN OFFICE
CREATE TABLE academy_deanoffice (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    phone_number VARCHAR(11) NOT NULL,
    email VARCHAR(150) NOT NULL,
    designation VARCHAR(200) NOT NULL,
    priority INTEGER NOT NULL,

    -- Foreign Key Columns
    faculty VARCHAR(200) NOT NULL,
    department VARCHAR(200) NOT NULL, -- Replaces department_id

    CONSTRAINT fk_deanoffice_faculty_dept
        FOREIGN KEY (faculty, department)
        REFERENCES academy_deanfaculty (faculty, department)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 3. DEPARTMENT (Teacher)
CREATE TABLE academy_department (
    faculty VARCHAR(200) NOT NULL,
    department VARCHAR(200) NOT NULL,
    PRIMARY KEY (faculty, department)
);

-- 4. TEACHER
CREATE TABLE academy_teacher (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    phone_number VARCHAR(11) NOT NULL,
    profile_pic VARCHAR(100),
    email VARCHAR(150) NOT NULL,
    designation VARCHAR(200) NOT NULL,
    priority INTEGER NOT NULL,

    -- Foreign Key Columns
    faculty_name VARCHAR(200) NOT NULL, -- Maps to 'faculty' in parent
    department_name VARCHAR(200) NOT NULL, -- Maps to 'department' in parent (Replaces department_id)

    CONSTRAINT fk_teacher_department
        FOREIGN KEY (faculty_name, department_name)
        REFERENCES academy_department (faculty, department)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 5. STAFF DEPARTMENT
CREATE TABLE academy_staffdepartment (
    faculty VARCHAR(200) NOT NULL,
    department VARCHAR(200) NOT NULL,
    PRIMARY KEY (faculty, department)
);

-- 6. STAFF
-- reference to academy_staffdepartment
CREATE TABLE academy_staff (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    phone_number VARCHAR(11) NOT NULL,
    email VARCHAR(150),
    designation VARCHAR(200) NOT NULL,
    priority INTEGER NOT NULL,

    -- Foreign Key Columns
    faculty VARCHAR(200) NOT NULL,
    department VARCHAR(200) NOT NULL, -- Replaces department_id

    CONSTRAINT fk_staff_department
        FOREIGN KEY (faculty, department)
        REFERENCES academy_staffdepartment (faculty, department)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 7. ADMINISTRATION DEPARTMENT
CREATE TABLE administration_administrationdepartment (
    faculty VARCHAR(200) NOT NULL,
    department VARCHAR(200) NOT NULL,
    PRIMARY KEY (faculty, department)
);

-- 8. ADMINISTRATION
-- reference to administration_administrationdepartment
CREATE TABLE administration_administration (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    phone_number VARCHAR(11) NOT NULL,
    email VARCHAR(150) NOT NULL,
    designation VARCHAR(200) NOT NULL,
    faculty_name VARCHAR(200) NOT NULL, -- Already existed
    priority INTEGER NOT NULL,
    profile_pic VARCHAR(100),

    -- Foreign Key Columns
    department_name VARCHAR(200) NOT NULL, -- Replaces department_id

    CONSTRAINT fk_admin_department_composite
        FOREIGN KEY (faculty_name, department_name)
        REFERENCES administration_administrationdepartment (faculty, department)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 9. SERVICE DEPARTMENT
CREATE TABLE administration_servicedepartment (
    faculty_name VARCHAR(200) NOT NULL,
    department VARCHAR(200) NOT NULL,
    PRIMARY KEY (faculty_name, department)
);

-- 10. SERVICES
-- reference to  administration_servicedepartment
CREATE TABLE administration_services (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(200),
    phone VARCHAR(20) NOT NULL,
    designation VARCHAR(200),
    email VARCHAR(254),
    priority INTEGER NOT NULL,

    -- Foreign Key Columns
    faculty_name VARCHAR(200) NOT NULL,    -- Added to support composite key
    department_name VARCHAR(200) NOT NULL, -- Replaces department_id

    CONSTRAINT fk_services_department
        FOREIGN KEY (faculty_name, department_name)
        REFERENCES administration_servicedepartment (faculty_name, department)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 11. Courses
CREATE TABLE course_course (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    course_title VARCHAR(200) NOT NULL,
    course_code VARCHAR(200) NOT NULL,
    credit_hour NUMERIC(5,2) NOT NULL,
    faculty VARCHAR(200) NOT NULL,
    semester VARCHAR(200) NOT NULL
);


-- =========================
-- =========================
-- VIEWS
-- =========================
-- =========================

-- DROP VIEW IF EXISTS public.global_search_view;
CREATE VIEW public.global_search_view WITH (security_invoker = on) AS

-- 1. TEACHER
SELECT 
    'teacher'::text AS type,
    academy_teacher.id::text AS reference_id,
    academy_teacher.name AS title,
    academy_teacher.designation AS subtitle,
    academy_teacher.email AS details,
    -- Normalized Columns
    academy_teacher.phone_number,
    academy_teacher.designation,
    academy_teacher.faculty_name AS faculty,
    academy_teacher.department_name AS department,
    academy_teacher.profile_pic, -- Added profile_pic
    -- Search Text (Concatenates all fields for easy filtering)
    (
        COALESCE(academy_teacher.name, '') || ' ' || 
        COALESCE(academy_teacher.designation, '') || ' ' || 
        COALESCE(academy_teacher.faculty_name, '') || ' ' || 
        COALESCE(academy_teacher.department_name, '') || ' ' || 
        COALESCE(academy_teacher.phone_number, '') || ' ' || 
        COALESCE(academy_teacher.email, '')
    ) AS search_text
FROM academy_teacher

UNION ALL

-- 2. STAFF
SELECT 
    'staff'::text AS type,
    academy_staff.id::text AS reference_id,
    academy_staff.name AS title,
    academy_staff.designation AS subtitle,
    academy_staff.email AS details,
    -- Normalized Columns
    academy_staff.phone_number,
    academy_staff.designation,
    academy_staff.faculty,
    academy_staff.department,
    NULL::text AS profile_pic, -- No profile_pic column in staff table
    -- Search Text
    (
        COALESCE(academy_staff.name, '') || ' ' || 
        COALESCE(academy_staff.designation, '') || ' ' || 
        COALESCE(academy_staff.faculty, '') || ' ' || 
        COALESCE(academy_staff.department, '') || ' ' || 
        COALESCE(academy_staff.phone_number, '') || ' ' || 
        COALESCE(academy_staff.email, '')
    ) AS search_text
FROM academy_staff

UNION ALL

-- 3. DEAN OFFICE
SELECT 
    'dean_office'::text AS type,
    academy_deanoffice.id::text AS reference_id,
    academy_deanoffice.name AS title,
    academy_deanoffice.designation AS subtitle,
    academy_deanoffice.email AS details,
    -- Normalized Columns
    academy_deanoffice.phone_number,
    academy_deanoffice.designation,
    academy_deanoffice.faculty,
    academy_deanoffice.department,
    NULL::text AS profile_pic, -- No profile_pic column in dean office table
    -- Search Text
    (
        COALESCE(academy_deanoffice.name, '') || ' ' || 
        COALESCE(academy_deanoffice.designation, '') || ' ' || 
        COALESCE(academy_deanoffice.faculty, '') || ' ' || 
        COALESCE(academy_deanoffice.department, '') || ' ' || 
        COALESCE(academy_deanoffice.phone_number, '') || ' ' || 
        COALESCE(academy_deanoffice.email, '')
    ) AS search_text
FROM academy_deanoffice

UNION ALL

-- 4. ADMINISTRATION
SELECT 
    'admin'::text AS type,
    administration_administration.id::text AS reference_id,
    administration_administration.name AS title,
    administration_administration.designation AS subtitle,
    administration_administration.email AS details,
    -- Normalized Columns
    administration_administration.phone_number,
    administration_administration.designation,
    administration_administration.faculty_name AS faculty,
    administration_administration.department_name AS department,
    administration_administration.profile_pic, -- Added profile_pic
    -- Search Text
    (
        COALESCE(administration_administration.name, '') || ' ' || 
        COALESCE(administration_administration.designation, '') || ' ' || 
        COALESCE(administration_administration.faculty_name, '') || ' ' || 
        COALESCE(administration_administration.department_name, '') || ' ' || 
        COALESCE(administration_administration.phone_number, '') || ' ' || 
        COALESCE(administration_administration.email, '')
    ) AS search_text
FROM administration_administration

UNION ALL

-- 5. SERVICES
-- Note: 'phone' is aliased to 'phone_number' to match other tables
SELECT 
    'service'::text AS type,
    administration_services.id::text AS reference_id,
    administration_services.name AS title,
    administration_services.designation AS subtitle,
    administration_services.email AS details,
    -- Normalized Columns
    administration_services.phone AS phone_number,
    administration_services.designation,
    administration_services.faculty_name AS faculty,
    administration_services.department_name AS department,
    NULL::text AS profile_pic, -- No profile_pic column in services table
    -- Search Text
    (
        COALESCE(administration_services.name, '') || ' ' || 
        COALESCE(administration_services.designation, '') || ' ' || 
        COALESCE(administration_services.faculty_name, '') || ' ' || 
        COALESCE(administration_services.department_name, '') || ' ' || 
        COALESCE(administration_services.phone, '') || ' ' || 
        COALESCE(administration_services.email, '')
    ) AS search_text
FROM administration_services;

-- =========================
-- PROFILES TABLES
-- =========================

-- profiles table
create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  username text,
  role text not null default 'user'
);

-- Automatically create a profile when a new user signs up
drop function if exists handle_new_user();
create function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public, pg_catalog
as $$
begin
  insert into public.profiles (id)
  values (new.id);
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

-- =========================
-- =========================
-- POLICIES
-- =========================
-- =========================
alter table public.profiles enable row level security;
drop policy if exists "Enable read access for all users" on public.profiles;
create policy "Enable read access for all users"
  on public.profiles
  to public
  using (true);

drop policy if exists "Admins can insert profiles" on public.profiles;
create policy "Admins can insert profiles"
  on public.profiles
  for insert
  to authenticated
  with check (
    exists (
      select 1
      from public.profiles p
      where p.id = auth.uid()
        and p.role = 'admin'
    )
  );

drop policy if exists "Admins can update profiles" on public.profiles;
create policy "Admins can update profiles"
  on public.profiles
  for update
  to authenticated
  using (
    exists (
      select 1
      from public.profiles p
      where p.id = auth.uid()
        and p.role = 'admin'
    )
  )
  with check (
    exists (
      select 1
      from public.profiles p
      where p.id = auth.uid()
        and p.role = 'admin'
    )
  );

drop policy if exists "Admins can delete profiles" on public.profiles;
create policy "Admins can delete profiles"
  on public.profiles
  for delete
  to authenticated
  using (
    exists (
      select 1
      from public.profiles p
      where p.id = auth.uid()
        and p.role = 'admin'
    )
  );

-- academy_deanfaculty
alter table public.academy_deanfaculty enable row level security;
drop policy if exists "Enable read access for all users" on public.academy_deanfaculty;
create policy "Enable read access for all users"
  on public.academy_deanfaculty
  to public
  using (true);

drop policy if exists "Admins can insert academy_deanfaculty" on public.academy_deanfaculty;
create policy "Admins can insert academy_deanfaculty"
  on public.academy_deanfaculty
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can update academy_deanfaculty" on public.academy_deanfaculty;
create policy "Admins can update academy_deanfaculty"
  on public.academy_deanfaculty
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can delete academy_deanfaculty" on public.academy_deanfaculty;
create policy "Admins can delete academy_deanfaculty"
  on public.academy_deanfaculty
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

-- academy_deanoffice
alter table public.academy_deanoffice enable row level security;
drop policy if exists "Enable read access for all users" on public.academy_deanoffice;
create policy "Enable read access for all users"
  on public.academy_deanoffice
  to public
  using (true);

drop policy if exists "Admins can insert academy_deanoffice" on public.academy_deanoffice;
create policy "Admins can insert academy_deanoffice"
  on public.academy_deanoffice
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can update academy_deanoffice" on public.academy_deanoffice;
create policy "Admins can update academy_deanoffice"
  on public.academy_deanoffice
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can delete academy_deanoffice" on public.academy_deanoffice;
create policy "Admins can delete academy_deanoffice"
  on public.academy_deanoffice
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

-- academy_department
alter table public.academy_department enable row level security;
drop policy if exists "Enable read access for all users" on public.academy_department;
create policy "Enable read access for all users"
  on public.academy_department
  to public
  using (true);

drop policy if exists "Admins can insert academy_department" on public.academy_department;
create policy "Admins can insert academy_department"
  on public.academy_department
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can update academy_department" on public.academy_department;
create policy "Admins can update academy_department"
  on public.academy_department
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can delete academy_department" on public.academy_department;
create policy "Admins can delete academy_department"
  on public.academy_department
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

-- academy_staffdepartment
alter table public.academy_staffdepartment enable row level security;
drop policy if exists "Enable read access for all users" on public.academy_staffdepartment;
create policy "Enable read access for all users"
  on public.academy_staffdepartment
  to public
  using (true);

drop policy if exists "Admins can insert academy_staffdepartment" on public.academy_staffdepartment;
create policy "Admins can insert academy_staffdepartment"
  on public.academy_staffdepartment
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can update academy_staffdepartment" on public.academy_staffdepartment;
create policy "Admins can update academy_staffdepartment"
  on public.academy_staffdepartment
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can delete academy_staffdepartment" on public.academy_staffdepartment;
create policy "Admins can delete academy_staffdepartment"
  on public.academy_staffdepartment
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

-- academy_staff
alter table public.academy_staff enable row level security;
drop policy if exists "Enable read access for all users" on public.academy_staff;
create policy "Enable read access for all users"
  on public.academy_staff
  to public
  using (true);

drop policy if exists "Admins can insert academy_staff" on public.academy_staff;
create policy "Admins can insert academy_staff"
  on public.academy_staff
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can update academy_staff" on public.academy_staff;
create policy "Admins can update academy_staff"
  on public.academy_staff
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can delete academy_staff" on public.academy_staff;
create policy "Admins can delete academy_staff"
  on public.academy_staff
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

-- academy_teacher
alter table public.academy_teacher enable row level security;
drop policy if exists "Enable read access for all users" on public.academy_teacher;
create policy "Enable read access for all users"
  on public.academy_teacher
  to public
  using (true);

drop policy if exists "Admins can insert academy_teacher" on public.academy_teacher;
create policy "Admins can insert academy_teacher"
  on public.academy_teacher
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can update academy_teacher" on public.academy_teacher;
create policy "Admins can update academy_teacher"
  on public.academy_teacher
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can delete academy_teacher" on public.academy_teacher;
create policy "Admins can delete academy_teacher"
  on public.academy_teacher
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

-- administration_administrationdepartment
alter table public.administration_administrationdepartment enable row level security;
drop policy if exists "Enable read access for all users" on public.administration_administrationdepartment;
create policy "Enable read access for all users"
  on public.administration_administrationdepartment
  to public
  using (true);

drop policy if exists "Admins can insert administration_administrationdepartment" on public.administration_administrationdepartment;
create policy "Admins can insert administration_administrationdepartment"
  on public.administration_administrationdepartment
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can update administration_administrationdepartment" on public.administration_administrationdepartment;
create policy "Admins can update administration_administrationdepartment"
  on public.administration_administrationdepartment
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can delete administration_administrationdepartment" on public.administration_administrationdepartment;
create policy "Admins can delete administration_administrationdepartment"
  on public.administration_administrationdepartment
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

-- administration_administration
alter table public.administration_administration enable row level security;
drop policy if exists "Enable read access for all users" on public.administration_administration;
create policy "Enable read access for all users"
  on public.administration_administration
  to public
  using (true);

drop policy if exists "Admins can insert administration_administration" on public.administration_administration;
create policy "Admins can insert administration_administration"
  on public.administration_administration
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can update administration_administration" on public.administration_administration;
create policy "Admins can update administration_administration"
  on public.administration_administration
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can delete administration_administration" on public.administration_administration;
create policy "Admins can delete administration_administration"
  on public.administration_administration
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

-- administration_servicedepartment
alter table public.administration_servicedepartment enable row level security;
drop policy if exists "Enable read access for all users" on public.administration_servicedepartment;
create policy "Enable read access for all users"
  on public.administration_servicedepartment
  to public
  using (true);

drop policy if exists "Admins can insert administration_servicedepartment" on public.administration_servicedepartment;
create policy "Admins can insert administration_servicedepartment"
  on public.administration_servicedepartment
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can update administration_servicedepartment" on public.administration_servicedepartment;
create policy "Admins can update administration_servicedepartment"
  on public.administration_servicedepartment
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can delete administration_servicedepartment" on public.administration_servicedepartment;
create policy "Admins can delete administration_servicedepartment"
  on public.administration_servicedepartment
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

-- administration_services
alter table public.administration_services enable row level security;
drop policy if exists "Enable read access for all users" on public.administration_services;
create policy "Enable read access for all users"
  on public.administration_services
  to public
  using (true);

drop policy if exists "Admins can insert administration_services" on public.administration_services;
create policy "Admins can insert administration_services"
  on public.administration_services
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can update administration_services" on public.administration_services;
create policy "Admins can update administration_services"
  on public.administration_services
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can delete administration_services" on public.administration_services;
create policy "Admins can delete administration_services"
  on public.administration_services
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

-- course_course
alter table public.course_course enable row level security;
drop policy if exists "Enable read access for all users" on public.course_course;
create policy "Enable read access for all users"
  on public.course_course
  to public
  using (true);

drop policy if exists "Admins can insert course_course" on public.course_course;
create policy "Admins can insert course_course"
  on public.course_course
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can update course_course" on public.course_course;
create policy "Admins can update course_course"
  on public.course_course
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

drop policy if exists "Admins can delete course_course" on public.course_course;
create policy "Admins can delete course_course"
  on public.course_course
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );


-- =========================
-- =========================
-- POLICIES
-- =========================
-- =========================
alter table public.profiles enable row level security;
drop policy if exists "Enable read access for all users" on public.profiles;
create policy "Enable read access for all users"
  on public.profiles
  to public
  using (true);

-- =========================
-- editors can't insert/update/delete profiles
-- =========================

-- academy_deanfaculty
alter table public.academy_deanfaculty enable row level security;
drop policy if exists "Enable read access for all users" on public.academy_deanfaculty;
create policy "Enable read access for all users"
  on public.academy_deanfaculty
  to public
  using (true);

drop policy if exists "Editors can insert academy_deanfaculty" on public.academy_deanfaculty;
create policy "Editors can insert academy_deanfaculty"
  on public.academy_deanfaculty
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can update academy_deanfaculty" on public.academy_deanfaculty;
create policy "Editors can update academy_deanfaculty"
  on public.academy_deanfaculty
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can delete academy_deanfaculty" on public.academy_deanfaculty;
create policy "Editors can delete academy_deanfaculty"
  on public.academy_deanfaculty
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

-- academy_deanoffice
alter table public.academy_deanoffice enable row level security;
drop policy if exists "Enable read access for all users" on public.academy_deanoffice;
create policy "Enable read access for all users"
  on public.academy_deanoffice
  to public
  using (true);

drop policy if exists "Editors can insert academy_deanoffice" on public.academy_deanoffice;
create policy "Editors can insert academy_deanoffice"
  on public.academy_deanoffice
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can update academy_deanoffice" on public.academy_deanoffice;
create policy "Editors can update academy_deanoffice"
  on public.academy_deanoffice
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can delete academy_deanoffice" on public.academy_deanoffice;
create policy "Editors can delete academy_deanoffice"
  on public.academy_deanoffice
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

-- academy_department
alter table public.academy_department enable row level security;
drop policy if exists "Enable read access for all users" on public.academy_department;
create policy "Enable read access for all users"
  on public.academy_department
  to public
  using (true);

drop policy if exists "Editors can insert academy_department" on public.academy_department;
create policy "Editors can insert academy_department"
  on public.academy_department
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can update academy_department" on public.academy_department;
create policy "Editors can update academy_department"
  on public.academy_department
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can delete academy_department" on public.academy_department;
create policy "Editors can delete academy_department"
  on public.academy_department
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

-- academy_staffdepartment
alter table public.academy_staffdepartment enable row level security;
drop policy if exists "Enable read access for all users" on public.academy_staffdepartment;
create policy "Enable read access for all users"
  on public.academy_staffdepartment
  to public
  using (true);

drop policy if exists "Editors can insert academy_staffdepartment" on public.academy_staffdepartment;
create policy "Editors can insert academy_staffdepartment"
  on public.academy_staffdepartment
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can update academy_staffdepartment" on public.academy_staffdepartment;
create policy "Editors can update academy_staffdepartment"
  on public.academy_staffdepartment
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can delete academy_staffdepartment" on public.academy_staffdepartment;
create policy "Editors can delete academy_staffdepartment"
  on public.academy_staffdepartment
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

-- academy_staff
alter table public.academy_staff enable row level security;
drop policy if exists "Enable read access for all users" on public.academy_staff;
create policy "Enable read access for all users"
  on public.academy_staff
  to public
  using (true);

drop policy if exists "Editors can insert academy_staff" on public.academy_staff;
create policy "Editors can insert academy_staff"
  on public.academy_staff
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can update academy_staff" on public.academy_staff;
create policy "Editors can update academy_staff"
  on public.academy_staff
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can delete academy_staff" on public.academy_staff;
create policy "Editors can delete academy_staff"
  on public.academy_staff
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

-- academy_teacher
alter table public.academy_teacher enable row level security;
drop policy if exists "Enable read access for all users" on public.academy_teacher;
create policy "Enable read access for all users"
  on public.academy_teacher
  to public
  using (true);

drop policy if exists "Editors can insert academy_teacher" on public.academy_teacher;
create policy "Editors can insert academy_teacher"
  on public.academy_teacher
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can update academy_teacher" on public.academy_teacher;
create policy "Editors can update academy_teacher"
  on public.academy_teacher
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can delete academy_teacher" on public.academy_teacher;
create policy "Editors can delete academy_teacher"
  on public.academy_teacher
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

-- administration_administrationdepartment
alter table public.administration_administrationdepartment enable row level security;
drop policy if exists "Enable read access for all users" on public.administration_administrationdepartment;
create policy "Enable read access for all users"
  on public.administration_administrationdepartment
  to public
  using (true);

drop policy if exists "Editors can insert administration_administrationdepartment" on public.administration_administrationdepartment;
create policy "Editors can insert administration_administrationdepartment"
  on public.administration_administrationdepartment
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can update administration_administrationdepartment" on public.administration_administrationdepartment;
create policy "Editors can update administration_administrationdepartment"
  on public.administration_administrationdepartment
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can delete administration_administrationdepartment" on public.administration_administrationdepartment;
create policy "Editors can delete administration_administrationdepartment"
  on public.administration_administrationdepartment
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

-- administration_administration
alter table public.administration_administration enable row level security;
drop policy if exists "Enable read access for all users" on public.administration_administration;
create policy "Enable read access for all users"
  on public.administration_administration
  to public
  using (true);

drop policy if exists "Editors can insert administration_administration" on public.administration_administration;
create policy "Editors can insert administration_administration"
  on public.administration_administration
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can update administration_administration" on public.administration_administration;
create policy "Editors can update administration_administration"
  on public.administration_administration
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can delete administration_administration" on public.administration_administration;
create policy "Editors can delete administration_administration"
  on public.administration_administration
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

-- administration_servicedepartment
alter table public.administration_servicedepartment enable row level security;
drop policy if exists "Enable read access for all users" on public.administration_servicedepartment;
create policy "Enable read access for all users"
  on public.administration_servicedepartment
  to public
  using (true);

drop policy if exists "Editors can insert administration_servicedepartment" on public.administration_servicedepartment;
create policy "Editors can insert administration_servicedepartment"
  on public.administration_servicedepartment
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can update administration_servicedepartment" on public.administration_servicedepartment;
create policy "Editors can update administration_servicedepartment"
  on public.administration_servicedepartment
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can delete administration_servicedepartment" on public.administration_servicedepartment;
create policy "Editors can delete administration_servicedepartment"
  on public.administration_servicedepartment
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

-- administration_services
alter table public.administration_services enable row level security;
drop policy if exists "Enable read access for all users" on public.administration_services;
create policy "Enable read access for all users"
  on public.administration_services
  to public
  using (true);

drop policy if exists "Editors can insert administration_services" on public.administration_services;
create policy "Editors can insert administration_services"
  on public.administration_services
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can update administration_services" on public.administration_services;
create policy "Editors can update administration_services"
  on public.administration_services
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can delete administration_services" on public.administration_services;
create policy "Editors can delete administration_services"
  on public.administration_services
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

-- course_course
alter table public.course_course enable row level security;
drop policy if exists "Enable read access for all users" on public.course_course;
create policy "Enable read access for all users"
  on public.course_course
  to public
  using (true);

drop policy if exists "Editors can insert course_course" on public.course_course;
create policy "Editors can insert course_course"
  on public.course_course
  for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can update course_course" on public.course_course;
create policy "Editors can update course_course"
  on public.course_course
  for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );

drop policy if exists "Editors can delete course_course" on public.course_course;
create policy "Editors can delete course_course"
  on public.course_course
  for delete
  to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'editor'
    )
  );
