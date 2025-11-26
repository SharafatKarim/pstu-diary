# PSTU Diary

PSTU Diary is a cross-platform application designed to help students and faculty members of Patuakhali Science and Technology University (PSTU) efficiently access resources and contact information of various departments, faculties, and administrative offices. The app aims to provide a user-friendly interface for quick navigation and retrieval of essential information, enhancing the overall experience of the university community.

It stores contact information of our University "Patuakhali Science and Technology University" all employees including Teacher, Staff, MLSS and Others who are directly or indirectly related to this University. Contact information includes phone number, email address, photo etc.

## Setups

Follow these steps to set up the project locally.

1) Prerequisites

- Flutter (stable channel) and a connected device/emulator
- A Supabase account and project

> [!TIP]
> Verify your Flutter install with:  
>
> ```shell
> flutter doctor
> ```

2) Clone the repository

```shell
git clone https://github.com/SharafatKarim/pstu-diary.git
cd pstu-diary
```

3) Configure Supabase

- Create a new Supabase project and note the Project URL and anon/public API key.
- In Supabase, open SQL Editor → New query → paste and run the SQL from:
    db/DDL.sql
- Copy the sample env file and fill in your keys (keep this file at the project root):

```shell
cp .env.sample .env
```

Then edit .env:

```shell
SUPABASE_URL=<your-project-url>
SUPABASE_ANON_KEY=<your-anon-key>
```

4) Install dependencies and run

```shell
flutter pub get
flutter run
```

> [!CAUTION]
> Note: Ensure your emulator/device is running before executing flutter run.
