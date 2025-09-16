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
-- ACADEMY TABLES
-- =========================
CREATE TABLE academy_deanfaculty (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    faculty VARCHAR(200) NOT NULL,
    department VARCHAR(200) NOT NULL
);

CREATE TABLE academy_deanoffice (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    phone_number VARCHAR(11) NOT NULL,
    email VARCHAR(150) NOT NULL,
    designation VARCHAR(200) NOT NULL,
    faculty VARCHAR(200) NOT NULL,
    priority INTEGER NOT NULL,
    department_id BIGINT NOT NULL,
    CONSTRAINT fk_deanoffice_department
        FOREIGN KEY (department_id) REFERENCES academy_deanfaculty (id)
        ON DELETE CASCADE
);

CREATE TABLE academy_department (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    faculty VARCHAR(200) NOT NULL,
    department VARCHAR(200) NOT NULL
);

CREATE TABLE academy_staffdepartment (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    faculty VARCHAR(200) NOT NULL,
    department VARCHAR(200) NOT NULL
);

CREATE TABLE academy_staff (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    phone_number VARCHAR(11) NOT NULL,
    email VARCHAR(150),
    designation VARCHAR(200) NOT NULL,
    faculty VARCHAR(200) NOT NULL,
    priority INTEGER NOT NULL,
    department_id BIGINT NOT NULL,
    CONSTRAINT fk_staff_department
        FOREIGN KEY (department_id) REFERENCES academy_staffdepartment (id)
        ON DELETE CASCADE
);

CREATE TABLE academy_teacher (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    phone_number VARCHAR(11) NOT NULL,
    profile_pic VARCHAR(100),
    email VARCHAR(150) NOT NULL,
    designation VARCHAR(200) NOT NULL,
    faculty_name VARCHAR(200) NOT NULL,
    priority INTEGER NOT NULL,
    department_id BIGINT NOT NULL
    -- Add FK if needed
);

-- =========================
-- ADMINISTRATION TABLES
-- =========================
CREATE TABLE administration_administrationdepartment (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    faculty VARCHAR(200) NOT NULL,
    department VARCHAR(200) NOT NULL
);

CREATE TABLE administration_administration (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    phone_number VARCHAR(11) NOT NULL,
    email VARCHAR(150) NOT NULL,
    designation VARCHAR(200) NOT NULL,
    faculty_name VARCHAR(200) NOT NULL,
    priority INTEGER NOT NULL,
    department_id BIGINT NOT NULL,
    profile_pic VARCHAR(100),
    CONSTRAINT fk_admin_department
        FOREIGN KEY (department_id) REFERENCES administration_administrationdepartment (id)
        ON DELETE CASCADE
);

CREATE TABLE administration_servicedepartment (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    faculty_name VARCHAR(200) NOT NULL,
    department VARCHAR(200) NOT NULL
);

CREATE TABLE administration_services (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(200),
    phone VARCHAR(20) NOT NULL,
    designation VARCHAR(200),
    email VARCHAR(254),
    priority INTEGER NOT NULL,
    department_id BIGINT NOT NULL,
    CONSTRAINT fk_services_department
        FOREIGN KEY (department_id) REFERENCES administration_servicedepartment (id)
        ON DELETE CASCADE
);

-- =========================
-- COURSE TABLE
-- =========================
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
