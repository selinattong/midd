create table if not exists public.forum_comments (
  id bigint generated always as identity primary key,
  nickname text not null check (char_length(nickname) between 1 and 24),
  message text not null check (char_length(message) between 1 and 500),
  created_at timestamptz not null default now()
);

alter table public.forum_comments enable row level security;

drop policy if exists "Anyone can read forum comments" on public.forum_comments;
create policy "Anyone can read forum comments"
  on public.forum_comments
  for select
  to anon
  using (true);

drop policy if exists "Anyone can post bounded forum comments" on public.forum_comments;
create policy "Anyone can post bounded forum comments"
  on public.forum_comments
  for insert
  to anon
  with check (
    char_length(trim(nickname)) between 1 and 24
    and char_length(trim(message)) between 1 and 500
  );

grant select, insert on public.forum_comments to anon;
grant usage, select on sequence public.forum_comments_id_seq to anon;
