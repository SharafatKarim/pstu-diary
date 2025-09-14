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

-- Enable read access for all users
alter policy "Enable read access for all users"
  on "public"."profiles"
  to public
  using (
    true
  );
